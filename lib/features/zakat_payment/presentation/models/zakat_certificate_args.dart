import '../../../zakat_calculator/bloc/zakat_calculator_state.dart';

/// Navigation extra for certificate screen + PDF generation.
class ZakatCertificateArgs {
  const ZakatCertificateArgs({
    required this.certificateId,
    required this.payerFullName,
    required this.amountEtb,
    required this.paymentMethodLabel,
    required this.issuedAt,
    required this.categoryTab,
    this.beneficiaryLabel,
    this.naturalUnitSummary,
    this.amountIsMarketEstimate = false,
  });

  final String certificateId;
  final String payerFullName;
  final double amountEtb;
  final String paymentMethodLabel;
  final DateTime issuedAt;
  final ZakatCategoryTab categoryTab;
  final String? beneficiaryLabel;

  /// Livestock/crops natural-unit reminder line for the PDF.
  final String? naturalUnitSummary;

  final bool amountIsMarketEstimate;
}
