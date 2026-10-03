/// `GET /api/beneficiaries/v1/me/application` (zakat API guide, section 8).
///
/// Fields with no value are left out by the server. It never contains
/// score, risk or assessment data.
class ApplicationStatusDto {
  const ApplicationStatusDto({
    this.verificationStatus,
    this.verificationReason,
    this.caseStatus,
    this.beneficiaryCategory,
  });

  /// `pending`, `verified` or `rejected`.
  final String? verificationStatus;

  /// Present only when staff gave one (e.g. on rejection).
  final String? verificationReason;

  /// `SUBMITTED`, `VERIFIED`, `APPROVED`, `ACTIVE` or `CLOSED`; absent while
  /// no case exists.
  final String? caseStatus;

  /// Asnaf value, e.g. `poor`, `fi_sabilillah`.
  final String? beneficiaryCategory;

  factory ApplicationStatusDto.fromJson(Map<String, dynamic> json) {
    String? text(String key) {
      final value = json[key];
      return value is String && value.trim().isNotEmpty ? value.trim() : null;
    }

    return ApplicationStatusDto(
      verificationStatus: text('verificationStatus'),
      verificationReason: text('verificationReason'),
      caseStatus: text('caseStatus'),
      beneficiaryCategory: text('beneficiaryCategory'),
    );
  }
}
