import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_envelope.dart';
import 'data_provider/device_payments_store.dart';
import 'repository/zakat_payment_repository.dart';

/// Re-checks the payments started on this device that are not settled yet:
/// when the app opens or comes back to the foreground, and every few
/// minutes while it is open. A QR payment is confirmed by the commission
/// minutes to hours after it was paid, and an expired one can still turn
/// `succeeded`. Each answer updates [DevicePaymentsStore].
@lazySingleton
class PendingPaymentsChecker with WidgetsBindingObserver {
  PendingPaymentsChecker(this._repository, this._store);

  static const interval = Duration(minutes: 3);

  final ZakatPaymentRepository _repository;
  final DevicePaymentsStore _store;

  Timer? _timer;
  bool _started = false;
  bool _checking = false;

  /// Called once at startup.
  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _resume();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resume();
    } else if (state == AppLifecycleState.paused) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _resume() {
    checkNow();
    _timer ??= Timer.periodic(interval, (_) => checkNow());
  }

  Future<void> checkNow() async {
    if (_checking) return;
    _checking = true;
    try {
      await _store.ready();
      final now = DateTime.now();
      final due = _store.payments.where((p) => p.needsCheck(now)).toList();
      for (final payment in due) {
        try {
          await _repository.fetchPayment(payment.paymentId);
        } on ApiException {
          // Offline, or no longer ours to read: try again next time.
        }
      }
    } finally {
      _checking = false;
    }
  }
}
