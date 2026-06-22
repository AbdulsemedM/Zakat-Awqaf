import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../zakat_calculator/bloc/zakat_calculator_state.dart';
import '../../../zakat_payment/presentation/models/zakat_payment_args.dart';

enum DonationCurrencyChoice { local, international }

/// Opens the local vs international payment picker for Sadaqah donations.
Future<void> showDonationCurrencySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => const _DonationCurrencySheet(),
  );
}

class _DonationCurrencySheet extends StatelessWidget {
  const _DonationCurrencySheet();

  void _onLocalTap(BuildContext context) {
    final l10n = context.l10n;
    Navigator.of(context).pop();
    context.push(
      '/zakat/payment',
      extra: ZakatPaymentArgs(
        activeTab: ZakatCategoryTab.wealth,
        amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
        overviewTitle: l10n.donateSadaqah,
        overviewPrimaryValue: l10n.supportCommunityNeeds,
        overviewDueLabel: 'Amount',
        overviewDueValue: 'Enter an amount',
      ),
    );
  }

  void _onInternationalTap(BuildContext context) {
    Navigator.of(context).pop();
    context.push('/donation/international');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.donationCurrencySheetTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.donationCurrencySheetSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              _CurrencyOptionTile(
                title: l10n.donationLocalPaymentTitle,
                subtitle: l10n.donationLocalPaymentSubtitle,
                icon: TablerIcons.wallet,
                gradient: PrimaryHero.sadaqahGradient,
                onTap: () => _onLocalTap(context),
              ),
              const SizedBox(height: 12),
              _CurrencyOptionTile(
                title: l10n.donationInternationalPaymentTitle,
                subtitle: l10n.donationInternationalPaymentSubtitle,
                icon: TablerIcons.world,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.awqafPrimary,
                    Color(0xFF1A3A6B),
                    AppColors.warmGold,
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
                onTap: () => _onInternationalTap(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrencyOptionTile extends StatelessWidget {
  const _CurrencyOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.awqafPrimary.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.textOnPrimary, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.body(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTypography.body(
                          fontSize: 12,
                          color: AppColors.textOnPrimary.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
