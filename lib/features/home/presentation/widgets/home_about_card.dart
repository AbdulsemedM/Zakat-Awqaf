import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/l10n/l10n.dart';
import 'home_shared.dart';

class AboutCommissionSection extends StatelessWidget {
  const AboutCommissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.tagGreenBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  TablerIcons.building_community,
                  color: AppColors.forestMid,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.aboutCommission,
                  style: AppTypography.body(
                    fontSize: 14,
                    color: AppColors.forestGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.aboutCommissionBody,
            style: AppTypography.body(
              fontSize: 12,
              color: AppColors.mutedText,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              TagPill(label: l10n.chipTransparencyFirst),
              TagPill(label: l10n.chipNationwideImpact),
              TagPill(
                label: l10n.chipShariahAligned,
                style: TagStyle.gold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
