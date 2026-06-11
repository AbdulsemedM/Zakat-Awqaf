import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

enum TagStyle { green, gold }

class GoldProgressBar extends StatelessWidget {
  const GoldProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 3,
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          color: AppColors.warmGold,
          backgroundColor: AppColors.progressTrack,
          minHeight: 3,
        ),
      ),
    );
  }
}

class TagPill extends StatelessWidget {
  const TagPill({super.key, required this.label, this.style = TagStyle.green});

  final String label;
  final TagStyle style;

  @override
  Widget build(BuildContext context) {
    final isGold = style == TagStyle.gold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isGold ? AppColors.tagGoldBg : AppColors.tagGreenBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isGold ? AppColors.tagGoldBorder : AppColors.tagGreenBorder,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.label(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: isGold ? AppColors.tagGoldText : AppColors.forestMid,
        ),
      ),
    );
  }
}
