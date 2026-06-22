/// API body for `POST /api/beneficiaries/v1/beneficiaries`.
sealed class BeneficiaryRegistrationRequest {
  const BeneficiaryRegistrationRequest();

  Map<String, dynamic> toJson();
}

/// Mode A — full registration (expect HTTP 201).
final class FullBeneficiaryCreateRequest extends BeneficiaryRegistrationRequest {
  const FullBeneficiaryCreateRequest({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.registrationCode,
    required this.beneficiaryType,
    required this.category,
    required this.notes,
    this.profilePicturePath,
  });

  final String fullName;
  final String phone;
  final String email;
  final String dateOfBirth;
  final String gender;
  final String registrationCode;
  final String beneficiaryType;
  final String category;
  final String notes;
  final String? profilePicturePath;

  @override
  Map<String, dynamic> toJson() => {
        'fullName': fullName.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
        'dateOfBirth': dateOfBirth.trim(),
        'gender': gender.trim(),
        'registrationCode': registrationCode.trim(),
        'beneficiaryType': beneficiaryType.trim(),
        'category': category.trim(),
        'notes': notes.trim(),
      };
}

/// Mode B — national ID / Fayda path (expect HTTP 202).
final class NationalIdBeneficiaryCreateRequest extends BeneficiaryRegistrationRequest {
  const NationalIdBeneficiaryCreateRequest({
    required this.registrationCode,
    required this.nationalId,
  });

  final String registrationCode;
  final String nationalId;

  @override
  Map<String, dynamic> toJson() => {
        'registrationCode': registrationCode.trim(),
        'nationalId': nationalId.trim(),
      };
}
