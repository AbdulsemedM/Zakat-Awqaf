import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;

import '../beneficiary_registration_exception.dart';
import '../mobile_error_message.dart';
import '../models/beneficiary_create_request.dart';
import '../models/beneficiary_dto.dart';
import '../models/beneficiary_registration_result.dart';
import '../models/company_beneficiary_create_request.dart';
import 'beneficiary_registration_data_provider.dart';

@LazySingleton(as: BeneficiaryRegistrationDataProvider)
class BeneficiaryRegistrationDataProviderImpl
    implements BeneficiaryRegistrationDataProvider {
  BeneficiaryRegistrationDataProviderImpl(this._dio);

  final Dio _dio;

  static const _beneficiariesPath = 'api/beneficiaries/v1/beneficiaries';
  static const _companiesPath = 'api/beneficiaries/v1/companies';

  @override
  Future<BeneficiaryRegistrationResult> createBeneficiary(
    BeneficiaryRegistrationRequest request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _beneficiariesPath,
        data: request.toJson(),
      );
      final status = response.statusCode ?? 0;
      if (status < 200 || status > 202) {
        throw BeneficiaryRegistrationException(
          'Unexpected status: $status',
        );
      }
      return _parseEnvelope(response.data, status);
    } on BeneficiaryRegistrationException {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<BeneficiaryRegistrationResult> createCompany(
    CompanyBeneficiaryCreateRequest request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _companiesPath,
        data: request.toJson(),
      );
      final status = response.statusCode ?? 0;
      if (status != 201) {
        throw BeneficiaryRegistrationException(
          'Unexpected status: $status',
        );
      }
      return _parseEnvelope(response.data, status);
    } on BeneficiaryRegistrationException {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<BeneficiaryRegistrationResult> uploadCompanyDocument({
    required String companyId,
    required String uploadToken,
    required String documentCode,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'documentCode': documentCode.trim(),
        'file': await MultipartFile.fromFile(
          filePath,
          filename: p.basename(filePath),
        ),
      });
      final response = await _dio.post<Map<String, dynamic>>(
        '$_companiesPath/$companyId/documents',
        data: formData,
        options: Options(
          headers: {'X-Company-Upload-Token': uploadToken.trim()},
          contentType: 'multipart/form-data',
        ),
      );
      final status = response.statusCode ?? 0;
      if (status != 200) {
        throw BeneficiaryRegistrationException(
          'Unexpected status: $status',
        );
      }
      return _parseEnvelope(response.data, status);
    } on BeneficiaryRegistrationException {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  BeneficiaryRegistrationResult _parseEnvelope(
    Map<String, dynamic>? body,
    int status,
  ) {
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
  }

  BeneficiaryRegistrationException _mapDioException(DioException e) {
    final parsed = parseMobileErrorMessage(e.response?.data);
    if (parsed != null && parsed.isNotEmpty) {
      return BeneficiaryRegistrationException(parsed);
    }
    return BeneficiaryRegistrationException(
      e.message ?? 'Network error',
    );
  }
}
