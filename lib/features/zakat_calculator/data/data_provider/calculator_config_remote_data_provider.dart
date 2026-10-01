import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_envelope.dart';

abstract class CalculatorConfigRemoteDataProvider {
  /// The config response `data`. Throws [ApiException] (503 before the
  /// server's first price fetch).
  Future<Map<String, dynamic>> fetchConfig();
}

@LazySingleton(as: CalculatorConfigRemoteDataProvider)
class CalculatorConfigRemoteDataProviderImpl
    implements CalculatorConfigRemoteDataProvider {
  CalculatorConfigRemoteDataProviderImpl(this._dio);

  final Dio _dio;

  static const _configPath = 'api/zakat/v1/calculator/config';

  @override
  Future<Map<String, dynamic>> fetchConfig() => guardApi(() async {
    // Always English: the app reads the livestock `due` texts to work out
    // the animals and localizes them itself.
    final response = await _dio.get<dynamic>(
      _configPath,
      queryParameters: const {'lang': 'en'},
    );
    return unwrapApiObject(response);
  });
}
