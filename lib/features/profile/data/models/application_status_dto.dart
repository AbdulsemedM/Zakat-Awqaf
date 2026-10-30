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
    this.lastDisbursementAmountEtb,
    this.lastDisbursementPaidAt,
    this.totalAidReceivedEtb,
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

  /// `lastDisbursement`: absent until the first payout.
  final double? lastDisbursementAmountEtb;
  final DateTime? lastDisbursementPaidAt;

  /// `0` before the first payout.
  final double? totalAidReceivedEtb;

  factory ApplicationStatusDto.fromJson(Map<String, dynamic> json) {
    String? text(String key) {
      final value = json[key];
      return value is String && value.trim().isNotEmpty ? value.trim() : null;
    }

    final lastDisbursement = json['lastDisbursement'];
    final disbursement = lastDisbursement is Map ? lastDisbursement : const {};
    final lastAmount = disbursement['amountEtb'];
    final total = json['totalAidReceivedEtb'];

    return ApplicationStatusDto(
      verificationStatus: text('verificationStatus'),
      verificationReason: text('verificationReason'),
      caseStatus: text('caseStatus'),
      beneficiaryCategory: text('beneficiaryCategory'),
      lastDisbursementAmountEtb: lastAmount is num
          ? lastAmount.toDouble()
          : null,
      lastDisbursementPaidAt: DateTime.tryParse(
        disbursement['paidAt']?.toString() ?? '',
      ),
      totalAidReceivedEtb: total is num ? total.toDouble() : null,
    );
  }
}
