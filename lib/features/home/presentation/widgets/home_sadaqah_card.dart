import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../donation/presentation/widgets/donation_currency_sheet.dart';

class DonateSadaqahCard extends StatelessWidget {
  const DonateSadaqahCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: PrimaryHero.sadaqahGradient),
        child: Stack(
          children: [
            const IslamicPatternLayer(
              color: AppColors.emeraldNight,
              opacity: 0.10,
              cell: 34,
              fadeTo: Alignment.bottomRight,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.needQuickWayGive.toUpperCase(),
                    style: AppTypography.label(
                      fontSize: 10,
                      color: AppColors.emeraldNight.withValues(alpha: 0.7),
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.donateSadaqah,
                    style: AppTypography.displayHeading(
                      fontSize: 22,
                      color: AppColors.emeraldNight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.supportCommunityNeeds,
                    style: AppTypography.body(
                      fontSize: 13,
                      color: AppColors.emeraldNight.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => showDonationCurrencySheet(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.forestGreen,
                        foregroundColor: AppColors.goldLight,
                      ),
                      icon: const Icon(TablerIcons.heart, size: 18),
                      label: Text(l10n.donateSadaqah),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
