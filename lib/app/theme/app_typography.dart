import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography helpers for the Zakat home design system.
abstract final class AppTypography {
  AppTypography._();

  static const String inter = 'Inter';
  static const String playfair = 'Playfair Display';

  static TextStyle displayHeading({
    required double fontSize,
    Color color = AppColors.textOnPrimary,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: playfair,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle body({
    required double fontSize,
    Color color = AppColors.mutedText,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: inter,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle label({
    required double fontSize,
    Color color = AppColors.mintGreen,
    FontWeight fontWeight = FontWeight.w600,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: inter,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle sectionTitle({Color color = AppColors.forestGreen}) =>
      body(fontSize: 15, color: color, fontWeight: FontWeight.w700);

  static TextStyle cardTitle({Color color = AppColors.textOnPrimary}) =>
      displayHeading(fontSize: 17, color: color, fontWeight: FontWeight.w600);

  static TextStyle cardBody({Color color = AppColors.mutedText}) =>
      body(fontSize: 12, color: color, height: 1.6);

  /// Material [TextTheme] with Playfair display roles and Inter UI roles.
  static TextTheme buildTextTheme({
    required TextTheme base,
    required ColorScheme scheme,
  }) {
    TextStyle withPlayfair(TextStyle? style) =>
        (style ?? const TextStyle()).copyWith(
          fontFamily: AppTypography.playfair,
          color: style?.color ?? scheme.onSurface,
        );

    TextStyle withInter(TextStyle? style) => (style ?? const TextStyle()).copyWith(
          fontFamily: AppTypography.inter,
          color: style?.color ?? scheme.onSurface,
        );

    return TextTheme(
      displayLarge: withPlayfair(base.displayLarge),
      displayMedium: withPlayfair(base.displayMedium),
      displaySmall: withPlayfair(base.displaySmall),
      headlineLarge: withPlayfair(base.headlineLarge),
      headlineMedium: withPlayfair(base.headlineMedium),
      headlineSmall: withPlayfair(base.headlineSmall),
      titleLarge: withPlayfair(base.titleLarge),
      titleMedium: withInter(base.titleMedium),
      titleSmall: withInter(base.titleSmall),
      bodyLarge: withInter(base.bodyLarge),
      bodyMedium: withInter(base.bodyMedium),
      bodySmall: withInter(base.bodySmall),
      labelLarge: withInter(base.labelLarge),
      labelMedium: withInter(base.labelMedium),
      labelSmall: withInter(base.labelSmall),
    );
  }
}
