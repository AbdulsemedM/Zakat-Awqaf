import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'auth_session_controller.dart';
import 'auth_token_storage.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, this._sessionController);

  final AuthTokenStorage _tokenStorage;
  final AuthSessionController _sessionController;

  static const _loginPath = 'api/auth/v1/login';

  /// Public registration routes must not send Bearer tokens (stale JWT causes 401).
  static bool isPublicRegistrationRoute(RequestOptions options) {
    final path = options.path;
    final method = options.method.toUpperCase();

    if (method == 'GET' && path.contains('api/beneficiaries/v1/sse/beneficiary/')) {
      return true;
    }

    if (method == 'POST') {
      if (_isExactBeneficiariesCollectionPath(path)) {
        return true;
      }
      if (path.contains('api/beneficiaries/v1/accounts/set-password')) {
        return true;
      }
      if (path.contains('api/beneficiaries/v1/companies')) {
        return path.contains('/documents') || _isExactCompaniesCollectionPath(path);
      }
    }

    return false;
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

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skipAuth = options.path.contains(_loginPath) ||
        isPublicRegistrationRoute(options);
    if (!skipAuth) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null && token.trim().isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final options = err.requestOptions;
    final shouldClearSession = status == 401 &&
        !options.path.contains(_loginPath) &&
        !isPublicRegistrationRoute(options);
    if (shouldClearSession) {
      await _tokenStorage.clear();
      _sessionController.markLoggedOut();
    }
    handler.next(err);
  }
}
