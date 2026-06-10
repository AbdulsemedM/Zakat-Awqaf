class BeneficiaryRegistrationException implements Exception {
  BeneficiaryRegistrationException(this.message);

  final String message;

  @override
  String toString() => message;
}
