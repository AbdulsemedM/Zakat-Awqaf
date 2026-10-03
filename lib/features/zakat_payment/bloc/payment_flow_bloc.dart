import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_envelope.dart';
import '../data/models/zakat_payment_models.dart';
import '../data/repository/zakat_payment_repository.dart';

sealed class PaymentFlowEvent extends Equatable {
  const PaymentFlowEvent();

  @override
  List<Object?> get props => [];
}

/// Step 2: "Yes, this is my account, send the code".
final class PaymentAccountConfirmed extends PaymentFlowEvent {
  const PaymentAccountConfirmed();
}

/// "Not my account" or leaving before paying.
final class PaymentCancelRequested extends PaymentFlowEvent {
  const PaymentCancelRequested();
}

final class PaymentOtpResendRequested extends PaymentFlowEvent {
  const PaymentOtpResendRequested();
}

/// Step 3: verify the code and pay.
final class PaymentOtpSubmitted extends PaymentFlowEvent {
  const PaymentOtpSubmitted(this.otp);

  final String otp;

  @override
  List<Object?> get props => [otp];
}

/// Reloads the payment (polling while processing, or after an unclear
/// response).
final class PaymentStatusRefreshRequested extends PaymentFlowEvent {
  const PaymentStatusRefreshRequested();
}

class PaymentFlowState extends Equatable {
  const PaymentFlowState({
    required this.payment,
    this.busy = false,
    this.errorMessage,
    this.errorCode,
  });

  final ZakatPayment payment;
  final bool busy;

  /// The server's message for the last failed action (shown as is).
  final String? errorMessage;

  /// Its `code`, e.g. `OTP_WRONG`, `OTP_EXPIRED`, `OTP_RESEND_LIMIT`.
  final String? errorCode;

  bool get otpExpired => errorCode == 'OTP_EXPIRED';

  bool get canResend =>
      (payment.otpResendsLeft ?? 1) > 0 && errorCode != 'OTP_RESEND_LIMIT';

  PaymentFlowState copyWith({
    ZakatPayment? payment,
    bool? busy,
    String? Function()? errorMessage,
    String? Function()? errorCode,
  }) {
    return PaymentFlowState(
      payment: payment ?? this.payment,
      busy: busy ?? this.busy,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      errorCode: errorCode != null ? errorCode() : this.errorCode,
    );
  }

  @override
  List<Object?> get props => [payment, busy, errorMessage, errorCode];
}

/// Drives a started zakat payment from the account confirmation to the
/// result. Step 1 (start) happens on the payment form.
@injectable
class PaymentFlowBloc extends Bloc<PaymentFlowEvent, PaymentFlowState> {
  PaymentFlowBloc(this._repository, @factoryParam ZakatPayment payment)
    : super(PaymentFlowState(payment: payment)) {
    on<PaymentAccountConfirmed>(
      (event, emit) =>
          _run(emit, () => _repository.confirmAccount(state.payment.paymentId)),
    );
    on<PaymentOtpResendRequested>(
      (event, emit) =>
          _run(emit, () => _repository.resendOtp(state.payment.paymentId)),
    );
    on<PaymentCancelRequested>(
      (event, emit) =>
          _run(emit, () => _repository.cancel(state.payment.paymentId)),
    );
    on<PaymentOtpSubmitted>(
      (event, emit) => _run(
        emit,
        () => _repository.verifyOtp(state.payment.paymentId, event.otp),
      ),
    );
    on<PaymentStatusRefreshRequested>(
      (event, emit) =>
          _run(emit, () => _repository.fetchPayment(state.payment.paymentId)),
    );
    _schedulePolling(state.payment);
  }

  /// How often to check a payment the bank has not answered yet.
  static const pollInterval = Duration(seconds: 10);

  final ZakatPaymentRepository _repository;
  Timer? _pollTimer;

  Future<void> _run(
    Emitter<PaymentFlowState> emit,
    Future<ZakatPayment> Function() call,
  ) async {
    if (state.busy) return;
    emit(
      state.copyWith(
        busy: true,
        errorMessage: () => null,
        errorCode: () => null,
      ),
    );
    try {
      final payment = await call();
      _apply(emit, payment);
    } on ApiException catch (e) {
      await _onError(emit, e);
    }
  }

  void _apply(Emitter<PaymentFlowState> emit, ZakatPayment payment) {
    emit(state.copyWith(payment: payment, busy: false));
    _schedulePolling(payment);
  }

  Future<void> _onError(Emitter<PaymentFlowState> emit, ApiException e) async {
    switch (e.code) {
      // The server's state moved on: show what it is now.
      case 'OTP_LOCKED' ||
          'PAYMENT_EXPIRED' ||
          'INVALID_STATE' ||
          'ALREADY_PROCESSING':
        await _recover(emit, message: e.message, code: e.code);
      case 'OTP_WRONG' || 'OTP_EXPIRED' || 'OTP_RESEND_LIMIT':
        emit(
          state.copyWith(
            busy: false,
            payment: _withOtpCounts(state.payment, e.data),
            errorMessage: () => e.message,
            errorCode: () => e.code,
          ),
        );
      default:
        // No response: the action may have happened. Never repeat
        // verify-otp blindly; ask for the payment's current state.
        if (e.noResponse || e.statusCode == null) {
          await _recover(emit, message: e.message, code: null);
        } else {
          emit(
            state.copyWith(
              busy: false,
              errorMessage: () => e.message,
              errorCode: () => e.code,
            ),
          );
        }
    }
  }

  Future<void> _recover(
    Emitter<PaymentFlowState> emit, {
    required String message,
    required String? code,
  }) async {
    try {
      final payment = await _repository.fetchPayment(state.payment.paymentId);
      emit(
        state.copyWith(
          payment: payment,
          busy: false,
          // Keep the message only when the payment is still waiting for
          // the donor (e.g. a code that was not accepted).
          errorMessage: () => payment.isFinal ? null : message,
          errorCode: () => payment.isFinal ? null : code,
        ),
      );
      _schedulePolling(payment);
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorMessage: () => e.message,
          errorCode: () => e.code,
        ),
      );
    }
  }

  static ZakatPayment _withOtpCounts(
    ZakatPayment payment,
    Map<String, dynamic> data,
  ) => payment.withOtpCounts(
    attemptsLeft: jsonInt(data['attemptsLeft']),
    resendsLeft: jsonInt(data['resendsLeft']),
  );

  void _schedulePolling(ZakatPayment payment) {
    final processing =
        payment.status == PaymentStatus.pending &&
        payment.step == PaymentStep.processing;
    if (!processing) {
      _pollTimer?.cancel();
      _pollTimer = null;
      return;
    }
    _pollTimer ??= Timer.periodic(
      pollInterval,
      (_) => add(const PaymentStatusRefreshRequested()),
    );
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
