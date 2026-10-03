import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'auth_session_controller.dart';
import 'auth_token_storage.dart';

/// Who may pay zakat: guests and signed-in donors. Beneficiaries (and staff)
/// receive disbursements and never pay; the payments API answers them with
/// 403 `PAYER_NOT_ALLOWED`, so the app hides pay buttons and payment history.
@lazySingleton
class PayerAccess extends ChangeNotifier {
  PayerAccess(this._session, this._tokenStorage) {
    _session.addListener(_refresh);
    _refresh();
  }

  final AuthSessionController _session;
  final AuthTokenStorage _tokenStorage;

  bool _isBeneficiary = false;

  /// Guests and donors.
  bool get canPay => !(_session.isAuthenticated && _isBeneficiary);

  /// Signed in and allowed to pay: has a payment history.
  bool get isSignedInDonor => _session.isAuthenticated && !_isBeneficiary;

  Future<void> _refresh() async {
    final user = _session.isAuthenticated
        ? await _tokenStorage.readUser()
        : null;
    _isBeneficiary = user?.isBeneficiary ?? false;
    notifyListeners();
  }
}
