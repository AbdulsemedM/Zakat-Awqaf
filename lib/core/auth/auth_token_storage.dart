import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'jwt_payload.dart';

class StoredAuthUser {
  const StoredAuthUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.roles,
  });

  final String name;
  final String email;
  final String phone;
  final List<String> roles;

  bool get isBeneficiary => _has('BENEFICIARY');

  /// Staff accounts; they never pay zakat in the app.
  bool get isStaff => _has('ADMIN') || _has('BRANCH') || _has('FIELD_OFFICER');

  /// The backend's rule: `DONOR` and none of the beneficiary or staff roles
  /// (some older beneficiary accounts still carry `DONOR`).
  bool get isDonor => _has('DONOR') && !isBeneficiary && !isStaff;

  bool _has(String role) => roles.any((r) => r.toUpperCase() == role);
}

/// The signed-in session (tokens and the user's name, contacts and roles),
/// kept in the Keychain/Keystore as one entry and cached in memory.
/// Sessions saved by older versions in SharedPreferences are moved here on
/// first read and the plain-text copy is deleted.
@lazySingleton
class AuthTokenStorage {
  AuthTokenStorage()
    : _secure = const FlutterSecureStorage(
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  static const _sessionKey = 'auth_session_v1';

  static const _accessToken = 'accessToken';
  static const _refreshToken = 'refreshToken';
  static const _tokenType = 'tokenType';
  static const _expiresAtMs = 'expiresAtMs';
  static const _userName = 'name';
  static const _userEmail = 'email';
  static const _userPhone = 'phone';
  static const _userRoles = 'roles';

  /// SharedPreferences keys used before the move to secure storage.
  static const _legacyAccessTokenKey = 'auth_access_token';
  static const _legacyRefreshTokenKey = 'auth_refresh_token';
  static const _legacyTokenTypeKey = 'auth_token_type';
  static const _legacyExpiresAtKey = 'auth_expires_at_ms';
  static const _legacyUserNameKey = 'auth_user_name';
  static const _legacyUserEmailKey = 'auth_user_email';
  static const _legacyUserPhoneKey = 'auth_user_phone';
  static const _legacyUserRolesKey = 'auth_user_roles';

  final FlutterSecureStorage _secure;

  /// Loaded once; every later read and write goes through it.
  Future<Map<String, Object?>?>? _session;

  Future<Map<String, Object?>?> _read() => _session ??= _loadOrRetryLater();

  Future<Map<String, Object?>?> _loadOrRetryLater() async {
    try {
      return await _load();
    } catch (_) {
      _session = null;
      rethrow;
    }
  }

  /// Waits for a first load (and its legacy move) to finish, so it can't
  /// overwrite a newer write; a failed load doesn't matter here.
  Future<void> _settle() async {
    try {
      await _read();
    } catch (_) {}
  }

  Future<Map<String, Object?>?> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = _legacySession(prefs);
    if (legacy != null) {
      await _secure.write(key: _sessionKey, value: jsonEncode(legacy));
    }
    // Only once the session is safe in secure storage.
    await _removeLegacySession(prefs);
    if (legacy != null) return legacy;
    try {
      final raw = await _secure.read(key: _sessionKey);
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      return decoded is Map ? Map<String, Object?>.from(decoded) : null;
    } on PlatformException {
      // The Keystore key is gone (e.g. restored to another device).
    } on FormatException {
      // Corrupt entry.
    }
    await _secure.delete(key: _sessionKey);
    return null;
  }

  /// A session saved in plain text by an older version, or `null`.
  Map<String, Object?>? _legacySession(SharedPreferences prefs) {
    final accessToken = prefs.getString(_legacyAccessTokenKey);
    return accessToken == null
        ? null
        : <String, Object?>{
            _accessToken: accessToken,
            _refreshToken: prefs.getString(_legacyRefreshTokenKey),
            _tokenType: prefs.getString(_legacyTokenTypeKey),
            _expiresAtMs: prefs.getInt(_legacyExpiresAtKey),
            _userName: prefs.getString(_legacyUserNameKey),
            _userEmail: prefs.getString(_legacyUserEmailKey),
            _userPhone: prefs.getString(_legacyUserPhoneKey),
            _userRoles: prefs.getStringList(_legacyUserRolesKey),
          };
  }

  Future<void> _removeLegacySession(SharedPreferences prefs) async {
    for (final key in const [
      _legacyAccessTokenKey,
      _legacyRefreshTokenKey,
      _legacyTokenTypeKey,
      _legacyExpiresAtKey,
      _legacyUserNameKey,
      _legacyUserEmailKey,
      _legacyUserPhoneKey,
      _legacyUserRolesKey,
    ]) {
      if (prefs.containsKey(key)) await prefs.remove(key);
    }
  }

  Future<String?> readAccessToken() async =>
      (await _read())?[_accessToken] as String?;

  Future<String?> readRefreshToken() async =>
      (await _read())?[_refreshToken] as String?;

  /// Signed in: an access token that is still valid, or a refresh token to
  /// get a new one (the server decides whether the session is still alive;
  /// app sessions last 30 days without use, 90 at most).
  Future<bool> hasValidSession() async {
    final token = await readAccessToken();
    if (token == null || token.trim().isEmpty) {
      return false;
    }
    final refreshToken = await readRefreshToken();
    if (refreshToken != null && refreshToken.trim().isNotEmpty) {
      return true;
    }
    final expiresAt = await readAccessTokenExpiry();
    return expiresAt == null || DateTime.now().isBefore(expiresAt);
  }

  /// When the stored access token expires, if known.
  Future<DateTime?> readAccessTokenExpiry() async {
    final expiresAt = (await _read())?[_expiresAtMs] as num?;
    return expiresAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(expiresAt.toInt());
  }

  Future<StoredAuthUser?> readUser() async {
    final session = await _read();
    // Signed in when a session was saved; the token may carry no name (e.g.
    // a donor, whose name comes from `GET /auth/v1/me`).
    if (session?[_accessToken] == null) {
      return null;
    }
    final roles = session![_userRoles];
    return StoredAuthUser(
      name: session[_userName] as String? ?? '',
      email: session[_userEmail] as String? ?? '',
      phone: session[_userPhone] as String? ?? '',
      roles: roles is List ? roles.map((r) => r.toString()).toList() : const [],
    );
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresInSeconds,
  }) async {
    final expiresAt = DateTime.now()
        .add(Duration(seconds: expiresInSeconds))
        .millisecondsSinceEpoch;
    final claims = JwtPayload.decode(accessToken) ?? const <String, dynamic>{};
    final roles = JwtPayload.roles(claims);
    final name =
        claims['name']?.toString().trim() ??
        [
          claims['given_name']?.toString(),
          claims['family_name']?.toString(),
        ].whereType<String>().where((e) => e.trim().isNotEmpty).join(' ');
    final email = claims['email']?.toString().trim() ?? '';
    final phone = claims['preferred_username']?.toString().trim() ?? '';

    final session = <String, Object?>{
      _accessToken: accessToken,
      _refreshToken: refreshToken,
      _tokenType: tokenType,
      _expiresAtMs: expiresAt,
      _userName: name,
      _userEmail: email,
      _userPhone: phone,
      _userRoles: roles,
    };
    await _settle();
    _session = Future.value(session);
    await _secure.write(key: _sessionKey, value: jsonEncode(session));
  }

  Future<void> clear() async {
    await _settle();
    _session = Future.value(null);
    await _secure.delete(key: _sessionKey);
  }
}
