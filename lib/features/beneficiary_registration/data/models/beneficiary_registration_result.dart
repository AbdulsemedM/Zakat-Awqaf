import 'beneficiary_dto.dart';

class BeneficiaryRegistrationResult {
  const BeneficiaryRegistrationResult({
    required this.dto,
    required this.statusCode,
  });

  final BeneficiaryDto dto;
  final int statusCode;
}
