import 'package:injectable/injectable.dart';

import '../../../../core/auth/auth_session_controller.dart';
import '../../../../core/auth/auth_token_storage.dart';
import '../../../../core/auth/token_refresher.dart';
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
  );

  final AuthDataProvider _dataProvider;
  final AuthTokenStorage _tokenStorage;
  final AuthSessionController _sessionController;
  final TokenRefresher _refresher;

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
  /// then on the phone whatever the result.
  @override
  Future<void> logout() async {
    await _refresher.logout();
    await _tokenStorage.clear();
    _sessionController.markLoggedOut();
  }

  @override
  Future<bool> hasSession() => _tokenStorage.hasValidSession();
}
