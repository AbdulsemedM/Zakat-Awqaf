import 'institution_subtype.dart';

/// API body for `POST /api/beneficiaries/v1/companies`.
class CompanyBeneficiaryCreateRequest {
  const CompanyBeneficiaryCreateRequest({
    required this.legalName,
    required this.tradingName,
    required this.tradeRegistrationNumber,
    required this.taxIdentificationNumber,
    required this.vatRegistrationNumber,
    required this.phone,
    required this.email,
    required this.region,
    required this.city,
    required this.addressLine,
    required this.institutionSubtype,
    required this.authorityToActDocumentRequired,
    required this.notes,
  });

  final String legalName;
  final String tradingName;
  final String tradeRegistrationNumber;
  final String taxIdentificationNumber;
  final String vatRegistrationNumber;
  final String phone;
  final String email;
  final String region;
  final String city;
  final String addressLine;
  final InstitutionSubtype institutionSubtype;
  final bool authorityToActDocumentRequired;
  final String notes;

  Map<String, dynamic> toJson() => {
        'legalName': legalName.trim(),
        'tradingName': tradingName.trim(),
        'tradeRegistrationNumber': tradeRegistrationNumber.trim(),
        'taxIdentificationNumber': taxIdentificationNumber.trim(),
        'vatRegistrationNumber': vatRegistrationNumber.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
        'region': region.trim(),
        'city': city.trim(),
        'addressLine': addressLine.trim(),
        'institutionSubtype': institutionSubtype.apiValue,
        'authorityToActDocumentRequired': authorityToActDocumentRequired,
        'notes': notes.trim(),
      };
}
