import 'package:dio/dio.dart';

abstract class ZakatRemoteDataProvider {
  Future<Map<String, dynamic>> fetchSummary();
  Future<Map<String, dynamic>> fetchGoldPricesUsdByKarat();
  Future<Map<String, dynamic>> fetchUsdToEtbRate();
}

class ZakatRemoteDataProviderImpl implements ZakatRemoteDataProvider {
  ZakatRemoteDataProviderImpl({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> fetchSummary() async {
    return const {};
  }

  @override
  Future<Map<String, dynamic>> fetchGoldPricesUsdByKarat() async {
    return const {};
  }

  @override
  Future<Map<String, dynamic>> fetchUsdToEtbRate() async {
    final response = await _dio.get('https://fxapi.app/api/USD/ETB.json');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    throw StateError('Unexpected FX payload shape');
  }
}
