import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/auth/payer_access.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/data_provider/device_payments_store.dart';
import '../open_payment.dart';
import 'payment_countdown.dart';

/// Home section for payments made on this device:
/// - "Unfinished payment" with a countdown, to resume it;
/// - a link to "Recent payments on this device" for guests (signed-in
///   donors have their server history in the profile).
/// Hidden when there is nothing to show, and for beneficiaries.
class DevicePaymentsSection extends StatelessWidget {
  const DevicePaymentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt<DevicePaymentsStore>();
    final access = getIt<PayerAccess>();
    return ListenableBuilder(
      listenable: Listenable.merge([store, access]),
      builder: (context, _) {
        if (!access.canPay || store.payments.isEmpty) {
          return const SizedBox.shrink();
        }
        final unfinished = store.unfinished(DateTime.now());
        final showRecent = !access.isSignedInDonor;
        if (unfinished == null && !showRecent) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (unfinished != null)
                UnfinishedPaymentCard(payment: unfinished),
              if (unfinished != null && showRecent) const SizedBox(height: 12),
              if (showRecent) const _RecentPaymentsLink(),
            ],
          ),
        );
      },
    );
  }
}

/// "Continue your payment": an open payment (with the time left before it
/// expires) or one the bank is still confirming.
class UnfinishedPaymentCard extends StatelessWidget {
  const UnfinishedPaymentCard({super.key, required this.payment});

  final DevicePayment payment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final expiresAt = payment.expiresAt;
    final store = getIt<DevicePaymentsStore>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tagGoldBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.tagGoldBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            payment.isProcessing
                ? Icons.hourglass_top_rounded
                : Icons.pending_actions_rounded,
            color: AppColors.goldDeep,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.isProcessing
                      ? l10n.payProcessingTitle
                      : l10n.unfinishedPaymentTitle,
                  style: AppTypography.body(
                    fontSize: 14,
                    color: AppColors.tagGoldText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    MoneyFormatter.etb(payment.amountEtb),
                    ?payment.causeTitle,
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body(
                    fontSize: 12,
                    color: AppColors.tagGoldText,
                  ),
                ),
                if (!payment.isProcessing && expiresAt != null)
                  PaymentCountdown(
                    deadline: expiresAt,
                    // Expired: the store no longer reports it as open.
                    onFinished: store.recheck,
                    builder: (context, remaining) => Text(
                      l10n.payFinishWithin(formatCountdown(remaining)),
                      style: AppTypography.body(
                        fontSize: 12,
                        color: scheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => openPayment(context, payment.paymentId),
            child: Text(
              payment.isProcessing
                  ? l10n.payCheckStatus
                  : l10n.unfinishedPaymentContinue,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentPaymentsLink extends StatelessWidget {
  const _RecentPaymentsLink();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return PremiumCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const Icon(
          Icons.receipt_long_outlined,
          color: AppColors.goldDeep,
        ),
        title: Text(
          l10n.recentPaymentsTitle,
          style: AppTypography.body(
            fontSize: 14,
            color: scheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          l10n.recentPaymentsSubtitle,
          style: AppTypography.body(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push('/zakat/recent'),
      ),
    );
  }
}
