import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/network/api_envelope.dart';
import '../data/repository/zakat_payment_repository.dart';

/// Reloads a payment and opens it on the flow screen: the QR, or the result
/// (with its certificate when paid). A pending or expired QR is checked
/// with the bank first, which confirms a late payment sooner.
Future<void> openPayment(BuildContext context, String paymentId) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  try {
    final repository = getIt<ZakatPaymentRepository>();
    var payment = await repository.fetchPayment(paymentId);
    if (payment.canCheckPayment) {
      try {
        payment = await repository.checkPayment(paymentId);
      } on ApiException {
        // e.g. 409 for an older payment: show what the status read said.
      }
    }
    navigator.pop();
    if (!context.mounted) return;
    await context.push('/zakat/payment/flow', extra: payment);
  } on ApiException catch (e) {
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(e.noResponse ? l10n.payNetworkError : l10n.payOpenError),
      ),
    );
  }
}
