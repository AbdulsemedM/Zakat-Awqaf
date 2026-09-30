import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../auth/auth_interceptor.dart';
import '../config/app_env.dart';
import 'dio_logging_interceptor.dart';

/// Debug builds only: the UAT server uses a self-signed certificate, which
/// the platform rejects. Trust it for the configured API host and nothing
/// else. Release builds keep normal certificate validation.
void _trustSelfSignedApiHost(Dio dio) {
  if (!kDebugMode) return;
  final host = Uri.tryParse(dio.options.baseUrl)?.host;
  if (host == null || host.isEmpty) return;
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, certHost, port) =>
          certHost == host;
      return client;
    },
  );
}

@module
abstract class DioModule {
  String _apiBaseUrl() => AppEnv.apiBaseUrl;

  String _authBaseUrl() => AppEnv.authApiBaseUrl;

  String _paymentsBaseUrl() => AppEnv.paymentsApiBaseUrl;

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
    _trustSelfSignedApiHost(dio);

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
    _trustSelfSignedApiHost(dio);

    return dio;
  }

  @Named('paymentsDio')
  @lazySingleton
  Dio paymentsDio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: _paymentsBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(authInterceptor);
    if (kDebugMode) {
      dio.interceptors.add(DioLoggingInterceptor());
    }
    _trustSelfSignedApiHost(dio);

    return dio;
  }
}
