import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CalculatorConfigLocalDataProvider {
  Future<Map<String, dynamic>?> readConfig();

  Future<void> saveConfig(Map<String, dynamic> json);
}

/// Keeps the last config the server returned, for use while offline.
@LazySingleton(as: CalculatorConfigLocalDataProvider)
class CalculatorConfigLocalDataProviderImpl
    implements CalculatorConfigLocalDataProvider {
  static const _key = 'zakat_calculator_config_v1';

  @override
  Future<Map<String, dynamic>?> readConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> saveConfig(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(json));
  }
}
