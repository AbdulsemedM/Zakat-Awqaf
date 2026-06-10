import 'package:equatable/equatable.dart';

import '../data/models/beneficiary_dto.dart';
import '../data/models/institution_kyc_document.dart';
import '../data/models/institution_subtype.dart';

enum BeneficiaryRegistrationStep {
  welcome,
  identity,
  needs,
  disbursement,
  institutionDetails,
  institutionDocuments,
}

enum RegistrationMethod { fastTrack, manual, institution }

enum Gender { male, female }

enum AsnafCategory {
  fakir,
  miskin,
  amil,
  muallaf,
  riqab,
  gharimin,
  fisabilillah,
  ibnSabil,
}

enum PayoutMethod { telebirrWallet, mPesa, coopbank }

sealed class BeneficiaryRegistrationState extends Equatable {
  const BeneficiaryRegistrationState({
    required this.step,
    required this.method,
    required this.selectedCategories,
    required this.payoutMethod,
    this.nationalId = '',
    this.generatedNationalId,
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
    this.errorMessage,
    this.submissionSuccess = false,
    this.isSubmitting = false,
    this.isFaydaPosting = false,
    this.awaitingFaydaSse = false,
    this.faydaVerificationComplete = false,
    this.manualIdentitySubmitted = false,
    this.createdBeneficiaryId,
    this.verificationLink,
    this.registeredBeneficiary,
  });

  final BeneficiaryRegistrationStep step;
  final RegistrationMethod method;
  final Set<AsnafCategory> selectedCategories;
  final PayoutMethod payoutMethod;
  final String nationalId;
  final String? generatedNationalId;
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
  final String? errorMessage;
  final bool submissionSuccess;
  final bool isSubmitting;
  final bool isFaydaPosting;
  final bool awaitingFaydaSse;
  final bool faydaVerificationComplete;
  final bool manualIdentitySubmitted;
  final String? createdBeneficiaryId;
  final String? verificationLink;
  final BeneficiaryDto? registeredBeneficiary;

  double get progressValue {
    switch (step) {
      case BeneficiaryRegistrationStep.welcome:
        return 0.25;
      case BeneficiaryRegistrationStep.identity:
      case BeneficiaryRegistrationStep.institutionDetails:
        return 0.5;
      case BeneficiaryRegistrationStep.needs:
      case BeneficiaryRegistrationStep.institutionDocuments:
        return 0.75;
      case BeneficiaryRegistrationStep.disbursement:
        return 1.0;
    }
  }

  bool get isIdentityStepComplete {
    if (method == RegistrationMethod.fastTrack) {
      return false;
    }

    return firstName.trim().isNotEmpty &&
        fatherName.trim().isNotEmpty &&
        grandFatherName.trim().isNotEmpty &&
        phoneNumber.trim().isNotEmpty &&
        email.trim().isNotEmpty &&
        gender != null &&
        birthdate != null &&
        address.trim().isNotEmpty &&
        region.trim().isNotEmpty &&
        city.trim().isNotEmpty &&
        notes.trim().isNotEmpty;
  }

  bool get isInstitutionDetailsComplete {
    return legalName.trim().isNotEmpty &&
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
        selectedCategories,
        payoutMethod,
        nationalId,
        generatedNationalId,
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
        errorMessage,
        submissionSuccess,
        isSubmitting,
        isFaydaPosting,
        awaitingFaydaSse,
        faydaVerificationComplete,
        manualIdentitySubmitted,
        createdBeneficiaryId,
        verificationLink,
        registeredBeneficiary,
      ];
}

final class BeneficiaryRegistrationInitial extends BeneficiaryRegistrationState {
  const BeneficiaryRegistrationInitial({
    super.step = BeneficiaryRegistrationStep.welcome,
    super.method = RegistrationMethod.fastTrack,
    super.selectedCategories = const {},
    super.payoutMethod = PayoutMethod.telebirrWallet,
    super.nationalId,
    super.generatedNationalId,
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
    super.errorMessage,
    super.submissionSuccess,
    super.isSubmitting,
    super.isFaydaPosting,
    super.awaitingFaydaSse,
    super.faydaVerificationComplete,
    super.manualIdentitySubmitted,
    super.createdBeneficiaryId,
    super.verificationLink,
    super.registeredBeneficiary,
  });

  BeneficiaryRegistrationInitial copyWith({
    BeneficiaryRegistrationStep? step,
    RegistrationMethod? method,
    Set<AsnafCategory>? selectedCategories,
    PayoutMethod? payoutMethod,
    String? nationalId,
    String? generatedNationalId,
    bool clearGeneratedNationalId = false,
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
    String? errorMessage,
    bool clearError = false,
    bool? submissionSuccess,
    bool? isSubmitting,
    bool? isFaydaPosting,
    bool? awaitingFaydaSse,
    bool? faydaVerificationComplete,
    bool? manualIdentitySubmitted,
    String? createdBeneficiaryId,
    String? verificationLink,
    BeneficiaryDto? registeredBeneficiary,
    bool clearBeneficiaryMeta = false,
    bool clearFaydaProgress = false,
    bool clearInstitutionMeta = false,
  }) {
    return BeneficiaryRegistrationInitial(
      step: step ?? this.step,
      method: method ?? this.method,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      payoutMethod: payoutMethod ?? this.payoutMethod,
      nationalId: nationalId ?? this.nationalId,
      generatedNationalId: clearGeneratedNationalId
          ? null
          : (generatedNationalId ?? this.generatedNationalId),
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
      accountOrMobileNumber: accountOrMobileNumber ?? this.accountOrMobileNumber,
      legalName: legalName ?? this.legalName,
      hasAcceptedCompliance: hasAcceptedCompliance ?? this.hasAcceptedCompliance,
      tradingName: tradingName ?? this.tradingName,
      tradeRegistrationNumber:
          tradeRegistrationNumber ?? this.tradeRegistrationNumber,
      taxIdentificationNumber:
          taxIdentificationNumber ?? this.taxIdentificationNumber,
      vatRegistrationNumber:
          vatRegistrationNumber ?? this.vatRegistrationNumber,
      institutionSubtype: institutionSubtype ?? this.institutionSubtype,
      authorityToActDocumentRequired: authorityToActDocumentRequired ??
          this.authorityToActDocumentRequired,
      companyDocumentUploadToken: clearCompanyDocumentUploadToken ||
              clearInstitutionMeta
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
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      submissionSuccess: clearBeneficiaryMeta
          ? false
          : (submissionSuccess ?? this.submissionSuccess),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFaydaPosting: clearBeneficiaryMeta || clearFaydaProgress
          ? false
          : (isFaydaPosting ?? this.isFaydaPosting),
      awaitingFaydaSse: clearBeneficiaryMeta || clearFaydaProgress
          ? false
          : (awaitingFaydaSse ?? this.awaitingFaydaSse),
      faydaVerificationComplete: clearFaydaProgress
          ? false
          : (faydaVerificationComplete ?? this.faydaVerificationComplete),
      manualIdentitySubmitted:
          manualIdentitySubmitted ?? this.manualIdentitySubmitted,
      createdBeneficiaryId: clearBeneficiaryMeta || clearInstitutionMeta
          ? null
          : (createdBeneficiaryId ?? this.createdBeneficiaryId),
      verificationLink: clearBeneficiaryMeta || clearFaydaProgress
          ? null
          : (verificationLink ?? this.verificationLink),
      registeredBeneficiary: clearBeneficiaryMeta
          ? null
          : (registeredBeneficiary ?? this.registeredBeneficiary),
    );
  }
}
