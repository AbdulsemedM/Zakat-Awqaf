import 'package:injectable/injectable.dart';

import '../../../../core/auth/auth_session_controller.dart';
import '../../../../core/auth/auth_token_storage.dart';
import '../../../../core/auth/token_refresher.dart';
import '../../../donation/data/data_provider/donation_token_store.dart';
import '../../../zakat_payment/data/data_provider/device_payments_store.dart';
import '../../../zakat_payment/data/data_provider/guest_payment_token_store.dart';
import '../data_provider/account_otp_data_provider.dart';
import '../data_provider/auth_data_provider.dart';
import '../models/login_request.dart';
import '../models/login_response_dto.dart';
import '../models/otp_challenge.dart';
import '../models/set_password_request.dart';
import 'auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._dataProvider,
    this._otpDataProvider,
    this._tokenStorage,
    this._sessionController,
    this._refresher,
    this._guestPaymentTokens,
    this._donationTokens,
    this._devicePayments,
  );

  final AuthDataProvider _dataProvider;
  final AccountOtpDataProvider _otpDataProvider;
  final AuthTokenStorage _tokenStorage;
  final AuthSessionController _sessionController;
  final TokenRefresher _refresher;
  final GuestPaymentTokenStore _guestPaymentTokens;
  final DonationTokenStore _donationTokens;
  final DevicePaymentsStore _devicePayments;

  @override
  Future<void> login(LoginRequest request) async =>
      _startSession(await _dataProvider.login(request));

  Future<void> _startSession(LoginResponseDto dto) async {
    await _tokenStorage.saveSession(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
      tokenType: dto.tokenType,
      expiresInSeconds: dto.expiresIn > 0 ? dto.expiresIn : 300,
    );
    _sessionController.markAuthenticated();
  }

  @override
  Future<void> setBeneficiaryPassword(SetPasswordRequest request) {
    return _dataProvider.setBeneficiaryPassword(request);
  }

  /// Ends the session on the server (`POST /auth/v1/logout`, best effort),
  /// then on the phone whatever the result. Also forgets the payments and
  /// donations made on this device and their tokens, so the next person
  /// using it can't open them.
  @override
  Future<void> logout() async {
    await _refresher.logout();
    await _tokenStorage.clear();
    _sessionController.markLoggedOut();
    await _guestPaymentTokens.clear();
    await _donationTokens.clear();
    await _devicePayments.clear();
  }

  @override
  Future<bool> hasSession() => _tokenStorage.hasValidSession();

  @override
  Future<OtpChallenge> startPasswordReset(String phone) =>
      _otpDataProvider.startPasswordReset(phone);

  @override
  Future<OtpChallenge> resendPasswordReset(String resetId) =>
      _otpDataProvider.resendPasswordReset(resetId);

  @override
  Future<void> confirmPasswordReset(
    String resetId, {
    required String code,
    required String newPassword,
  }) => _otpDataProvider.confirmPasswordReset(
    resetId,
    code: code,
    newPassword: newPassword,
  );

  @override
  Future<OtpChallenge> startDonorSignup({
    required String phone,
    required String fullName,
  }) => _otpDataProvider.startDonorSignup(phone: phone, fullName: fullName);

  @override
  Future<OtpChallenge> resendDonorSignup(String signupId) =>
      _otpDataProvider.resendDonorSignup(signupId);

  @override
  Future<bool> completeDonorSignup(
    String signupId, {
    required String otp,
    required String password,
  }) async {
    final dto = await _otpDataProvider.verifyDonorSignup(
      signupId,
      otp: otp,
      password: password,
    );
    if (dto == null) return false;
    await _startSession(dto);
    return true;
  }

  @override
  Future<OtpChallenge> startPhoneChange(String newPhone) =>
      _otpDataProvider.startPhoneChange(newPhone);

  @override
  Future<OtpChallenge> resendPhoneChange(String changeId) =>
      _otpDataProvider.resendPhoneChange(changeId);

  @override
  Future<void> completePhoneChange(
    String changeId, {
    required String code,
  }) async {
    await _otpDataProvider.verifyPhoneChange(changeId, code: code);
    await logout();
  }
}
