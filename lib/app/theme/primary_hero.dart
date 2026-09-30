import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared hero surfaces for the premium emerald-and-gold look.
abstract final class PrimaryHero {
  PrimaryHero._();

  static const double _darkEndLerp = 0.45;

  static Color darkEnd() =>
      Color.lerp(AppColors.primary, AppColors.emeraldNight, _darkEndLerp) ??
      AppColors.primary;

  /// [scheme] is unused; kept for call-site compatibility with existing widgets.
  static LinearGradient gradient(ColorScheme _) => const LinearGradient(
        colors: [AppColors.forestLight, AppColors.forestMid, AppColors.forestGreen],
        stops: [0.0, 0.55, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Zakat home hero: deep emerald night into brand emerald.
  static const LinearGradient zakatHeroGradient = LinearGradient(
    begin: Alignment(-0.9, -1),
    end: Alignment(1, 1),
    colors: [
      AppColors.emeraldNight,
      AppColors.forestGreen,
      AppColors.forestMid,
      AppColors.forestLight,
    ],
    stops: [0.0, 0.35, 0.72, 1.0],
  );

  /// Burnished gold for Sadaqah and premium CTAs.
  static const LinearGradient sadaqahGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.goldLight,
      AppColors.warmGold,
      AppColors.goldDeep,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gold sheen used on primary call-to-action buttons.
  static const LinearGradient goldButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.goldLight, AppColors.warmGold],
  );
}
