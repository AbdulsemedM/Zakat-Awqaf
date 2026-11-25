import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_envelope.dart';
import '../models/login_response_dto.dart';
import '../models/otp_challenge.dart';

/// Account flows confirmed by an SMS code. Password reset and donor sign-up
/// are public and use the auth Dio (no token); the phone change is for the
/// signed-in user and goes through the main Dio, which adds the token.
/// Failures are [ApiException]s carrying the server's `code` and `data`.
@lazySingleton
class AccountOtpDataProvider {
  AccountOtpDataProvider(@Named('authDio') this._authDio, this._dio);

  final Dio _authDio;
  final Dio _dio;

  static const _reset = 'api/auth/v1/password-reset';
  static const _signup = 'api/auth/v1/donors/signup';
  static const _phone = 'api/auth/v1/me/phone';
  static const _password = 'api/auth/v1/me/password';

  static String _id(String id) => Uri.encodeComponent(id);

  Future<OtpChallenge> _challenge(
    Dio dio,
    String path,
    String idKey, {
    Object? data,
    String? language,
  }) => guardApi(() async {
    final response = await dio.post<dynamic>(
      path,
      data: data,
      options: language == null
          ? null
          : Options(headers: {'Accept-Language': language}),
    );
    return OtpChallenge.fromJson(unwrapApiObject(response), idKey: idKey);
  });

  Future<void> _post(Dio dio, String path, Object data) => guardApi(() async {
    unwrapApiData(await dio.post<dynamic>(path, data: data));
  });

  /// [phone] in E.164. Answers the same whether or not it has an account.
  /// The SMS is in the account's preferred language, else [language] (the
  /// app's, sent as `Accept-Language`), else English.
  Future<OtpChallenge> startPasswordReset(String phone, {String? language}) =>
      _challenge(
        _authDio,
        _reset,
        'resetId',
        data: {'username': phone},
        language: language,
      );

  Future<OtpChallenge> resendPasswordReset(
    String resetId, {
    String? language,
  }) => _challenge(
    _authDio,
    '$_reset/${_id(resetId)}/resend',
    'resetId',
    language: language,
  );

  /// Ends every session of the account, on all devices.
  Future<void> confirmPasswordReset(
    String resetId, {
    required String code,
    required String newPassword,
  }) => _post(_authDio, '$_reset/${_id(resetId)}/confirm', {
    'code': code,
    'newPassword': newPassword,
  });

  Future<OtpChallenge> startDonorSignup({
    required String phone,
    required String fullName,
  }) => _challenge(
    _authDio,
    _signup,
    'signupId',
    data: {'phone': phone, 'fullName': fullName},
  );

  Future<OtpChallenge> resendDonorSignup(String signupId) =>
      _challenge(_authDio, '$_signup/${_id(signupId)}/resend-otp', 'signupId');

  /// The new donor's login tokens, or `null` when the account was created
  /// but the automatic sign-in failed (the user signs in themselves).
  Future<LoginResponseDto?> verifyDonorSignup(
    String signupId, {
    required String otp,
    required String password,
  }) => guardApi(() async {
    final response = await _authDio.post<dynamic>(
      '$_signup/${_id(signupId)}/verify',
      data: {'otp': otp, 'password': password},
    );
    final data = unwrapApiData(response);
    if (data is! Map) return null;
    final dto = LoginResponseDto.fromJson(Map<String, dynamic>.from(data));
    return dto.accessToken.isEmpty || dto.refreshToken.isEmpty ? null : dto;
  });

  /// The code goes to [newPhone] (E.164). A wrong [currentPassword] is 400
  /// `CURRENT_PASSWORD_INVALID`; too many starts, 429 `CHANGE_LIMIT`.
  Future<OtpChallenge> startPhoneChange(
    String newPhone, {
    required String currentPassword,
  }) => _challenge(
    _dio,
    _phone,
    'changeId',
    data: {'newPhone': newPhone, 'currentPassword': currentPassword},
  );

  Future<OtpChallenge> resendPhoneChange(String changeId) =>
      _challenge(_dio, '$_phone/${_id(changeId)}/resend', 'changeId');

  /// Signed in. A wrong [currentPassword] is 400 `CURRENT_PASSWORD_INVALID`
  /// (the session is still valid), a weak new one 400, too many failures
  /// 429 `TOO_MANY_ATTEMPTS`. On success every session of the account ends,
  /// on all devices.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _post(_dio, _password, {
    'currentPassword': currentPassword,
    'newPassword': newPassword,
    'confirmNewPassword': newPassword,
  });

  /// Ends every session of the account, on all devices.
  Future<void> verifyPhoneChange(String changeId, {required String code}) =>
      _post(_dio, '$_phone/${_id(changeId)}/verify', {'code': code});
}
