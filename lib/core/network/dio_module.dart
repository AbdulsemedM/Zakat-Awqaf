import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:injectable/injectable.dart';

import '../auth/auth_interceptor.dart';
import 'dio_logging_interceptor.dart';

@module
abstract class DioModule {
  String _apiBaseUrl() =>
      (FlutterConfig.get('API_BASE_URL') as String?)?.trim() ?? '';

  String _authBaseUrl() {
    final authUrl = (FlutterConfig.get('AUTH_API_BASE_URL') as String?)?.trim();
    if (authUrl != null && authUrl.isNotEmpty) {
      return authUrl;
    }
    return _apiBaseUrl();
  }

  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: _apiBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(authInterceptor);
    if (kDebugMode) {
      dio.interceptors.add(DioLoggingInterceptor());
    }

    return dio;
  }

  @Named('authDio')
  @lazySingleton
  Dio authDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _authBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(DioLoggingInterceptor());
    }

    return dio;
  }
}
