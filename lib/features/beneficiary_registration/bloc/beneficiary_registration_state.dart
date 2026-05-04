import 'package:equatable/equatable.dart';

enum BeneficiaryRegistrationStep { welcome, identity, needs, disbursement }

enum RegistrationMethod { fastTrack, manual }
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
    this.identityVerified = false,
    this.firstName = '',
    this.fatherName = '',
    this.grandFatherName = '',
    this.phoneNumber = '',
    this.email = '',
    this.profilePicture,
    this.gender,
    this.birthdate,
    this.address = '',
    this.situationDescription = '',
    this.uploadedProofName,
    this.accountOrMobileNumber = '',
    this.legalName = '',
    this.hasAcceptedCompliance = false,
    this.errorMessage,
    this.submissionSuccess = false,
  });

  final BeneficiaryRegistrationStep step;
  final RegistrationMethod method;
  final Set<AsnafCategory> selectedCategories;
  final PayoutMethod payoutMethod;
  final String nationalId;
  final bool identityVerified;
  final String firstName;
  final String fatherName;
  final String grandFatherName;
  final String phoneNumber;
  final String email;
  final String? profilePicture;
  final Gender? gender;
  final DateTime? birthdate;
  final String address;
  final String situationDescription;
  final String? uploadedProofName;
  final String accountOrMobileNumber;
  final String legalName;
  final bool hasAcceptedCompliance;
  final String? errorMessage;
  final bool submissionSuccess;

  double get progressValue {
    switch (step) {
      case BeneficiaryRegistrationStep.welcome:
        return 0.25;
      case BeneficiaryRegistrationStep.identity:
        return 0.5;
      case BeneficiaryRegistrationStep.needs:
        return 0.75;
      case BeneficiaryRegistrationStep.disbursement:
        return 1.0;
    }
  }

  bool get isIdentityStepComplete {
    if (method == RegistrationMethod.fastTrack) {
      return identityVerified;
    }

    return firstName.trim().isNotEmpty &&
        fatherName.trim().isNotEmpty &&
        grandFatherName.trim().isNotEmpty &&
        phoneNumber.trim().isNotEmpty &&
        email.trim().isNotEmpty &&
        profilePicture != null &&
        gender != null &&
        birthdate != null &&
        address.trim().isNotEmpty;
  }

  @override
  List<Object?> get props => [
    step,
    method,
    selectedCategories,
    payoutMethod,
    nationalId,
    identityVerified,
    firstName,
    fatherName,
    grandFatherName,
    phoneNumber,
    email,
    profilePicture,
    gender,
    birthdate,
    address,
    situationDescription,
    uploadedProofName,
    accountOrMobileNumber,
    legalName,
    hasAcceptedCompliance,
    errorMessage,
    submissionSuccess,
  ];
}

final class BeneficiaryRegistrationInitial extends BeneficiaryRegistrationState {
  const BeneficiaryRegistrationInitial({
    super.step = BeneficiaryRegistrationStep.welcome,
    super.method = RegistrationMethod.fastTrack,
    super.selectedCategories = const {},
    super.payoutMethod = PayoutMethod.telebirrWallet,
    super.nationalId,
    super.identityVerified,
    super.firstName,
    super.fatherName,
    super.grandFatherName,
    super.phoneNumber,
    super.email,
    super.profilePicture,
    super.gender,
    super.birthdate,
    super.address,
    super.situationDescription,
    super.uploadedProofName,
    super.accountOrMobileNumber,
    super.legalName,
    super.hasAcceptedCompliance,
    super.errorMessage,
    super.submissionSuccess,
  });

  BeneficiaryRegistrationInitial copyWith({
    BeneficiaryRegistrationStep? step,
    RegistrationMethod? method,
    Set<AsnafCategory>? selectedCategories,
    PayoutMethod? payoutMethod,
    String? nationalId,
    bool? identityVerified,
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
    String? situationDescription,
    String? uploadedProofName,
    bool clearUploadedProof = false,
    String? accountOrMobileNumber,
    String? legalName,
    bool? hasAcceptedCompliance,
    String? errorMessage,
    bool clearError = false,
    bool? submissionSuccess,
  }) {
    return BeneficiaryRegistrationInitial(
      step: step ?? this.step,
      method: method ?? this.method,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      payoutMethod: payoutMethod ?? this.payoutMethod,
      nationalId: nationalId ?? this.nationalId,
      identityVerified: identityVerified ?? this.identityVerified,
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
      situationDescription: situationDescription ?? this.situationDescription,
      uploadedProofName: clearUploadedProof
          ? null
          : (uploadedProofName ?? this.uploadedProofName),
      accountOrMobileNumber: accountOrMobileNumber ?? this.accountOrMobileNumber,
      legalName: legalName ?? this.legalName,
      hasAcceptedCompliance: hasAcceptedCompliance ?? this.hasAcceptedCompliance,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
    );
  }
}
