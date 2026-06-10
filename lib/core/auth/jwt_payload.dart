import 'dart:convert';

/// Reads claims from a JWT payload without signature verification (display only).
abstract final class JwtPayload {
  static Map<String, dynamic>? decode(String token) {
    final parts = token.split('.');
    if (parts.length < 2) {
      return null;
    }
    try {
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded);
      if (json is Map<String, dynamic>) {
        return json;
      }
      if (json is Map) {
        return Map<String, dynamic>.from(json);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static List<String> roles(Map<String, dynamic> claims) {
    final realmAccess = claims['realm_access'];
    if (realmAccess is Map) {
      final roles = realmAccess['roles'];
      if (roles is List) {
        return roles.map((e) => e.toString()).toList();
      }
    }
    return const [];
  }
}
