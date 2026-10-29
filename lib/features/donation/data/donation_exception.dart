class DonationException implements Exception {
  DonationException(this.message, {this.statusCode});

  final String message;

  /// HTTP status of the failed call, when the server answered.
  final int? statusCode;

  @override
  String toString() => message;
}
