import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../donation/presentation/widgets/donation_currency_sheet.dart';

class DonateSadaqahCard extends StatelessWidget {
  const DonateSadaqahCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: PrimaryHero.sadaqahGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.needQuickWayGive.toUpperCase(),
            style: AppTypography.label(
              fontSize: 10,
              color: AppColors.textOnPrimary.withValues(alpha: 0.7),
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.donateSadaqah,
            style: AppTypography.displayHeading(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.supportCommunityNeeds,
            style: AppTypography.body(
              fontSize: 12,
              color: AppColors.textOnPrimary.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 14),
          Material(
            color: AppColors.textOnPrimary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => showDonationCurrencySheet(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      TablerIcons.heart,
                      color: AppColors.textOnPrimary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.donateSadaqah,
                      style: AppTypography.body(
                        fontSize: 14,
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
