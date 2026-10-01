import 'package:equatable/equatable.dart';

import '../data/models/asnaf_category.dart';
import '../data/models/basic_detail_options.dart';
import '../data/models/beneficiary_dto.dart';
import '../data/models/institution_kyc_document.dart';
import '../data/models/institution_subtype.dart';
import '../data/models/registration_code_validation.dart';

enum BeneficiaryRegistrationStep {
  welcome,
  identity,
  needs,
  disbursement,
  institutionDetails,
  setPassword,
  institutionDocuments,
}

enum RegistrationMethod { manual, institution }

enum Gender { male, female }

enum PayoutMethod { telebirrWallet, mPesa, coopbank }

sealed class BeneficiaryRegistrationState extends Equatable {
  const BeneficiaryRegistrationState({
    required this.step,
    required this.method,
    this.selectedCategory,
    required this.payoutMethod,
    this.registrationCode = '',
    this.firstName = '',
    this.fatherName = '',
    this.grandFatherName = '',
    this.phoneNumber = '',
    this.email = '',
    this.profilePicture,
    this.gender,
    this.birthdate,
    this.address = '',
    this.region = '',
    this.city = '',
    this.notes = '',
    this.situationDescription = '',
    this.uploadedProofName,
    this.accountOrMobileNumber = '',
    this.legalName = '',
    this.hasAcceptedCompliance = false,
    this.tradingName = '',
    this.tradeRegistrationNumber = '',
    this.taxIdentificationNumber = '',
    this.vatRegistrationNumber = '',
    this.institutionSubtype = InstitutionSubtype.company,
    this.authorityToActDocumentRequired = false,
    this.companyDocumentUploadToken,
    this.kycDocuments = const [],
    this.pickedDocumentPaths = const {},
    this.uploadingDocumentCode,
    this.institutionRegistrationSubmitted = false,
    this.institutionRequiredKycComplete = false,
    this.password = '',
    this.confirmPassword = '',
    this.isSettingPassword = false,
    this.passwordSetupComplete = false,
    this.errorMessage,
    this.submissionSuccess = false,
    this.isSubmitting = false,
    this.manualIdentitySubmitted = false,
    this.createdBeneficiaryId,
    this.registeredBeneficiary,
    this.passwordSetupToken,
    this.codeValidation,
    this.isValidatingCode = false,
    this.maritalStatus,
    this.religion = 'Muslim',
    this.kebele = '',
  });

  final BeneficiaryRegistrationStep step;
  final RegistrationMethod method;
  final AsnafCategory? selectedCategory;
  final PayoutMethod payoutMethod;
  final String registrationCode;
  final String firstName;
  final String fatherName;
  final String grandFatherName;
  final String phoneNumber;
  final String email;
  final String? profilePicture;
  final Gender? gender;
  final DateTime? birthdate;
  final String address;
  final String region;
  final String city;
  final String notes;
  final String situationDescription;
  final String? uploadedProofName;
  final String accountOrMobileNumber;
  final String legalName;
  final bool hasAcceptedCompliance;
  final String tradingName;
  final String tradeRegistrationNumber;
  final String taxIdentificationNumber;
  final String vatRegistrationNumber;
  final InstitutionSubtype institutionSubtype;
  final bool authorityToActDocumentRequired;
  final String? companyDocumentUploadToken;
  final List<InstitutionKycDocument> kycDocuments;
  final Map<String, String> pickedDocumentPaths;
  final String? uploadingDocumentCode;
  final bool institutionRegistrationSubmitted;
  final bool institutionRequiredKycComplete;
  final String password;
  final String confirmPassword;
  final bool isSettingPassword;
  final bool passwordSetupComplete;
  final String? errorMessage;
  final bool submissionSuccess;
  final bool isSubmitting;
  final bool manualIdentitySubmitted;
  final String? createdBeneficiaryId;
  final BeneficiaryDto? registeredBeneficiary;
  final String? passwordSetupToken;
  final RegistrationCodeValidation? codeValidation;
  final bool isValidatingCode;
  final MaritalStatus? maritalStatus;
  final String religion;
  final String kebele;

