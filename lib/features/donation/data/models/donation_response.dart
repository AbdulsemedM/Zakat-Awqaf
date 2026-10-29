/// Parsed response from `POST /api/payments/v1/donations`.
class DonationResponse {
  const DonationResponse({
    required this.success,
    this.message,
    this.donationId,
    this.donationToken,
    this.merchantReference,
    this.status,
    this.paymentUrl,
    this.rawData,
  });

  final bool success;
  final String? message;
  final String? donationId;

  /// Secret for `GET /donations/{id}` (`X-Donation-Token`). Returned only
  /// once, here; the repository keeps it in secure storage.
  final String? donationToken;
  final String? merchantReference;
  final String? status;
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
      donationId: _string(dataMap['donationId']),
      donationToken: _string(dataMap['donationToken']),
      merchantReference: _string(dataMap['merchantReference']),
      status: _string(dataMap['status']),
      paymentUrl: _resolvePaymentUrl(json, dataMap),
      // The token stays out of rawData so it can't leak through it.
      rawData: dataMap.isEmpty
          ? null
          : (Map.of(dataMap)..remove('donationToken')),
    );
  }

  static String? _string(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
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
