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
    required this.gender,
    required this.registrationCode,
    required this.beneficiaryType,
    required this.category,
    required this.notes,
    this.dateOfBirth,
    this.estimatedAge,
    this.nationalId,
    this.addressLine,
    this.maritalStatus,
    this.religion,
    this.primaryLanguage,
    this.primaryLanguageOther,
    this.kebele,
    this.profilePicturePath,
  });

  final String fullName;
  final String phone;
  final String email;

  /// `YYYY-MM-DD`; when null, [estimatedAge] should be set instead.
  final String? dateOfBirth;
  final String gender;
  final String registrationCode;
  final String beneficiaryType;
  final String category;
  final String notes;

  // Optional basic details; region/zone/woreda always come from the branch.
  final int? estimatedAge;
  final String? nationalId;
  final String? addressLine;
  final String? maritalStatus;
  final String? religion;
  final String? primaryLanguage;
  final String? primaryLanguageOther;
  final String? kebele;
  final String? profilePicturePath;

  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'fullName': fullName.trim(),
      'phone': phone.trim(),
      'email': email.trim(),
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

    putText('dateOfBirth', dateOfBirth);
    if (estimatedAge != null) {
      json['estimatedAge'] = estimatedAge;
    }
    putText('nationalId', nationalId);
    putText('addressLine', addressLine);
    putText('maritalStatus', maritalStatus);
    putText('religion', religion);
    putText('primaryLanguage', primaryLanguage);
    if (primaryLanguage == 'other') {
      putText('primaryLanguageOther', primaryLanguageOther);
    }
    putText('kebele', kebele);
    return json;
  }
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
