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

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.path.contains(_loginPath)) {
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
    final path = err.requestOptions.path;
    if (status == 401 && !path.contains(_loginPath)) {
      await _tokenStorage.clear();
      _sessionController.markLoggedOut();
    }
    handler.next(err);
  }
}
