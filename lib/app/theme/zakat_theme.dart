import 'package:flutter/material.dart';

import 'app_typography.dart';

/// Zakat-mode theme overlay: Inter for UI/body, Playfair for display titles.
abstract final class ZakatTheme {
  ZakatTheme._();

  static ThemeData of(BuildContext context) {
    final base = Theme.of(context);
    final textTheme = AppTypography.buildTextTheme(
      base: base.textTheme,
      scheme: base.colorScheme,
    );
    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: textTheme.titleLarge,
      ),
      dialogTheme: base.dialogTheme.copyWith(
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      snackBarTheme: base.snackBarTheme.copyWith(
        contentTextStyle: textTheme.bodyMedium,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: base.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
