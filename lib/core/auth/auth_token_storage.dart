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

@lazySingleton
class AuthTokenStorage {
  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _tokenTypeKey = 'auth_token_type';
  static const _expiresAtKey = 'auth_expires_at_ms';
  static const _userNameKey = 'auth_user_name';
  static const _userEmailKey = 'auth_user_email';
  static const _userPhoneKey = 'auth_user_phone';
  static const _userRolesKey = 'auth_user_roles';

  Future<String?> readAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> readRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

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
    final prefs = await SharedPreferences.getInstance();
    final expiresAt = prefs.getInt(_expiresAtKey);
    return expiresAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(expiresAt);
  }

  Future<StoredAuthUser?> readUser() async {
    final prefs = await SharedPreferences.getInstance();
    // Signed in when a session was saved; the token may carry no name (e.g.
    // a donor, whose name comes from `GET /auth/v1/me`).
    if (prefs.getString(_accessTokenKey) == null) {
      return null;
    }
    final name = prefs.getString(_userNameKey) ?? '';
    final rolesRaw = prefs.getStringList(_userRolesKey) ?? const [];
    return StoredAuthUser(
      name: name,
      email: prefs.getString(_userEmailKey) ?? '',
      phone: prefs.getString(_userPhoneKey) ?? '',
      roles: rolesRaw,
    );
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresInSeconds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
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

    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_tokenTypeKey, tokenType);
    await prefs.setInt(_expiresAtKey, expiresAt);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userPhoneKey, phone);
    await prefs.setStringList(_userRolesKey, roles);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenTypeKey);
    await prefs.remove(_expiresAtKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userRolesKey);
  }
}
