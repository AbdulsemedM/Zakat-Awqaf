import 'package:flutter/material.dart';

/// Brand palette: use [primary] and [secondary] directly in UI.
/// Do not use [ColorScheme.onPrimary] for branded surfaces—use [textOnPrimary]
/// for main copy on primary fills and hero gradients, and [secondary] for accents.
abstract final class AppColors {
  AppColors._();

  /// Mejlis emerald.
  static const Color primary = Color(0xFF007150);

  /// Mejlis gold (premium accent; replaces the former orange #E28F35).
  static const Color secondary = Color(0xFFD4A23A);
  static const Color awqafPrimary = Color(0xFF00163A);
  static const Color awqafSecondary = Color(0xFF5BC0BE);

  /// Main text/icons on [primary] fills and hero gradients (plain white, not `onPrimary`).
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// High-contrast label for surfaces using [secondary].
  static const Color onSecondary = Color(0xFF1F1600);

  // Premium Islamic palette — emerald depths.
  static const Color emeraldNight = Color(0xFF04231B);
  static const Color forestGreen = Color(0xFF0A3A2C);
  static const Color forestMid = Color(0xFF0D5A43);
  static const Color forestLight = Color(0xFF007150);
  static const Color emeraldBright = Color(0xFF1E9A6E);

  // Gold spectrum.
  static const Color goldDeep = Color(0xFFA67A1E);
  static const Color warmGold = Color(0xFFD4A23A);
  static const Color goldLight = Color(0xFFF0D68A);
  static const Color goldHairline = Color(0xFFE6D3A3);

  // Surfaces and text.
  static const Color parchment = Color(0xFFFBF9F4);
  static const Color ivory = Color(0xFFFFFDF8);
  static const Color ink = Color(0xFF14201B);
  static const Color mutedText = Color(0xFF58675F);
  static const Color borderWarm = Color(0xFFEBE1C8);

  // Text on emerald.
  static const Color mintGreen = Color(0xFFCDE9DB);
  static const Color mintGreenMuted = Color(0xFF94C4AD);
  static const Color statusBarText = Color(0xFFC5E8D5);

  // Tags.
  static const Color tagGreenBg = Color(0xFFE6F3EC);
  static const Color tagGreenText = Color(0xFF0D5A43);
  static const Color tagGreenBorder = Color(0xFFB5DCC8);
  static const Color tagGoldBg = Color(0xFFFBF2DA);
  static const Color tagGoldText = Color(0xFF7A5810);
  static const Color tagGoldBorder = Color(0xFFE6C977);
  static const Color progressTrack = Color(0xFFEFE7D5);

  // Cause banners.
  static const Color waterGradientStart = Color(0xFF0B3C5D);
  static const Color waterGradientEnd = Color(0xFF1F7A9E);
  static const Color sadaqahGradientStart = Color(0xFFB8862A);
  static const Color healthGradientStart = Color(0xFF0E5A5A);
  static const Color healthGradientEnd = Color(0xFF2A9D8F);
  static const Color emergencyGradientStart = Color(0xFF7A2E1E);
  static const Color emergencyGradientEnd = Color(0xFFB4532A);

  /// Soft emerald-tinted shadow for elevated cards.
  static const Color shadow = Color(0x1A0A3A2C);
}
