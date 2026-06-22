import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';

/// Resolves API URLs for Dio.
///
/// Priority: bundled `.env` asset (debug) → [FlutterConfig] (native) →
/// optional `--dart-define` overrides.
abstract final class AppEnv {
  AppEnv._();

  static Map<String, String> _bundled = const {};

  static String get apiBaseUrl => _resolve('API_BASE_URL');

  static String get authApiBaseUrl {
    final auth = _resolve('AUTH_API_BASE_URL');
    return auth.isNotEmpty ? auth : apiBaseUrl;
  }

  static String get paymentsApiBaseUrl {
    final payments = _resolve('PAYMENTS_API_BASE_URL');
    return payments.isNotEmpty ? payments : apiBaseUrl;
  }

  /// Load `.env` from the app asset bundle (debug) and native [FlutterConfig].
  static Future<void> load() async {
    if (kDebugMode) {
      try {
        final content = await rootBundle.loadString('.env');
        _bundled = _parseDotEnv(content);
      } catch (e) {
        debugPrint('AppEnv: bundled .env not found, using FlutterConfig ($e)');
      }
    }
    await FlutterConfig.loadEnvVariables();
    logSource();
  }

  static String _resolve(String key) {
    final fromDefine = String.fromEnvironment(key).trim();
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }
    final fromBundled = _bundled[key]?.trim() ?? '';
    if (fromBundled.isNotEmpty) {
      return fromBundled;
    }
    return (FlutterConfig.get(key) as String?)?.trim() ?? '';
  }

  static void logSource() {
    if (!kDebugMode) return;
    final source = _bundled.isNotEmpty
        ? 'bundled .env asset'
        : String.fromEnvironment('API_BASE_URL').trim().isNotEmpty
            ? 'dart-define'
            : 'FlutterConfig (native)';
    debugPrint('AppEnv: API_BASE_URL from $source → $apiBaseUrl');
  }

  static Map<String, String> _parseDotEnv(String content) {
    final env = <String, String>{};
    for (final line in content.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final eq = trimmed.indexOf('=');
      if (eq <= 0) continue;
      final key = trimmed.substring(0, eq).trim();
      var value = trimmed.substring(eq + 1).trim();
      if ((value.startsWith('"') && value.endsWith('"')) ||
          (value.startsWith("'") && value.endsWith("'"))) {
        value = value.substring(1, value.length - 1);
      }
      env[key] = value;
    }
    return env;
  }
}
