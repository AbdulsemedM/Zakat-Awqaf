import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/auth/auth_token_storage.dart';
import '../../../beneficiary_registration/data/mobile_error_message.dart';
import '../../../beneficiary_registration/data/models/beneficiary_dto.dart';
import '../models/application_status_dto.dart';
import '../models/bank_account_update_request.dart';
import '../models/profile_model.dart';
import '../profile_exception.dart';
import '../profile_mapper.dart';
import 'profile_data_provider.dart';

@LazySingleton(as: ProfileDataProvider)
class RemoteProfileDataProvider implements ProfileDataProvider {
  RemoteProfileDataProvider(this._dio, this._tokenStorage);

  final Dio _dio;
  final AuthTokenStorage _tokenStorage;

  static const _mePath = 'api/beneficiaries/v1/me';
  static const _bankAccountPath = 'api/beneficiaries/v1/me/bank-account';
  static const _applicationPath = 'api/beneficiaries/v1/me/application';
  static const _authMePath = 'api/auth/v1/me';

  ProfileModel _localCache = ProfileMapper.defaultLocalOverlay();

  @override
  Future<ProfileModel> fetchProfile() async {
    final user = await _tokenStorage.readUser();
    // Donors have no beneficiary record: their profile is the auth account.
    if (user != null && user.isDonor) {
      _localCache = ProfileMapper.fromSessionUser(
        user,
        localOverlay: _localCache,
      );
      final me = await _fetchAuthMe();
      if (me != null) {
        _localCache = ProfileMapper.withAuthMe(_localCache, me);
      }
      return _localCache;
    }
    try {
      final response = await _dio.get<Map<String, dynamic>>(_mePath);
      final dto = _parseEnvelope(response.data, response.statusCode ?? 0);
      _localCache = ProfileMapper.fromBeneficiary(
        dto,
        localOverlay: _localCache,
      );
      final application = await _fetchApplication();
      if (application != null) {
        _localCache = ProfileMapper.withApplication(_localCache, application);
      }
      return _localCache;
    } on ProfileException {
      rethrow;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 && user != null) {
        _localCache = ProfileMapper.fromSessionUser(
          user,
          localOverlay: _localCache,
        );
        return _localCache;
      }
      throw _mapDioException(e);
    }
  }

  @override
  Future<ProfileModel> updateBankAccount({
    required String bankName,
    required String accountNumber,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        _bankAccountPath,
        data: BankAccountUpdateRequest(
          bankName: bankName,
          accountNumber: accountNumber,
        ).toJson(),
      );
      final dto = _parseEnvelope(response.data, response.statusCode ?? 0);
      _localCache = ProfileMapper.fromBeneficiary(
        dto,
        localOverlay: _localCache,
      );
      return _localCache;
    } on ProfileException {
      rethrow;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// `GET /api/auth/v1/me`: `displayName`, `phone` (and no `email` for
  /// donors). Optional: the profile falls back to the token's claims.
  Future<Map<String, dynamic>?> _fetchAuthMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(_authMePath);
      final body = response.data;
      final data = body?['data'];
      if (body?['success'] != true || data is! Map) {
        return null;
      }
      return Map<String, dynamic>.from(data);
    } on DioException {
      return null;
    }
  }

  /// Application status is optional: the profile still loads without it.
  Future<ApplicationStatusDto?> _fetchApplication() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(_applicationPath);
      final body = response.data;
      final data = body?['data'];
      if (body?['success'] != true || data is! Map) {
        return null;
      }
      return ApplicationStatusDto.fromJson(Map<String, dynamic>.from(data));
    } on DioException {
      return null;
    }
  }

  @override
  Future<void> persistProfile(ProfileModel profile) async {
    _localCache = profile;
  }

  BeneficiaryDto _parseEnvelope(Map<String, dynamic>? body, int status) {
    if (body == null) {
      throw ProfileException('Empty response body');
    }
    if (body['success'] != true) {
      throw ProfileException(
        parseMobileErrorMessage(body) ?? 'Request was not successful',
      );
    }
    final data = body['data'];
    if (data is! Map) {
      throw ProfileException('Missing data in response');
    }
    if (status < 200 || status > 299) {
      throw ProfileException('Unexpected status: $status');
    }
    return BeneficiaryDto.fromJson(Map<String, dynamic>.from(data));
  }

  ProfileException _mapDioException(DioException e) {
    final parsed = parseMobileErrorMessage(e.response?.data);
    if (parsed != null && parsed.isNotEmpty) {
      return ProfileException(parsed);
    }
    return ProfileException(e.message ?? 'Network error');
  }
}
