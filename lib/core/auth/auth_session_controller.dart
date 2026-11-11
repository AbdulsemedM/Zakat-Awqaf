import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'auth_token_storage.dart';
import 'token_refresher.dart';

@lazySingleton
class AuthSessionController extends ChangeNotifier {
  AuthSessionController(this._tokenStorage, this._refresher);

  final AuthTokenStorage _tokenStorage;
  final TokenRefresher _refresher;

  bool _isAuthenticated = false;
  bool _initialized = false;
  bool _passwordChangeRequired = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get initialized => _initialized;

  /// Signed in with a temporary password: the app shows only the
  /// change-password screen until it is changed.
  bool get passwordChangeRequired =>
      _isAuthenticated && _passwordChangeRequired;

  /// Signed in while there is a usable token or a refresh token. An expired
  /// access token is renewed in the background; only the server's
  /// "session expired" signs the user out.
  Future<void> initialize() async {
    _isAuthenticated = await _tokenStorage.hasValidSession();
    _passwordChangeRequired =
        _isAuthenticated && await _tokenStorage.readPasswordChangeRequired();
    _initialized = true;
    notifyListeners();
    if (_isAuthenticated) unawaited(_renewIfExpiring());
  }

  Future<void> _renewIfExpiring() async {
    if (await _refresher.validAccessToken() == null) markLoggedOut();
  }

  void markAuthenticated({bool passwordChangeRequired = false}) {
    if (_isAuthenticated && _passwordChangeRequired == passwordChangeRequired) {
      return;
    }
    _isAuthenticated = true;
    _passwordChangeRequired = passwordChangeRequired;
    notifyListeners();
  }

  /// The server answered 403 `PASSWORD_CHANGE_REQUIRED`.
  Future<void> markPasswordChangeRequired() async {
    if (!_isAuthenticated || _passwordChangeRequired) return;
    await _tokenStorage.markPasswordChangeRequired();
    _passwordChangeRequired = true;
    notifyListeners();
  }

  void markLoggedOut() {
    if (!_isAuthenticated) {
      return;
    }
    _isAuthenticated = false;
    _passwordChangeRequired = false;
    notifyListeners();
  }
}
