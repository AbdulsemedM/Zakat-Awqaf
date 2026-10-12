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

/// The donor says they paid the QR: show "We are confirming your payment"
/// while the commission confirms it.
final class PaymentQrPaidReported extends PaymentFlowEvent {
  const PaymentQrPaidReported();
}

/// The donor did not pay and leaves: the QR is not shown again.
final class PaymentCancelRequested extends PaymentFlowEvent {
  const PaymentCancelRequested();
}

/// "Check again".
final class PaymentStatusRefreshRequested extends PaymentFlowEvent {
  const PaymentStatusRefreshRequested();
}

/// A background status check: no spinner, and a failed check is ignored
/// (the next one tries again).
final class _PaymentPolled extends PaymentFlowEvent {
  const _PaymentPolled();
}

class PaymentFlowState extends Equatable {
  const PaymentFlowState({
    required this.payment,
    this.busy = false,
    this.qrPaidReported = false,
    this.errorMessage,
    this.errorCode,
  });

  final ZakatPayment payment;
  final bool busy;

  /// The donor tapped "I have paid" on the QR.
  final bool qrPaidReported;

  /// The server's message for the last failed action (shown as is).
  final String? errorMessage;

  /// Its `code`, e.g. `INVALID_STATE`.
  final String? errorCode;

  PaymentFlowState copyWith({
    ZakatPayment? payment,
    bool? busy,
    bool? qrPaidReported,
    String? Function()? errorMessage,
    String? Function()? errorCode,
  }) {
    return PaymentFlowState(
      payment: payment ?? this.payment,
      busy: busy ?? this.busy,
      qrPaidReported: qrPaidReported ?? this.qrPaidReported,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      errorCode: errorCode != null ? errorCode() : this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
    payment,
    busy,
    qrPaidReported,
    errorMessage,
    errorCode,
  ];
}

/// Watches a started zakat payment until it is final: the QR waiting for
/// the donor's bank app and the commission's confirmation. The payment is
/// started on the payment form.
@injectable
class PaymentFlowBloc extends Bloc<PaymentFlowEvent, PaymentFlowState> {
  PaymentFlowBloc(this._repository, @factoryParam ZakatPayment payment)
    : super(PaymentFlowState(payment: payment)) {
    on<PaymentQrPaidReported>(
      (event, emit) => emit(state.copyWith(qrPaidReported: true)),
    );
    on<PaymentCancelRequested>(
      (event, emit) =>
          _run(emit, () => _repository.cancel(state.payment.paymentId)),
    );
    on<PaymentStatusRefreshRequested>(
      (event, emit) =>
          _run(emit, () => _repository.fetchPayment(state.payment.paymentId)),
    );
    on<_PaymentPolled>(_onPolled);
    _schedulePolling(state.payment);
  }

  /// How often to check a pending payment while its screen is open.
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
      emit(state.copyWith(payment: payment, busy: false));
      _schedulePolling(payment);
    } on ApiException catch (e) {
      await _onError(emit, e);
    }
  }

  Future<void> _onError(Emitter<PaymentFlowState> emit, ApiException e) async {
    // The payment moved on (e.g. confirmed or expired before a cancel), or
    // there was no response: show what the server has now.
    final moved = e.code == 'INVALID_STATE' || e.code == 'PAYMENT_EXPIRED';
    if (!moved && !e.noResponse && e.statusCode != null) {
      emit(
        state.copyWith(
          busy: false,
          errorMessage: () => e.message,
          errorCode: () => e.code,
        ),
      );
      return;
    }
    try {
      final payment = await _repository.fetchPayment(state.payment.paymentId);
      emit(
        state.copyWith(
          payment: payment,
          busy: false,
          errorMessage: () => payment.isFinal ? null : e.message,
          errorCode: () => payment.isFinal ? null : e.code,
        ),
      );
      _schedulePolling(payment);
    } on ApiException catch (again) {
      emit(
        state.copyWith(
          busy: false,
          errorMessage: () => again.message,
          errorCode: () => again.code,
        ),
      );
    }
  }

  Future<void> _onPolled(
    _PaymentPolled event,
    Emitter<PaymentFlowState> emit,
  ) async {
    if (state.busy) return;
    try {
      final payment = await _repository.fetchPayment(state.payment.paymentId);
      if (state.busy) return;
      emit(state.copyWith(payment: payment));
      _schedulePolling(payment);
    } on ApiException {
      // Try again on the next tick.
    }
  }

  void _schedulePolling(ZakatPayment payment) {
    if (payment.isFinal) {
      _pollTimer?.cancel();
      _pollTimer = null;
      return;
    }
    _pollTimer ??= Timer.periodic(
      pollInterval,
      (_) => add(const _PaymentPolled()),
    );
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
