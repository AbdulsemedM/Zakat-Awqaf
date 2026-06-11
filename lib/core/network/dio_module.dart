import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../auth/auth_interceptor.dart';
import '../config/app_env.dart';
import 'dio_logging_interceptor.dart';

@module
abstract class DioModule {
  String _apiBaseUrl() => AppEnv.apiBaseUrl;

  String _authBaseUrl() => AppEnv.authApiBaseUrl;

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
