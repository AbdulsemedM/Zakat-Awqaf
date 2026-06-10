import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../beneficiary_registration_exception.dart';
import '../mobile_error_message.dart';
import '../models/beneficiary_create_request.dart';
import '../models/beneficiary_dto.dart';
import '../models/beneficiary_registration_result.dart';
import 'beneficiary_registration_data_provider.dart';

@LazySingleton(as: BeneficiaryRegistrationDataProvider)
class BeneficiaryRegistrationDataProviderImpl
    implements BeneficiaryRegistrationDataProvider {
  BeneficiaryRegistrationDataProviderImpl(this._dio);

  final Dio _dio;

  static const _path = 'api/beneficiaries/v1/beneficiaries';

  @override
  Future<BeneficiaryRegistrationResult> createBeneficiary(
    BeneficiaryRegistrationRequest request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _path,
        data: request.toJson(),
      );
      final status = response.statusCode ?? 0;
      if (status < 200 || status > 202) {
        throw BeneficiaryRegistrationException(
          'Unexpected status: $status',
        );
      }
      final body = response.data;
      if (body == null) {
        throw BeneficiaryRegistrationException('Empty response body');
      }
      if (body['success'] != true) {
        throw BeneficiaryRegistrationException(
          parseMobileErrorMessage(body) ?? 'Request was not successful',
        );
      }
      final data = body['data'];
      if (data is! Map) {
        throw BeneficiaryRegistrationException('Missing data in response');
      }
      final dto = BeneficiaryDto.fromJson(Map<String, dynamic>.from(data));
      return BeneficiaryRegistrationResult(dto: dto, statusCode: status);
    } on BeneficiaryRegistrationException {
      rethrow;
    } on DioException catch (e) {
      final parsed = parseMobileErrorMessage(e.response?.data);
      if (parsed != null && parsed.isNotEmpty) {
        throw BeneficiaryRegistrationException(parsed);
      }
      throw BeneficiaryRegistrationException(
        e.message ?? 'Network error',
      );
    }
  }
}
