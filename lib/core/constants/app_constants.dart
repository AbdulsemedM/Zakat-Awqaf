class AppConstants {
  AppConstants._();

  static const String appTitle = 'Zakat & Awqaf Commission';
}

/// Features switched on in this build.
abstract final class AppFeatures {
  /// Awqaf mode: screens only, no backend yet. Off: its routes and the mode
  /// switch are left out of the build, and the app always runs in zakat
  /// mode.
  static const bool awqaf = false;
}
