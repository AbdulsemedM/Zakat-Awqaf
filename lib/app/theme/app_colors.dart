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

  // Zakat home design tokens
  static const Color forestGreen = Color(0xFF1A3D2B);
  static const Color forestMid = Color(0xFF2A6045);
  static const Color forestLight = Color(0xFF3D8B6A);
  static const Color warmGold = Color(0xFFC4A040);
  static const Color parchment = Color(0xFFF7F3EC);
  static const Color mutedText = Color(0xFF5A6E62);
  static const Color borderWarm = Color(0xFFE4DDD0);
  static const Color mintGreen = Color(0xFFA8D8BE);
  static const Color mintGreenMuted = Color(0xFF8EC9A8);
  static const Color statusBarText = Color(0xFFC5E8D5);
  static const Color tagGreenBg = Color(0xFFE8F4EE);
  static const Color tagGreenText = Color(0xFF1A5C38);
  static const Color tagGreenBorder = Color(0xFFA8D8BE);
  static const Color tagGoldBg = Color(0xFFFAF3E0);
  static const Color tagGoldText = Color(0xFF7A5F0A);
  static const Color tagGoldBorder = Color(0xFFE8C96E);
  static const Color progressTrack = Color(0xFFE8DDD0);
  static const Color waterGradientStart = Color(0xFF1A5078);
  static const Color waterGradientEnd = Color(0xFF2980B9);
  static const Color sadaqahGradientStart = Color(0xFF7A5F0A);
}
