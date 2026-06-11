import 'institution_kyc_document.dart';

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
    this.beneficiaryCategory,
    this.hasProfilePicture,
    this.verificationStatus,
    this.verificationReason,
    this.notes,
    this.identityProviderSub,
    this.verificationLink,
    this.tradingName,
    this.tradeRegistrationNumber,
    this.taxIdentificationNumber,
    this.vatRegistrationNumber,
    this.institutionSubtype,
    this.institutionRecommendedKycDocuments = const [],
    this.institutionRequiredKycComplete,
    this.companyDocumentUploadToken,
    this.nationality,
    this.caseStatus,
    this.bankName,
    this.accountNumber,
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
  final String? beneficiaryCategory;
  final bool? hasProfilePicture;
  final String? verificationStatus;
  final String? verificationReason;
  final String? notes;
  final String? identityProviderSub;
  final String? verificationLink;
  final String? tradingName;
  final String? tradeRegistrationNumber;
  final String? taxIdentificationNumber;
  final String? vatRegistrationNumber;
  final String? institutionSubtype;
  final List<InstitutionKycDocument> institutionRecommendedKycDocuments;
  final bool? institutionRequiredKycComplete;
  final String? companyDocumentUploadToken;
  final String? nationality;
  final String? caseStatus;
  final String? bankName;
  final String? accountNumber;
  final String? createdAt;
  final String? updatedAt;

  factory BeneficiaryDto.fromJson(Map<String, dynamic> json) {
    final kycRaw = json['institutionRecommendedKycDocuments'];
    final kycDocuments = <InstitutionKycDocument>[];
    if (kycRaw is List) {
      for (final item in kycRaw) {
        if (item is Map) {
          kycDocuments.add(
            InstitutionKycDocument.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

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
      beneficiaryCategory: json['beneficiaryCategory'] as String?,
      hasProfilePicture: json['hasProfilePicture'] as bool?,
      verificationStatus: json['verificationStatus'] as String?,
      verificationReason: json['verificationReason'] as String?,
      notes: json['notes'] as String?,
      identityProviderSub: json['identityProviderSub'] as String?,
      verificationLink: json['verificationLink'] as String?,
      tradingName: json['tradingName'] as String?,
      tradeRegistrationNumber: json['tradeRegistrationNumber'] as String?,
      taxIdentificationNumber: json['taxIdentificationNumber'] as String?,
      vatRegistrationNumber: json['vatRegistrationNumber'] as String?,
      institutionSubtype: json['institutionSubtype'] as String?,
      institutionRecommendedKycDocuments: kycDocuments,
      institutionRequiredKycComplete:
          json['institutionRequiredKycComplete'] as bool?,
      companyDocumentUploadToken:
          json['companyDocumentUploadToken'] as String?,
      nationality: json['nationality'] as String?,
      caseStatus: json['caseStatus'] as String?,
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
