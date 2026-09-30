import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';

class ZakatReminderCard extends StatelessWidget {
  const ZakatReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: PrimaryHero.zakatHeroGradient),
        child: Stack(
          children: [
            const IslamicPatternLayer(opacity: 0.14, cell: 34, fadeTo: Alignment.centerLeft),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.warmGold.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.goldLight.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            l10n.homeUpcoming,
                            style: AppTypography.label(
                              fontSize: 10,
                              color: AppColors.goldLight,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.zakatAlFitr,
                          style: AppTypography.displayHeading(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.zakatDueDays,
                          style: AppTypography.body(fontSize: 13, color: AppColors.mintGreen),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 42),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            textStyle: AppTypography.body(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          icon: const Icon(TablerIcons.bell, size: 18),
                          label: Text(l10n.setReminder),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.warmGold.withValues(alpha: 0.30),
                          AppColors.warmGold.withValues(alpha: 0.0),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.goldLight.withValues(alpha: 0.55),
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      TablerIcons.moon_stars,
                      color: AppColors.goldLight,
                      size: 36,
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
