import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/urgent_beneficiary_projects.dart';
import '../../../../core/l10n/l10n.dart';
import 'home_shared.dart';

class UrgentCausesSection extends StatelessWidget {
  const UrgentCausesSection({super.key, required this.causes});

  final List<UrgentNeedModel> causes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.urgentBeneficiaryNeeds,
                style: AppTypography.body(
                  fontSize: 15,
                  color: AppColors.forestGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            InkWell(
              onTap: () => context.go('/beneficiary-registration'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  l10n.viewAll,
                  style: AppTypography.body(
                    fontSize: 13,
                    color: AppColors.warmGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: causes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) =>
                UrgentCauseCard(model: causes[index]),
          ),
        ),
      ],
    );
  }
}

class UrgentCauseCard extends StatelessWidget {
  const UrgentCauseCard({super.key, required this.model});

  final UrgentNeedModel model;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: 200,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderWarm),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: model.bannerColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  model.icon,
                  color: AppColors.textOnPrimary,
                  size: 28,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TagPill(label: model.badge),
                    const SizedBox(height: 6),
                    Text(
                      model.title,
                      style: AppTypography.body(
                        fontSize: 12,
                        color: AppColors.forestGreen,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.description,
                      style: AppTypography.body(
                        fontSize: 10,
                        color: AppColors.mutedText,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    GoldProgressBar(value: model.progress),
                    const SizedBox(height: 8),
                    Material(
                      color: AppColors.forestGreen,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () => context.go('/calculator'),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Text(
                              l10n.payZakatCause,
                              style: AppTypography.body(
                                fontSize: 11,
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
