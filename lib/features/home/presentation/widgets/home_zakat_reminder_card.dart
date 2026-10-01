import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/models/zakat_al_fitr_season.dart';

/// Zakat al-Fitr season card; the caller hides it when there is no season.
class ZakatReminderCard extends StatelessWidget {
  const ZakatReminderCard({super.key, required this.season});

  final ZakatAlFitrSeason season;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final days = season.daysRemaining(DateTime.now());
    final statusLabel = switch (season.status) {
      FitrSeasonStatus.upcoming => l10n.homeUpcoming,
      FitrSeasonStatus.open => l10n.fitrStatusOpen,
      FitrSeasonStatus.closed => l10n.fitrStatusClosed,
    };
    final timing = switch (season.status) {
      FitrSeasonStatus.upcoming => l10n.fitrStartsIn(days),
      FitrSeasonStatus.open => l10n.fitrDaysLeft(days),
      FitrSeasonStatus.closed => l10n.fitrClosedOn(
        DateFormat.yMMMd(context.contentLocale.toString()).format(season.dueBy),
      ),
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: PrimaryHero.zakatHeroGradient,
        ),
        child: Stack(
          children: [
            const IslamicPatternLayer(
              opacity: 0.14,
              cell: 34,
              fadeTo: Alignment.centerLeft,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warmGold.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.goldLight.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            statusLabel,
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
                          timing,
                          style: AppTypography.body(
                            fontSize: 13,
                            color: AppColors.mintGreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.fitrPerPerson(
                            MoneyFormatter.etb(season.perPersonAmountEtb),
                          ),
                          style: AppTypography.body(
                            fontSize: 13,
                            color: AppColors.goldLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (season.status != FitrSeasonStatus.closed) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 42),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              textStyle: AppTypography.body(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            icon: const Icon(TablerIcons.bell, size: 18),
                            label: Text(l10n.setReminder),
                          ),
                        ],
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
