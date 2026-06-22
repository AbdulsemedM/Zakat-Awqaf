class DonationException implements Exception {
  DonationException(this.message);

  final String message;

  @override
  String toString() => message;
}
