import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'auth_session_controller.dart';
import 'auth_token_storage.dart';

/// Who may pay zakat: guests, and signed-in donors (roles contain `DONOR`
/// and none of `BENEFICIARY`, `ADMIN`, `BRANCH`, `FIELD_OFFICER`; the
/// backend's own rule). Beneficiaries receive disbursements and staff use
/// the back office; the payments API answers both with 403
/// `PAYER_NOT_ALLOWED`, so the app hides pay buttons, history and giving
/// figures from them.
@lazySingleton
class PayerAccess extends ChangeNotifier {
  PayerAccess(this._session, this._tokenStorage) {
    _session.addListener(_refresh);
    _refresh();
  }

  final AuthSessionController _session;
  final AuthTokenStorage _tokenStorage;

  bool _isDonor = false;

  /// Guests and donors.
  bool get canPay => !_session.isAuthenticated || _isDonor;

  /// Signed in as a donor: has a payment history and giving figures.
  bool get isSignedInDonor => _session.isAuthenticated && _isDonor;

  Future<void> _refresh() async {
    final user = _session.isAuthenticated
        ? await _tokenStorage.readUser()
        : null;
    _isDonor = user?.isDonor ?? false;
    notifyListeners();
  }
}
