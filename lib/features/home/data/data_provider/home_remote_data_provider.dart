import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_envelope.dart';
import '../models/home_summary.dart';
import '../models/zakat_al_fitr_season.dart';

abstract class HomeRemoteDataProvider {
  Future<HomeSummary> fetchSummary({required String lang});

  /// `null` when no season is set up (`{ "success": true }` without data).
  Future<ZakatAlFitrSeason?> fetchCurrentFitrSeason({required String lang});
}

@LazySingleton(as: HomeRemoteDataProvider)
class HomeRemoteDataProviderImpl implements HomeRemoteDataProvider {
  HomeRemoteDataProviderImpl(this._dio);

  final Dio _dio;

  static const _summaryPath = 'api/zakat/v1/home/summary';
  static const _fitrPath = 'api/zakat/v1/zakat-al-fitr/current';

  @override
  Future<HomeSummary> fetchSummary({required String lang}) =>
      guardApi(() async {
        final response = await _dio.get<dynamic>(
          _summaryPath,
          queryParameters: {'lang': lang},
        );
        return HomeSummary.fromJson(unwrapApiObject(response));
      });

  @override
  Future<ZakatAlFitrSeason?> fetchCurrentFitrSeason({required String lang}) =>
      guardApi(() async {
        final response = await _dio.get<dynamic>(
          _fitrPath,
          queryParameters: {'lang': lang},
        );
        final data = unwrapApiData(response);
        if (data is! Map) return null;
        return ZakatAlFitrSeason.fromJson(Map<String, dynamic>.from(data));
      });
}
