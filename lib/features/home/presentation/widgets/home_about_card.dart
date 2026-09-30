import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';
import 'home_shared.dart';

class AboutCommissionSection extends StatelessWidget {
  const AboutCommissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.tagGreenBg,
                  border: Border.all(color: AppColors.goldHairline, width: 1.4),
                ),
                child: const Icon(
                  TablerIcons.building_mosque,
                  color: AppColors.forestMid,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aboutCommission,
                      style: AppTypography.displayHeading(
                        fontSize: 18,
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const GoldOrnamentDivider(width: 40),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.aboutCommissionBody,
            style: AppTypography.body(
              fontSize: 13,
              color: scheme.onSurfaceVariant,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TagPill(label: l10n.chipTransparencyFirst),
              TagPill(label: l10n.chipNationwideImpact),
              TagPill(label: l10n.chipShariahAligned, style: TagStyle.gold),
            ],
          ),
        ],
      ),
    );
  }
}
