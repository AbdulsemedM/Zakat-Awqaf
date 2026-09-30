import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
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
        ZakatSectionHeader(
          title: l10n.urgentBeneficiaryNeeds,
          actionLabel: l10n.viewAll,
          onAction: () => context.go('/beneficiary-registration'),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 268,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: causes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
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
    final scheme = Theme.of(context).colorScheme;
    final percent = (model.progress.clamp(0.0, 1.0) * 100).round();
    return SizedBox(
      width: 236,
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 104,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: model.bannerColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    const IslamicPatternLayer(
                      opacity: 0.22,
                      cell: 30,
                      color: AppColors.goldLight,
                      fadeTo: Alignment.bottomLeft,
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: TagPill(
                        label: model.badge,
                        style: model.badge.toUpperCase() == 'URGENT'
                            ? TagStyle.gold
                            : TagStyle.green,
                      ),
                    ),
                    Positioned(
                      right: 14,
                      bottom: 12,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.16),
                          border: Border.all(
                            color: AppColors.goldLight.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Icon(model.icon, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.displayHeading(
                          fontSize: 16,
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        model.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(child: GoldProgressBar(value: model.progress)),
                          const SizedBox(width: 8),
                          Text(
                            '$percent%',
                            style: AppTypography.body(
                              fontSize: 12,
                              color: AppColors.goldDeep,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => context.go('/calculator'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            padding: EdgeInsets.zero,
                            textStyle: AppTypography.body(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: Text(l10n.payZakatCause),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
