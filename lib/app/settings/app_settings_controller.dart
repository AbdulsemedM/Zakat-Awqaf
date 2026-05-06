import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/profile/data/models/profile_model.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController._(
    this._prefs, {
    required AppLanguage language,
    required ThemeMode themeMode,
  })  : _language = language,
        _themeMode = themeMode;

  static const _languageKey = 'app_language';
  static const _themeModeKey = 'app_theme_mode';

  final SharedPreferences _prefs;

  AppLanguage _language;
  ThemeMode _themeMode;

  AppLanguage get language => _language;
  ThemeMode get themeMode => _themeMode;

  Locale get locale => _toLocale(_language);

  static Future<AppSettingsController> create() async {
    final prefs = await SharedPreferences.getInstance();
    final languageName = prefs.getString(_languageKey);
    final themeName = prefs.getString(_themeModeKey);
    final language = AppLanguage.values.firstWhere(
      (value) => value.name == languageName,
      orElse: () => AppLanguage.english,
    );
    final themeMode = ThemeMode.values.firstWhere(
      (value) => value.name == themeName,
      orElse: () => ThemeMode.light,
    );
    return AppSettingsController._(
      prefs,
      language: language,
      themeMode: themeMode,
    );
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) return;
    _language = language;
    notifyListeners();
    await _prefs.setString(_languageKey, language.name);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs.setString(_themeModeKey, mode.name);
  }

  static Locale _toLocale(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.amharic:
        return const Locale('am');
      case AppLanguage.afaanOromoo:
        return const Locale('om');
      case AppLanguage.arabic:
        return const Locale('ar');
      case AppLanguage.afanSomali:
        return const Locale('so');
    }
  }
}
