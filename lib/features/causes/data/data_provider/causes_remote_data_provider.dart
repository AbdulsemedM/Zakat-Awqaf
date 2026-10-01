import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_envelope.dart';
import '../models/cause.dart';

abstract class CausesRemoteDataProvider {
  Future<CausesPage> fetchCauses({
    CauseStatus status,
    bool urgentOnly,
    bool acceptsZakatOnly,
    CauseCategory? category,
    int page,
    int limit,
    required String lang,
  });

  /// Throws [ApiException] with 404 for unpublished or unknown ids.
  Future<CauseDetail> fetchCause(String id, {required String lang});
}

@LazySingleton(as: CausesRemoteDataProvider)
class CausesRemoteDataProviderImpl implements CausesRemoteDataProvider {
  CausesRemoteDataProviderImpl(this._dio);

  final Dio _dio;

  static const _causesPath = 'api/zakat/v1/causes';

  @override
  Future<CausesPage> fetchCauses({
    CauseStatus status = CauseStatus.active,
    bool urgentOnly = false,
    bool acceptsZakatOnly = false,
    CauseCategory? category,
    int page = 1,
    int limit = 20,
    required String lang,
  }) => guardApi(() async {
    final response = await _dio.get<dynamic>(
      _causesPath,
      queryParameters: {
        'status': status.name,
        if (urgentOnly) 'urgent': true,
        if (acceptsZakatOnly) 'acceptsZakat': true,
        if (category != null) 'category': category.name,
        'page': page,
        'limit': limit,
        'lang': lang,
      },
    );
    return CausesPage.fromJson(unwrapApiObject(response));
  });

  @override
  Future<CauseDetail> fetchCause(String id, {required String lang}) =>
      guardApi(() async {
        final response = await _dio.get<dynamic>(
          '$_causesPath/${Uri.encodeComponent(id)}',
          queryParameters: {'lang': lang},
        );
        return CauseDetail.fromJson(unwrapApiObject(response));
      });
}
