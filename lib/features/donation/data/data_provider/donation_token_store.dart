import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Donation tokens (`X-Donation-Token`), kept in the Keychain/Keystore. The
/// server returns a token only once, in the create response; without it the
/// donation's status can't be read.
abstract class DonationTokenStore {
  Future<String?> tokenForDonation(String donationId);

  Future<void> saveToken(String donationId, String token);
}

@LazySingleton(as: DonationTokenStore)
class SecureDonationTokenStore implements DonationTokenStore {
  SecureDonationTokenStore() : _storage = const FlutterSecureStorage();

  static const _key = 'donation_tokens_v1';

  final FlutterSecureStorage _storage;

  Future<Map<String, String>> _read() async {
    final raw = await _storage.read(key: _key);
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

  @override
  Future<String?> tokenForDonation(String donationId) async =>
      (await _read())[donationId];

  @override
  Future<void> saveToken(String donationId, String token) async {
    final tokens = await _read();
    tokens[donationId] = token;
    await _storage.write(key: _key, value: jsonEncode(tokens));
  }
}
