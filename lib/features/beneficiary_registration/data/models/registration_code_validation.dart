/// Response of `POST /api/beneficiaries/v1/registration-codes/validate`.
class RegistrationCodeValidation {
  const RegistrationCodeValidation({
    required this.code,
    required this.valid,
    this.branchName,
    this.region,
    this.zone,
    this.woreda,
    this.message,
  });

  /// The code this result belongs to (trimmed, as sent).
  final String code;
  final bool valid;
  final String? branchName;
  final String? region;
  final String? zone;
  final String? woreda;

  /// Server message when the code is not valid.
  final String? message;

  /// "Region, Zone, Woreda" with empty parts skipped.
  String get locationLine => [region, zone, woreda]
      .map((e) => e?.trim() ?? '')
      .where((e) => e.isNotEmpty)
      .join(', ');

  factory RegistrationCodeValidation.fromJson(
    String code,
    Map<String, dynamic> json, {
    String? message,
  }) {
    return RegistrationCodeValidation(
      code: code,
      valid: json['valid'] == true,
      branchName: json['branchName'] as String?,
      region: json['region'] as String?,
      zone: json['zone'] as String?,
      woreda: json['woreda'] as String?,
      message: message,
    );
  }
}
