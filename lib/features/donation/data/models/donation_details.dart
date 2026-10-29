/// Parsed `data` of `GET /api/payments/v1/donations/{id}`.
class DonationDetails {
  const DonationDetails({
    required this.id,
    required this.status,
    this.merchantReference,
    this.amountEtb,
  });

  final String id;

  /// `SUBMITTED` until the bank's callback arrives, then `SUCCEEDED` or a
  /// failure status.
  final String status;
  final String? merchantReference;
  final double? amountEtb;

  bool get succeeded => status == 'SUCCEEDED';

  bool get pending =>
      const {'SUBMITTED', 'PENDING', 'PROCESSING'}.contains(status);

  factory DonationDetails.fromJson(Map<String, dynamic> json) {
    return DonationDetails(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString().trim().toUpperCase() ?? '',
      merchantReference: json['merchantReference']?.toString(),
      amountEtb: (json['amountEtb'] as num?)?.toDouble(),
    );
  }
}