  /// True once the current [registrationCode] was checked and accepted.
  bool get isRegistrationCodeVerified =>
      codeValidation != null &&
      codeValidation!.valid &&
      codeValidation!.code == registrationCode.trim();

  String? get resolvedPasswordSetupToken {
    final fromState = passwordSetupToken?.trim() ?? '';
    if (fromState.isNotEmpty) {
      return fromState;
    }
    return registeredBeneficiary?.passwordSetupToken?.trim();
  }

  double get progressValue {
    switch (step) {
      case BeneficiaryRegistrationStep.welcome:
        return 0.25;
      case BeneficiaryRegistrationStep.identity:
      case BeneficiaryRegistrationStep.institutionDetails:
        return 0.5;
      case BeneficiaryRegistrationStep.setPassword:
        return 0.65;
      case BeneficiaryRegistrationStep.needs:
      case BeneficiaryRegistrationStep.institutionDocuments:
        return 0.75;
      case BeneficiaryRegistrationStep.disbursement:
        return 1.0;
    }
  }

  bool get isSetPasswordStepComplete {
    return password.trim().isNotEmpty &&
        confirmPassword.trim().isNotEmpty &&
        password == confirmPassword;
  }

  bool get isIdentityStepComplete {
    return firstName.trim().isNotEmpty &&
        fatherName.trim().isNotEmpty &&
        grandFatherName.trim().isNotEmpty &&
        phoneNumber.trim().isNotEmpty &&
        gender != null &&
        birthdate != null &&
        isRegistrationCodeVerified &&
        kebele.trim().isNotEmpty &&
        address.trim().isNotEmpty &&
        notes.trim().isNotEmpty &&
        selectedCategory != null;
  }

  bool get isInstitutionDetailsComplete {
    return isRegistrationCodeVerified &&
        legalName.trim().isNotEmpty &&
        tradingName.trim().isNotEmpty &&
        tradeRegistrationNumber.trim().isNotEmpty &&
        taxIdentificationNumber.trim().isNotEmpty &&
        phoneNumber.trim().isNotEmpty &&
        email.trim().isNotEmpty &&
        region.trim().isNotEmpty &&
        city.trim().isNotEmpty &&
        address.trim().isNotEmpty;
  }

  @override
  List<Object?> get props => [
    step,
    method,
    selectedCategory,
    payoutMethod,
    registrationCode,
    firstName,
    fatherName,
    grandFatherName,
    phoneNumber,
    email,
    profilePicture,
    gender,
    birthdate,
    address,
    region,
    city,
    notes,
    situationDescription,
    uploadedProofName,
    accountOrMobileNumber,
    legalName,
    hasAcceptedCompliance,
    tradingName,
    tradeRegistrationNumber,
    taxIdentificationNumber,
    vatRegistrationNumber,
    institutionSubtype,
    authorityToActDocumentRequired,
    companyDocumentUploadToken,
    kycDocuments,
    pickedDocumentPaths,
    uploadingDocumentCode,
    institutionRegistrationSubmitted,
    institutionRequiredKycComplete,
    password,
    confirmPassword,
    isSettingPassword,
    passwordSetupComplete,
    errorMessage,
    submissionSuccess,
    isSubmitting,
    manualIdentitySubmitted,
    createdBeneficiaryId,
    registeredBeneficiary,
    passwordSetupToken,
    codeValidation,
    isValidatingCode,
    maritalStatus,
    religion,
    kebele,
  ];
}

