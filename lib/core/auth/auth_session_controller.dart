import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'auth_token_storage.dart';

@lazySingleton
class AuthSessionController extends ChangeNotifier {
  AuthSessionController(this._tokenStorage);

  final AuthTokenStorage _tokenStorage;

  bool _isAuthenticated = false;
  bool _initialized = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get initialized => _initialized;

  Future<void> initialize() async {
    _isAuthenticated = await _tokenStorage.hasValidSession();
    _initialized = true;
    notifyListeners();
  }

  void markAuthenticated() {
    if (_isAuthenticated) {
      return;
    }
    _isAuthenticated = true;
    notifyListeners();
  }

  void markLoggedOut() {
    if (!_isAuthenticated) {
      return;
    }
    _isAuthenticated = false;
    notifyListeners();
  }
}
