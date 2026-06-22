/// Parsed response from `POST /api/payments/v1/donations`.
class DonationResponse {
  const DonationResponse({
    required this.success,
    this.message,
    this.paymentUrl,
    this.rawData,
  });

  final bool success;
  final String? message;
  final String? paymentUrl;
  final Map<String, dynamic>? rawData;

  factory DonationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};

    return DonationResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      paymentUrl: _resolvePaymentUrl(json, dataMap),
      rawData: dataMap.isEmpty ? null : dataMap,
    );
  }

  static String? _resolvePaymentUrl(
    Map<String, dynamic> envelope,
    Map<String, dynamic> data,
  ) {
    for (final source in [data, envelope]) {
      for (final key in [
        'redirectUrl',
        'paymentUrl',
        'checkoutUrl',
        'url',
        'hostedPaymentUrl',
      ]) {
        final value = source[key]?.toString().trim();
        if (value != null && value.isNotEmpty) {
          return value;
        }
      }
    }
    return null;
  }
}
