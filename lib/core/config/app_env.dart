import 'package:flutter/foundation.dart';

/// API URLs. Defaults are compiled in, so a plain `flutter run` /
/// `flutter build apk` works with no extra flags.
///
/// To point at another server, change [_defaultApiBaseUrl] below.
/// (`--dart-define=API_BASE_URL=…` still overrides it if ever needed.)
abstract final class AppEnv {
  AppEnv._();

  /// The API server. Its certificate must chain to a [PinnedCertificates] root.
  static const _defaultApiBaseUrl = 'https://ezaac.com/';

  // Optional overrides. `String.fromEnvironment` needs a literal key.
  static const _apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const _authApiBaseUrl = String.fromEnvironment('AUTH_API_BASE_URL');
  static const _paymentsApiBaseUrl = String.fromEnvironment(
    'PAYMENTS_API_BASE_URL',
  );

  static String get apiBaseUrl {
    final api = _apiBaseUrl.trim();
    return api.isNotEmpty ? api : _defaultApiBaseUrl;
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
