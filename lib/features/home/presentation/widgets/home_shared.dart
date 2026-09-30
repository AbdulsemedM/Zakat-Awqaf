import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

enum TagStyle { green, gold }

class GoldProgressBar extends StatelessWidget {
  const GoldProgressBar({super.key, required this.value, this.height = 6});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: dark
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : AppColors.progressTrack,
              ),
            ),
            FractionallySizedBox(
              widthFactor: v,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.warmGold, AppColors.goldLight],
                  ),
                ),
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: isGold ? AppColors.tagGoldText : AppColors.tagGreenText,
        ),
      ),
    );
  }
}
