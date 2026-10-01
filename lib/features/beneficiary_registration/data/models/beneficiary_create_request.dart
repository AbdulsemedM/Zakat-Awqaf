/// API body for `POST /api/beneficiaries/v1/beneficiaries` (multipart
/// registration with a registration code; expect HTTP 201).
final class FullBeneficiaryCreateRequest {
  const FullBeneficiaryCreateRequest({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.registrationCode,
    required this.beneficiaryType,
    required this.category,
    required this.notes,
    this.dateOfBirth,
    this.nationalId,
    this.addressLine,
    this.maritalStatus,
    this.religion,
    this.kebele,
    this.profilePicturePath,
  });

  final String fullName;
  final String phone;
  final String email;

  /// `YYYY-MM-DD`.
  final String? dateOfBirth;
  final String gender;
  final String registrationCode;
  final String beneficiaryType;
  final String category;
  final String notes;

  // Optional basic details; region/zone/woreda always come from the branch.
  final String? nationalId;
  final String? addressLine;
  final String? maritalStatus;
  final String? religion;
  final String? kebele;
  final String? profilePicturePath;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'fullName': fullName.trim(),
      'phone': phone.trim(),
      'gender': gender.trim(),
      'registrationCode': registrationCode.trim(),
      'beneficiaryType': beneficiaryType.trim(),
      'category': category.trim(),
      'notes': notes.trim(),
    };
    void putText(String key, String? value) {
      final v = value?.trim();
      if (v != null && v.isNotEmpty) {
        json[key] = v;
      }
    }

    // Without an email the API creates no sign-in account.
    putText('email', email);
    putText('dateOfBirth', dateOfBirth);
    putText('nationalId', nationalId);
    putText('addressLine', addressLine);
    putText('maritalStatus', maritalStatus);
    putText('religion', religion);
    putText('kebele', kebele);
    return json;
  }
}
