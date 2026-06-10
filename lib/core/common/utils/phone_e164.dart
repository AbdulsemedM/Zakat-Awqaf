/// Helpers for API phone fields that require [E.164](https://www.e164.org/) format.
abstract final class PhoneE164 {
  static final _e164Pattern = RegExp(r'^\+[1-9]\d{1,14}$');

  /// Ethiopia country calling code (default for local-number normalization).
  static const ethiopiaCountryCode = '251';

  static bool isValid(String phone) => _e164Pattern.hasMatch(phone.trim());

  /// Converts common local formats (e.g. `0911223344`) to E.164 (`+251911223344`).
  ///
  /// Returns `null` when [input] cannot be normalized. Values already in E.164
  /// (with optional spaces/dashes) are returned unchanged when valid.
  static String? normalize(
    String input, {
    String countryCode = ethiopiaCountryCode,
  }) {
    var raw = input.trim();
    if (raw.isEmpty) {
      return null;
    }

    raw = raw.replaceAll(RegExp(r'[\s\-().]'), '');

    if (raw.startsWith('+')) {
      return isValid(raw) ? raw : null;
    }

    if (raw.startsWith(countryCode)) {
      final candidate = '+$raw';
      return isValid(candidate) ? candidate : null;
    }

    if (raw.startsWith('0')) {
      raw = raw.substring(1);
    }

    // Ethiopian mobiles: 9 digits starting with 9.
    if (RegExp(r'^9\d{8}$').hasMatch(raw)) {
      final candidate = '+$countryCode$raw';
      return isValid(candidate) ? candidate : null;
    }

    return null;
  }
}
