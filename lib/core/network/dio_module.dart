import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../auth/auth_interceptor.dart';
import '../config/app_env.dart';
import 'dio_logging_interceptor.dart';
import 'pinned_certificates.dart';

/// Refuses a base URL that isn't `https` (the platforms' cleartext rules
/// don't cover Dart's HttpClient). Trusts only [PinnedCertificates] when
/// there are any. Otherwise, in debug builds only, accepts the self-signed
/// certificate of the configured API host; release builds then keep normal
/// certificate validation.
void _configureTls(Dio dio) {
  final scheme = Uri.tryParse(dio.options.baseUrl)?.scheme;
  if (scheme != 'https') {
    throw StateError(
      'API base URL must use https, got "${dio.options.baseUrl}". '
      'Check API_BASE_URL in .env.',
    );
  }
  if (PinnedCertificates.pem.isNotEmpty) {
    final context = SecurityContext(withTrustedRoots: false);
    for (final pem in PinnedCertificates.pem) {
      context.setTrustedCertificatesBytes(utf8.encode(pem));
    }
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient(context: context),
    );
    return;
  }
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
    _configureTls(dio);

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
    _configureTls(dio);

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
    _configureTls(dio);

    return dio;
  }
}
