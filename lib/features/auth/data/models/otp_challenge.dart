import '../../../../core/network/api_envelope.dart';

/// A code sent by SMS that the user must enter: a password reset, a donor
/// sign-up or a phone change. All three answer with the same shape, with
/// the id under a different key (`resetId`, `signupId`, `changeId`).
class OtpChallenge {
  const OtpChallenge({
    required this.id,
    this.maskedPhone,
    this.expiresAt,
    this.codeExpiresAt,
    this.attemptsLeft,
    this.resendsLeft,
  });

  final String id;

  /// Where the code went, e.g. `+251*****344`.
  final String? maskedPhone;

  /// After this the whole flow must start again.
  final DateTime? expiresAt;
  final DateTime? codeExpiresAt;

  /// Wrong codes left for the current code.
  final int? attemptsLeft;

  /// New codes that can still be asked for.
  final int? resendsLeft;

  bool get canResend => resendsLeft == null || resendsLeft! > 0;

  factory OtpChallenge.fromJson(
    Map<String, dynamic> json, {
    required String idKey,
  }) {
    final id = jsonString(json[idKey]);
    if (id == null || id.isEmpty) {
      throw FormatException('Missing $idKey');
    }
    final otp = json['otp'];
    final otpMap = otp is Map ? otp : const {};
    return OtpChallenge(
      id: id,
      maskedPhone: jsonString(json['phone']),
      expiresAt: jsonDate(json['expiresAt']),
      codeExpiresAt: jsonDate(otpMap['expiresAt']),
      attemptsLeft: jsonInt(otpMap['attemptsLeft']),
      resendsLeft: jsonInt(otpMap['resendsLeft']),
    );
  }

  /// The limits an error reported (`attemptsLeft`, `resendsLeft` in its
  /// `data`), keeping the rest.
  OtpChallenge withLimitsFrom(Map<String, dynamic> data) => OtpChallenge(
    id: id,
    maskedPhone: maskedPhone,
    expiresAt: expiresAt,
    codeExpiresAt: codeExpiresAt,
    attemptsLeft: jsonInt(data['attemptsLeft']) ?? attemptsLeft,
    resendsLeft: jsonInt(data['resendsLeft']) ?? resendsLeft,
  );
}
