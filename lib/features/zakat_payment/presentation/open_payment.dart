import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/network/api_envelope.dart';
import '../data/repository/zakat_payment_repository.dart';

/// Reloads a payment and opens it on the flow screen, which shows the right
/// step: continue confirming, enter the code, still confirming, or the
/// result (with its certificate when paid).
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
    final payment = await getIt<ZakatPaymentRepository>().fetchPayment(
      paymentId,
    );
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
