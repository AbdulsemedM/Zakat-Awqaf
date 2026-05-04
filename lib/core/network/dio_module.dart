import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio() {
    final baseUrl = (FlutterConfig.get('API_BASE_URL') as String?) ?? '';
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }
}
