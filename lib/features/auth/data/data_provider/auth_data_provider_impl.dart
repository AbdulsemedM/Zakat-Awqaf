import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../beneficiary_registration/data/mobile_error_message.dart';
import '../auth_exception.dart';
import '../models/login_request.dart';
import '../models/login_response_dto.dart';
import '../models/set_password_request.dart';
import 'auth_data_provider.dart';

@LazySingleton(as: AuthDataProvider)
class AuthDataProviderImpl implements AuthDataProvider {
  AuthDataProviderImpl(@Named('authDio') this._dio);

  final Dio _dio;

  static const _loginPath = 'api/auth/v1/login';
  static const _setPasswordPath = 'api/beneficiaries/v1/accounts/set-password';

  @override
  Future<LoginResponseDto> login(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _loginPath,
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

  @override
  Future<void> setBeneficiaryPassword(SetPasswordRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _setPasswordPath,
        data: request.toJson(),
        options: Options(
          headers: {'X-Password-Setup-Token': request.passwordSetupToken},
        ),
      );
      final status = response.statusCode ?? 0;
      if (status != 200) {
        throw AuthException('Unexpected status: $status');
      }
      final body = response.data;
      if (body == null) {
        throw const AuthException('Empty response body');
      }
      if (body['success'] != true) {
        throw AuthException(
          parseMobileErrorMessage(body) ?? 'Password setup was not successful',
        );
      }
    } on AuthException {
      rethrow;
    } on DioException catch (e) {
      final parsed = parseMobileErrorMessage(e.response?.data);
      if (parsed != null && parsed.isNotEmpty) {
        throw AuthException(parsed);
      }
      if (e.response?.statusCode == 400) {
        throw const AuthException(
          'Your password setup link has expired. Please restart registration or contact support.',
        );
      }
      if (e.response?.statusCode == 401) {
        throw const AuthException(
          'Password setup was rejected. Please restart registration or contact support.',
        );
      }
      throw AuthException(e.message ?? 'Network error');
    }
  }
}
