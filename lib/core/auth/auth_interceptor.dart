import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'auth_session_controller.dart';
import 'auth_token_storage.dart';
import 'token_refresher.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, this._sessionController, this._refresher);

  final AuthTokenStorage _tokenStorage;
  final AuthSessionController _sessionController;
  final TokenRefresher _refresher;

  static const _loginPath = 'api/auth/v1/login';

  /// Public registration routes must not send Bearer tokens (stale JWT causes 401).
  static bool isPublicRegistrationRoute(RequestOptions options) {
    final path = options.path;
    final method = options.method.toUpperCase();

    if (method == 'POST') {
      if (_isExactBeneficiariesCollectionPath(path)) {
        return true;
      }
      if (path.contains('api/beneficiaries/v1/accounts/set-password')) {
        return true;
      }
      if (path.contains('api/beneficiaries/v1/registration-codes/validate')) {
        return true;
      }
      if (path.contains('api/beneficiaries/v1/companies')) {
        return path.contains('/documents') ||
            _isExactCompaniesCollectionPath(path);
      }
    }

    return false;
  }

  /// Public zakat content (calculator config, home summary, causes, Zakat
  /// al-Fitr) takes no token; `admin/` routes do.
  static bool isPublicZakatRoute(RequestOptions options) {
    final path = options.path;
    if (options.method.toUpperCase() != 'GET') return false;
    // Payment methods and certificate verification are public too.
    if (path.contains('api/payments/v1/methods') ||
        path.contains('api/payments/v1/certificates/verify/')) {
      return true;
    }
    return path.contains('api/zakat/v1/') &&
        !path.contains('api/zakat/v1/admin/');
  }

  static bool _isExactBeneficiariesCollectionPath(String path) {
    const marker = 'api/beneficiaries/v1/beneficiaries';
    final idx = path.indexOf(marker);
    if (idx == -1) {
      return false;
    }
    final suffix = path.substring(idx + marker.length);
    return suffix.isEmpty || suffix == '/';
  }

  static bool _isExactCompaniesCollectionPath(String path) {
    const marker = 'api/beneficiaries/v1/companies';
    final idx = path.indexOf(marker);
    if (idx == -1) {
      return false;
    }
    final suffix = path.substring(idx + marker.length);
    return suffix.isEmpty || suffix == '/';
  }

  bool _skipAuth(RequestOptions options) =>
      options.path.contains(_loginPath) ||
      isPublicRegistrationRoute(options) ||
      isPublicZakatRoute(options);

  /// Adds the access token, refreshing it first when it is about to expire.
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_skipAuth(options) &&
        options.headers['Authorization'] == null &&
        await _tokenStorage.readAccessToken() != null) {
      final token = await _refresher.validAccessToken();
      if (token == null) {
        // The session has ended on the server.
        _sessionController.markLoggedOut();
      } else {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  /// On a 401 for a signed-in request: refresh once and send it again. Signs
  /// the user out only when the server says the session is over; a 401 that
  /// survives a successful refresh (e.g. an unknown route) is passed on.
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final hadToken = options.headers['Authorization'] != null;
    final retried =
        options.extra[TokenRefresher.retriedAfterRefreshKey] == true;
    if (err.response?.statusCode != 401 ||
        _skipAuth(options) ||
        !hadToken ||
        retried) {
      handler.next(err);
      return;
    }
    switch (await _refresher.refresh()) {
      case RefreshResult.refreshed:
        final token = await _tokenStorage.readAccessToken();
        if (token == null) {
          handler.next(err);
          return;
        }
        try {
          handler.resolve(await _refresher.retry(options, token));
        } on DioException catch (retryError) {
          handler.next(retryError);
        }
      case RefreshResult.sessionExpired:
        _sessionController.markLoggedOut();
        handler.next(err);
      case RefreshResult.unavailable:
        handler.next(err);
    }
  }
}
