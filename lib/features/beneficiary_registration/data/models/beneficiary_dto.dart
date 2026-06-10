class BeneficiaryDto {
  const BeneficiaryDto({
    required this.id,
    this.fullName,
    this.phone,
    this.email,
    this.nationalId,
    this.dateOfBirth,
    this.gender,
    this.region,
    this.city,
    this.addressLine,
    this.beneficiaryType,
    this.verificationStatus,
    this.verificationReason,
    this.notes,
    this.identityProviderSub,
    this.verificationLink,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? nationalId;
  final String? dateOfBirth;
  final String? gender;
  final String? region;
  final String? city;
  final String? addressLine;
  final String? beneficiaryType;
  final String? verificationStatus;
  final String? verificationReason;
  final String? notes;
  final String? identityProviderSub;
  final String? verificationLink;
  final String? createdAt;
  final String? updatedAt;

  factory BeneficiaryDto.fromJson(Map<String, dynamic> json) {
    return BeneficiaryDto(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      nationalId: json['nationalId'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
      addressLine: json['addressLine'] as String?,
      beneficiaryType: json['beneficiaryType'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      verificationReason: json['verificationReason'] as String?,
      notes: json['notes'] as String?,
      identityProviderSub: json['identityProviderSub'] as String?,
      verificationLink: json['verificationLink'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