final class BeneficiaryRegistrationInitial
    extends BeneficiaryRegistrationState {
  const BeneficiaryRegistrationInitial({
    super.step = BeneficiaryRegistrationStep.welcome,
    super.method = RegistrationMethod.manual,
    super.selectedCategory,
    super.payoutMethod = PayoutMethod.telebirrWallet,
    super.registrationCode,
    super.firstName,
    super.fatherName,
    super.grandFatherName,
    super.phoneNumber,
    super.email,
    super.profilePicture,
    super.gender,
    super.birthdate,
    super.address,
    super.region,
    super.city,
    super.notes,
    super.situationDescription,
    super.uploadedProofName,
    super.accountOrMobileNumber,
    super.legalName,
    super.hasAcceptedCompliance,
    super.tradingName,
    super.tradeRegistrationNumber,
    super.taxIdentificationNumber,
    super.vatRegistrationNumber,
    super.institutionSubtype,
    super.authorityToActDocumentRequired,
    super.companyDocumentUploadToken,
    super.kycDocuments,
    super.pickedDocumentPaths,
    super.uploadingDocumentCode,
    super.institutionRegistrationSubmitted,
    super.institutionRequiredKycComplete,
    super.password,
    super.confirmPassword,
    super.isSettingPassword,
    super.passwordSetupComplete,
    super.errorMessage,
    super.submissionSuccess,
    super.isSubmitting,
    super.manualIdentitySubmitted,
    super.createdBeneficiaryId,
    super.registeredBeneficiary,
    super.passwordSetupToken,
    super.codeValidation,
    super.isValidatingCode,
    super.maritalStatus,
    super.religion,
    super.kebele,
  });

  BeneficiaryRegistrationInitial copyWith({
    BeneficiaryRegistrationStep? step,
    RegistrationMethod? method,
    AsnafCategory? selectedCategory,
    bool clearSelectedCategory = false,
    PayoutMethod? payoutMethod,
    String? registrationCode,
    String? firstName,
    String? fatherName,
    String? grandFatherName,
    String? phoneNumber,
    String? email,
    String? profilePicture,
    bool clearProfilePicture = false,
    Gender? gender,
    DateTime? birthdate,
    bool clearBirthdate = false,
    String? address,
    String? region,
    String? city,
    String? notes,
    String? situationDescription,
    String? uploadedProofName,
    bool clearUploadedProof = false,
    String? accountOrMobileNumber,
    String? legalName,
    bool? hasAcceptedCompliance,
    String? tradingName,
    String? tradeRegistrationNumber,
    String? taxIdentificationNumber,
    String? vatRegistrationNumber,
    InstitutionSubtype? institutionSubtype,
    bool? authorityToActDocumentRequired,
    String? companyDocumentUploadToken,
    bool clearCompanyDocumentUploadToken = false,
    List<InstitutionKycDocument>? kycDocuments,
    Map<String, String>? pickedDocumentPaths,
    String? uploadingDocumentCode,
    bool clearUploadingDocumentCode = false,
    bool? institutionRegistrationSubmitted,
    bool? institutionRequiredKycComplete,
    String? password,
    String? confirmPassword,
    bool? isSettingPassword,
    bool? passwordSetupComplete,
    bool clearPasswordFields = false,
    String? errorMessage,
    bool clearError = false,
    bool? submissionSuccess,
    bool? isSubmitting,
    bool? manualIdentitySubmitted,
    String? createdBeneficiaryId,
    BeneficiaryDto? registeredBeneficiary,
    String? passwordSetupToken,
    bool clearBeneficiaryMeta = false,
    bool clearInstitutionMeta = false,
    RegistrationCodeValidation? codeValidation,
    bool? isValidatingCode,
    MaritalStatus? maritalStatus,
    String? religion,
    String? kebele,
    bool clearCodeValidation = false,
    bool clearMaritalStatus = false,
  }) {
    return BeneficiaryRegistrationInitial(
      step: step ?? this.step,
      method: method ?? this.method,
      selectedCategory: clearSelectedCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      payoutMethod: payoutMethod ?? this.payoutMethod,
      registrationCode: registrationCode ?? this.registrationCode,
      firstName: firstName ?? this.firstName,
      fatherName: fatherName ?? this.fatherName,
      grandFatherName: grandFatherName ?? this.grandFatherName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePicture: clearProfilePicture
          ? null
          : (profilePicture ?? this.profilePicture),
      gender: gender ?? this.gender,
      birthdate: clearBirthdate ? null : (birthdate ?? this.birthdate),
      address: address ?? this.address,
      region: region ?? this.region,
      city: city ?? this.city,
      notes: notes ?? this.notes,
      situationDescription: situationDescription ?? this.situationDescription,
      uploadedProofName: clearUploadedProof
          ? null
          : (uploadedProofName ?? this.uploadedProofName),
      accountOrMobileNumber:
          accountOrMobileNumber ?? this.accountOrMobileNumber,
      legalName: legalName ?? this.legalName,
      hasAcceptedCompliance:
          hasAcceptedCompliance ?? this.hasAcceptedCompliance,
      tradingName: tradingName ?? this.tradingName,
      tradeRegistrationNumber:
          tradeRegistrationNumber ?? this.tradeRegistrationNumber,
      taxIdentificationNumber:
          taxIdentificationNumber ?? this.taxIdentificationNumber,
      vatRegistrationNumber:
          vatRegistrationNumber ?? this.vatRegistrationNumber,
      institutionSubtype: institutionSubtype ?? this.institutionSubtype,
      authorityToActDocumentRequired:
          authorityToActDocumentRequired ?? this.authorityToActDocumentRequired,
      companyDocumentUploadToken:
          clearCompanyDocumentUploadToken || clearInstitutionMeta
          ? null
          : (companyDocumentUploadToken ?? this.companyDocumentUploadToken),
      kycDocuments: clearInstitutionMeta
          ? const []
          : (kycDocuments ?? this.kycDocuments),
      pickedDocumentPaths: clearInstitutionMeta
          ? const {}
          : (pickedDocumentPaths ?? this.pickedDocumentPaths),
      uploadingDocumentCode: clearUploadingDocumentCode
          ? null
          : (uploadingDocumentCode ?? this.uploadingDocumentCode),
      institutionRegistrationSubmitted: clearInstitutionMeta
          ? false
          : (institutionRegistrationSubmitted ??
                this.institutionRegistrationSubmitted),
      institutionRequiredKycComplete: clearInstitutionMeta
          ? false
          : (institutionRequiredKycComplete ??
                this.institutionRequiredKycComplete),
      password: clearPasswordFields ? '' : (password ?? this.password),
      confirmPassword: clearPasswordFields
          ? ''
          : (confirmPassword ?? this.confirmPassword),
      isSettingPassword: isSettingPassword ?? this.isSettingPassword,
      passwordSetupComplete:
          passwordSetupComplete ?? this.passwordSetupComplete,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      submissionSuccess: clearBeneficiaryMeta
          ? false
          : (submissionSuccess ?? this.submissionSuccess),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      manualIdentitySubmitted:
          manualIdentitySubmitted ?? this.manualIdentitySubmitted,
      createdBeneficiaryId: clearBeneficiaryMeta || clearInstitutionMeta
          ? null
          : (createdBeneficiaryId ?? this.createdBeneficiaryId),
      registeredBeneficiary: clearBeneficiaryMeta
          ? null
          : (registeredBeneficiary ?? this.registeredBeneficiary),
      passwordSetupToken: clearBeneficiaryMeta || clearInstitutionMeta
          ? null
          : (passwordSetupToken ?? this.passwordSetupToken),
      codeValidation: clearCodeValidation
          ? null
          : (codeValidation ?? this.codeValidation),
      isValidatingCode: isValidatingCode ?? this.isValidatingCode,
      maritalStatus: clearMaritalStatus
          ? null
          : (maritalStatus ?? this.maritalStatus),
      religion: religion ?? this.religion,
      kebele: kebele ?? this.kebele,
    );
  }
}
