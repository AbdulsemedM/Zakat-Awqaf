import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../donation/presentation/widgets/donation_currency_sheet.dart';

/// Four primary shortcuts in a card that overlaps the bottom of the hero.
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = [
      (TablerIcons.calculator, l10n.homeQuickCalculate, () => context.go('/calculator')),
      (TablerIcons.heart, l10n.homeQuickSadaqah, () => showDonationCurrencySheet(context)),
      (TablerIcons.user_plus, l10n.homeQuickApply, () => context.go('/beneficiary-registration')),
      (TablerIcons.chart_pie, l10n.navImpact, () => context.go('/impact')),
    ];
    return PremiumCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      child: Row(
        children: [
          for (final (icon, label, onTap) in actions)
            Expanded(
              child: _QuickAction(icon: icon, label: label, onTap: onTap),
            ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.forestLight, AppColors.forestGreen],
                ),
                border: Border.all(
                  color: AppColors.goldLight.withValues(alpha: 0.7),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forestGreen.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.goldLight, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.body(
                fontSize: 12,
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
