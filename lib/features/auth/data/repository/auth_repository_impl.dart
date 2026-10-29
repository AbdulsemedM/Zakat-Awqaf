import 'package:injectable/injectable.dart';

import '../../../../core/auth/auth_session_controller.dart';
import '../../../../core/auth/auth_token_storage.dart';
import '../../../../core/auth/token_refresher.dart';
import '../../../donation/data/data_provider/donation_token_store.dart';
import '../../../zakat_payment/data/data_provider/device_payments_store.dart';
import '../../../zakat_payment/data/data_provider/guest_payment_token_store.dart';
import '../data_provider/auth_data_provider.dart';
import '../models/login_request.dart';
import '../models/set_password_request.dart';
import 'auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._dataProvider,
    this._tokenStorage,
    this._sessionController,
    this._refresher,
    this._guestPaymentTokens,
    this._donationTokens,
    this._devicePayments,
  );

  final AuthDataProvider _dataProvider;
  final AuthTokenStorage _tokenStorage;
  final AuthSessionController _sessionController;
  final TokenRefresher _refresher;
  final GuestPaymentTokenStore _guestPaymentTokens;
  final DonationTokenStore _donationTokens;
  final DevicePaymentsStore _devicePayments;

  @override
  Future<void> login(LoginRequest request) async {
    final dto = await _dataProvider.login(request);
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
}
