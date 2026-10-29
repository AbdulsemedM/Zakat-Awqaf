import 'package:flutter/foundation.dart';

/// API URLs, compiled in with `--dart-define-from-file=.env` (or
/// `--dart-define`). Android release builds fail without `API_BASE_URL`.
abstract final class AppEnv {
  AppEnv._();

  // `String.fromEnvironment` only works as a const with a literal key.
  static const _apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const _authApiBaseUrl = String.fromEnvironment('AUTH_API_BASE_URL');
  static const _paymentsApiBaseUrl = String.fromEnvironment(
    'PAYMENTS_API_BASE_URL',
  );

  static String get apiBaseUrl => _apiBaseUrl.trim();

  static String get authApiBaseUrl {
    final auth = _authApiBaseUrl.trim();
    return auth.isNotEmpty ? auth : apiBaseUrl;
  }

  static String get paymentsApiBaseUrl {
    final payments = _paymentsApiBaseUrl.trim();
    return payments.isNotEmpty ? payments : apiBaseUrl;
  }

  static Future<void> load() async {
    if (kDebugMode) debugPrint('AppEnv: API_BASE_URL → $apiBaseUrl');
  }
}
