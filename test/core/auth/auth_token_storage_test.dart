import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/auth/auth_token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A JWT whose payload is [claims] (signature not checked by the app).
String _jwt(Map<String, dynamic> claims) {
  String part(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${part({'alg': 'none'})}.${part(claims)}.sig';
}

final _token = _jwt({
  'name': 'Test Donor',
  'email': 'donor@example.com',
  'preferred_username': '+251911223344',
  'realm_access': {
    'roles': ['DONOR'],
  },
});

/// What an older version left in SharedPreferences.
Map<String, Object> _legacySession() => {
  'auth_access_token': _token,
  'auth_refresh_token': 'refresh-1',
  'auth_token_type': 'Bearer',
  'auth_expires_at_ms': 4102444800000,
  'auth_user_name': 'Test Donor',
  'auth_user_email': 'donor@example.com',
  'auth_user_phone': '+251911223344',
  'auth_user_roles': ['DONOR'],
};

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });

  test(
    'a saved session is kept in secure storage, not in plain text',
    () async {
      await AuthTokenStorage().saveSession(
        accessToken: _token,
        refreshToken: 'refresh-1',
        tokenType: 'Bearer',
        expiresInSeconds: 300,
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys(), isEmpty);

      // A new instance (app restart) reads it back.
      final storage = AuthTokenStorage();
      expect(await storage.readAccessToken(), _token);
      expect(await storage.readRefreshToken(), 'refresh-1');
      final user = await storage.readUser();
      expect(user?.name, 'Test Donor');
      expect(user?.isDonor, isTrue);
    },
  );

  test('a session from an older version is moved to secure storage', () async {
    SharedPreferences.setMockInitialValues({
      ..._legacySession(),
      'app_locale': 'am',
    });

    final storage = AuthTokenStorage();
    expect(await storage.hasValidSession(), isTrue);
    expect(await storage.readRefreshToken(), 'refresh-1');
    expect((await storage.readUser())?.phone, '+251911223344');

    // The plain-text copy is gone; other settings are untouched.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getKeys(), {'app_locale'});

    // After a restart the session comes from secure storage.
    expect(await AuthTokenStorage().readAccessToken(), _token);
  });

  test('clear signs out, also after a restart', () async {
    final storage = AuthTokenStorage();
    await storage.saveSession(
      accessToken: _token,
      refreshToken: 'refresh-1',
      tokenType: 'Bearer',
      expiresInSeconds: 300,
    );
    await storage.clear();

    expect(await storage.readAccessToken(), isNull);
    expect(await storage.readUser(), isNull);
    expect(await AuthTokenStorage().hasValidSession(), isFalse);
  });

  test(
    'clear right after start also removes an older version\'s session',
    () async {
      SharedPreferences.setMockInitialValues(_legacySession());

      await AuthTokenStorage().clear();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys(), isEmpty);
      expect(await AuthTokenStorage().readAccessToken(), isNull);
    },
  );
}
