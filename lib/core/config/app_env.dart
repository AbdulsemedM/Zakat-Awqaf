import 'package:flutter/foundation.dart';

/// API URLs, compiled in with `--dart-define-from-file=.env` (or
/// `--dart-define`). Android release builds fail without `API_BASE_URL`.
///
/// Debug builds without the define (a plain `flutter run`) fall back to the
/// UAT server, so the defines are optional during development.
abstract final class AppEnv {
  AppEnv._();

  /// UAT server; the host [PinnedCertificates] trusts. Debug builds only.
  static const _debugApiBaseUrl = 'https://196.188.249.232/';

  // `String.fromEnvironment` only works as a const with a literal key.
  static const _apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const _authApiBaseUrl = String.fromEnvironment('AUTH_API_BASE_URL');
  static const _paymentsApiBaseUrl = String.fromEnvironment(
    'PAYMENTS_API_BASE_URL',
  );

  static String get apiBaseUrl {
    final api = _apiBaseUrl.trim();
    if (api.isEmpty && kDebugMode) return _debugApiBaseUrl;
    return api;
  }

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
