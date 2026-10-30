import '../../../core/common/utils/phone_e164.dart';

/// Turns what the user typed on the sign-in screen (a phone number or an
/// email) into the username the auth API expects.
abstract final class LoginIdentifier {
  LoginIdentifier._();

  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _ethiopianMobile = RegExp(r'^\+2519\d{8}$');

  /// Anything with an "@" or letters is treated as an email, the rest as a
  /// phone number.
  static bool looksLikeEmail(String value) =>
      value.contains('@') || RegExp(r'[A-Za-z]').hasMatch(value);

  /// An Ethiopian mobile in E.164 (`+2519…`), or null.
  static String? resolvePhone(String raw) {
    final phone = PhoneE164.normalize(raw.trim());
    return phone != null && _ethiopianMobile.hasMatch(phone) ? phone : null;
  }

  /// An email as typed (trimmed), or an Ethiopian mobile in E.164
  /// (`+2519…`). Returns null when the input is neither.
  static String? resolve(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;
    if (looksLikeEmail(value)) {
      return _email.hasMatch(value) ? value : null;
    }
    return resolvePhone(value);
  }
}
