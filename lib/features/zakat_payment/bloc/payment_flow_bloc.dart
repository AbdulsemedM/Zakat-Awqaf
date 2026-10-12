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

/// "I have paid" (or the donor came back from the bank app): ask the server
/// to check with the bank.
final class PaymentCheckRequested extends PaymentFlowEvent {
  const PaymentCheckRequested({this.quiet = false});

  /// An automatic check (back from the bank app): no "not received yet"
  /// message when the payment hasn't arrived.
  final bool quiet;

  @override
  List<Object?> get props => [quiet];
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
    this.checking = false,
    this.notReceived = false,
    this.errorMessage,
    this.errorCode,
  });

  final ZakatPayment payment;
  final bool busy;

  /// A `check-payment` is running.
  final bool checking;

  /// The last check the donor asked for found no payment yet.
  final bool notReceived;

  /// The server's message for the last failed action (shown as is).
  final String? errorMessage;

  /// Its `code`, e.g. `INVALID_STATE`.
  final String? errorCode;

  PaymentFlowState copyWith({
    ZakatPayment? payment,
    bool? busy,
    bool? checking,
    bool? notReceived,
    String? Function()? errorMessage,
    String? Function()? errorCode,
  }) {
    return PaymentFlowState(
      payment: payment ?? this.payment,
      busy: busy ?? this.busy,
      checking: checking ?? this.checking,
      notReceived: notReceived ?? this.notReceived,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      errorCode: errorCode != null ? errorCode() : this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
    payment,
    busy,
    checking,
    notReceived,
    errorMessage,
    errorCode,
  ];
}

/// Watches a started zakat payment until it is final: the QR waiting for
/// the donor's bank app, and the checks with the bank once they say they
/// paid. The payment is started on the payment form.
@injectable
class PaymentFlowBloc extends Bloc<PaymentFlowEvent, PaymentFlowState> {
  PaymentFlowBloc(this._repository, @factoryParam ZakatPayment payment)
    : super(PaymentFlowState(payment: payment)) {
    on<PaymentCheckRequested>(_onCheck);
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

  /// A payment usually arrives within seconds: one more check after this
  /// before saying it has not arrived.
  static const checkRetryDelay = Duration(seconds: 5);

  final ZakatPaymentRepository _repository;
  Timer? _pollTimer;

  static bool _notArrived(ZakatPayment payment) =>
      payment.status == PaymentStatus.pending ||
      payment.status == PaymentStatus.expired;

  Future<void> _onCheck(
    PaymentCheckRequested event,
    Emitter<PaymentFlowState> emit,
  ) async {
    if (state.busy) return;
    emit(
      state.copyWith(
        busy: true,
        checking: true,
        notReceived: false,
        errorMessage: () => null,
        errorCode: () => null,
      ),
    );
    final id = state.payment.paymentId;
    try {
      var payment = await _repository.checkPayment(id);
      if (_notArrived(payment)) {
        await Future<void>.delayed(checkRetryDelay);
        if (isClosed) return;
        payment = await _repository.checkPayment(id);
      }
      emit(
        state.copyWith(
          payment: payment,
          busy: false,
          checking: false,
          notReceived: !event.quiet && _notArrived(payment),
        ),
      );
      _schedulePolling(payment);
    } on ApiException catch (e) {
      emit(state.copyWith(checking: false));
      // 409 INVALID_STATE: a QR from before `check-payment`, confirmed by
      // the commission. Show the server's state.
      await _onError(emit, e);
    }
  }

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
