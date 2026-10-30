/// The server's password rules: at least 10 characters, with upper case,
/// lower case, a digit and a symbol. The server checks them too (and that
/// the password isn't the phone number), answering `WEAK_PASSWORD`.
abstract final class PasswordRules {
  PasswordRules._();

  static const minLength = 10;

  static final _upper = RegExp(r'[A-Z]');
  static final _lower = RegExp(r'[a-z]');
  static final _digit = RegExp(r'\d');
  static final _symbol = RegExp(r'[^A-Za-z0-9]');

  static bool isStrong(String password) =>
      password.length >= minLength &&
      _upper.hasMatch(password) &&
      _lower.hasMatch(password) &&
      _digit.hasMatch(password) &&
      _symbol.hasMatch(password);
}
