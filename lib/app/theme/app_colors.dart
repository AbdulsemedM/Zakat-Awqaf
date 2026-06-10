import 'package:flutter/material.dart';

/// Brand palette: use [primary] and [secondary] directly in UI.
/// Do not use [ColorScheme.onPrimary] for branded surfaces—use [textOnPrimary]
/// for main copy on primary fills and hero gradients, and [secondary] for accents.
abstract final class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF007150);
  static const Color secondary = Color(0xFFE28F35);
  static const Color awqafPrimary = Color(0xFF00163A);
  static const Color awqafSecondary = Color(0xFF5BC0BE);

  /// Main text/icons on [primary] fills and hero gradients (plain white, not `onPrimary`).
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// High-contrast label for surfaces using [secondary].
  static const Color onSecondary = Color(0xFF0A0A0A);
}
