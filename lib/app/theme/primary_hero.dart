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
}
