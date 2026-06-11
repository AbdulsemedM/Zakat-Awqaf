import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared primary hero surfaces using [AppColors.primary] only (not `ColorScheme` hues).
abstract final class PrimaryHero {
  PrimaryHero._();

  static const double _darkEndLerp = 0.3;

  static Color darkEnd() =>
      Color.lerp(AppColors.primary, Colors.black, _darkEndLerp) ?? AppColors.primary;

  /// [scheme] is unused; kept for call-site compatibility with existing widgets.
  static LinearGradient gradient(ColorScheme _) => LinearGradient(
        colors: [AppColors.primary, darkEnd()],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Zakat home hero gradient (160deg forest green sweep).
  static const LinearGradient zakatHeroGradient = LinearGradient(
    begin: Alignment(-0.5, -1),
    end: Alignment(1, 1),
    colors: [
      AppColors.forestGreen,
      AppColors.forestMid,
      AppColors.forestLight,
    ],
    stops: [0.0, 0.6, 1.0],
  );

  static const LinearGradient sadaqahGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.sadaqahGradientStart,
      AppColors.warmGold,
    ],
  );
}
