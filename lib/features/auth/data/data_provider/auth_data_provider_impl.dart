import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../beneficiary_registration/data/mobile_error_message.dart';
import '../auth_exception.dart';
import '../models/login_request.dart';
import '../models/login_response_dto.dart';
import 'auth_data_provider.dart';

@LazySingleton(as: AuthDataProvider)
class AuthDataProviderImpl implements AuthDataProvider {
  AuthDataProviderImpl(@Named('authDio') this._dio);

  final Dio _dio;

  static const _path = 'api/auth/v1/login';

  @override
  Future<LoginResponseDto> login(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _path,
        data: request.toJson(),
      );
      final status = response.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        throw AuthException('Unexpected status: $status');
      }
      final body = response.data;
      if (body == null) {
        throw const AuthException('Empty response body');
      }
      if (body['success'] != true) {
        throw AuthException(
          parseMobileErrorMessage(body) ?? 'Login was not successful',
        );
      }
      final data = body['data'];
      if (data is! Map) {
        throw const AuthException('Missing data in response');
      }
      final dto = LoginResponseDto.fromJson(Map<String, dynamic>.from(data));
      if (dto.accessToken.trim().isEmpty) {
        throw const AuthException('Missing access token in response');
      }
      return dto;
    } on AuthException {
      rethrow;
    } on DioException catch (e) {
      final parsed = parseMobileErrorMessage(e.response?.data);
      if (parsed != null && parsed.isNotEmpty) {
        throw AuthException(parsed);
      }
      throw AuthException(e.message ?? 'Network error');
    }
  }
}
