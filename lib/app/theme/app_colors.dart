import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  static const Color primary = Color.fromARGB(255, 1, 109, 12);
  static const Color secondary = Color(0xFFD97706);

  /// High-contrast label for surfaces using [secondary].
  static const Color onSecondary = Color(0xFF0A0A0A);
}
