import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Guest payment tokens (`X-Payment-Token`), kept in the Keychain/Keystore.
/// A token never expires: it opens its payment and certificate at any time.
abstract class GuestPaymentTokenStore {
  Future<String?> tokenForPayment(String paymentId);

  Future<String?> tokenForCertificate(String certificateId);

  /// Saves (or replaces, after a step 1 retry) the token for [paymentId].
  Future<void> savePaymentToken(String paymentId, String token);

  /// Links [certificateId] to the token of the payment that produced it.
  Future<void> linkCertificate(String certificateId, String paymentId);
}

@LazySingleton(as: GuestPaymentTokenStore)
class SecureGuestPaymentTokenStore implements GuestPaymentTokenStore {
  SecureGuestPaymentTokenStore() : _storage = const FlutterSecureStorage();

  static const _paymentsKey = 'zakat_guest_payment_tokens_v1';
  static const _certificatesKey = 'zakat_guest_certificate_payments_v1';

  final FlutterSecureStorage _storage;

  Future<Map<String, String>> _read(String key) async {
    final raw = await _storage.read(key: key);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map
          ? decoded.map((k, v) => MapEntry(k.toString(), v.toString()))
          : {};
    } on FormatException {
      return {};
    }
  }

  Future<void> _write(String key, Map<String, String> value) =>
      _storage.write(key: key, value: jsonEncode(value));

  @override
  Future<String?> tokenForPayment(String paymentId) async =>
      (await _read(_paymentsKey))[paymentId];

  @override
  Future<String?> tokenForCertificate(String certificateId) async {
    final paymentId = (await _read(_certificatesKey))[certificateId];
    return paymentId == null ? null : tokenForPayment(paymentId);
  }

  @override
  Future<void> savePaymentToken(String paymentId, String token) async {
    final tokens = await _read(_paymentsKey);
    tokens[paymentId] = token;
    await _write(_paymentsKey, tokens);
  }

  @override
  Future<void> linkCertificate(String certificateId, String paymentId) async {
    final links = await _read(_certificatesKey);
    if (links[certificateId] == paymentId) return;
    links[certificateId] = paymentId;
    await _write(_certificatesKey, links);
  }
}
