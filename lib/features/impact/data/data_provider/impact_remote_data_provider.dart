import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_envelope.dart';
import '../models/impact_model.dart';

abstract class ImpactRemoteDataProvider {
  /// National figures, or [regionCode]'s.
  Future<ImpactSummary> fetchSummary({
    String? regionCode,
    required String lang,
  });

  Future<List<ImpactRegion>> fetchRegions({required String lang});

  Future<List<ImpactStory>> fetchStories({
    int page,
    int limit,
    required String lang,
  });

  /// Throws [ApiException] with 404 for an unknown or unpublished story.
  Future<ImpactStory> fetchStory(String id, {required String lang});
}

@LazySingleton(as: ImpactRemoteDataProvider)
class ImpactRemoteDataProviderImpl implements ImpactRemoteDataProvider {
  ImpactRemoteDataProviderImpl(this._dio);

  final Dio _dio;

  static const _basePath = 'api/zakat/v1/impact';

  @override
  Future<ImpactSummary> fetchSummary({
    String? regionCode,
    required String lang,
  }) => guardApi(() async {
    final response = await _dio.get<dynamic>(
      '$_basePath/summary',
      queryParameters: {'region': ?regionCode, 'lang': lang},
    );
    return ImpactSummary.fromJson(unwrapApiObject(response));
  });

  @override
  Future<List<ImpactRegion>> fetchRegions({required String lang}) =>
      guardApi(() async {
        final response = await _dio.get<dynamic>(
          '$_basePath/regions',
          queryParameters: {'lang': lang},
        );
        return [
          for (final row in _rows(unwrapApiData(response)))
            ?ImpactRegion.tryParse(row),
        ];
      });

  @override
  Future<List<ImpactStory>> fetchStories({
    int page = 1,
    int limit = 10,
    required String lang,
  }) => guardApi(() async {
    final response = await _dio.get<dynamic>(
      '$_basePath/stories',
      queryParameters: {'page': page, 'limit': limit, 'lang': lang},
    );
    return [
      for (final row in _rows(unwrapApiData(response)))
        ImpactStory.fromJson(row),
    ];
  });

  @override
  Future<ImpactStory> fetchStory(String id, {required String lang}) =>
      guardApi(() async {
        final response = await _dio.get<dynamic>(
          '$_basePath/stories/${Uri.encodeComponent(id)}',
          queryParameters: {'lang': lang},
        );
        return ImpactStory.fromJson(unwrapApiObject(response));
      });

  /// Rows of a plain list or of a paginated `{ items: [...] }` payload.
  static Iterable<Map<String, dynamic>> _rows(Object? data) {
    final list = data is Map ? data['items'] : data;
    if (list is! List) return const [];
    return [
      for (final row in list)
        if (row is Map) Map<String, dynamic>.from(row),
    ];
  }
}
