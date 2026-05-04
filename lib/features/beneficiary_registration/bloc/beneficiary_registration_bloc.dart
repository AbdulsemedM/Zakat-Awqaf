import 'package:flutter_bloc/flutter_bloc.dart';

import 'beneficiary_registration_event.dart';
import 'beneficiary_registration_state.dart';

class BeneficiaryRegistrationBloc extends Bloc<
    BeneficiaryRegistrationEvent,
    BeneficiaryRegistrationState
> {
  BeneficiaryRegistrationBloc() : super(const BeneficiaryRegistrationInitial()) {
    on<BeneficiaryRegistrationStarted>(_onStarted);
    on<RegistrationMethodSelected>(_onMethodSelected);
    on<NationalIdUpdated>(_onNationalIdUpdated);
    on<IdentityVerificationRequested>(_onIdentityRequested);
    on<FirstNameUpdated>(_onFirstNameUpdated);
    on<FatherNameUpdated>(_onFatherNameUpdated);
    on<GrandFatherNameUpdated>(_onGrandFatherNameUpdated);
    on<PhoneNumberUpdated>(_onPhoneNumberUpdated);
    on<EmailUpdated>(_onEmailUpdated);
    on<ProfilePicturePicked>(_onProfilePicturePicked);
    on<ProfilePictureRemoved>(_onProfilePictureRemoved);
    on<GenderUpdated>(_onGenderUpdated);
    on<BirthdateUpdated>(_onBirthdateUpdated);
    on<AddressUpdated>(_onAddressUpdated);
    on<AsnafCategoryToggled>(_onAsnafCategoryToggled);
    on<SituationDescriptionUpdated>(_onSituationUpdated);
    on<SupportingProofPicked>(_onProofPicked);
    on<SupportingProofRemoved>(_onProofRemoved);
    on<PayoutMethodSelected>(_onPayoutSelected);
    on<AccountOrMobileUpdated>(_onAccountUpdated);
    on<LegalNameUpdated>(_onLegalNameUpdated);
    on<ComplianceToggled>(_onComplianceToggled);
    on<RegistrationStepAdvanced>(_onAdvanceStep);
    on<RegistrationStepWentBack>(_onBackStep);
    on<BeneficiarySubmissionRequested>(_onSubmit);
  }

  BeneficiaryRegistrationInitial get _current =>
      state is BeneficiaryRegistrationInitial
      ? state as BeneficiaryRegistrationInitial
      : const BeneficiaryRegistrationInitial();

  void _onStarted(
    BeneficiaryRegistrationStarted event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(const BeneficiaryRegistrationInitial());
  }

  void _onMethodSelected(
    RegistrationMethodSelected event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(method: event.method, clearError: true));
  }

  void _onNationalIdUpdated(
    NationalIdUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(nationalId: event.nationalId, clearError: true));
  }

  void _onIdentityRequested(
    IdentityVerificationRequested event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    final trimmedId = _current.nationalId.replaceAll(' ', '');
    if (trimmedId.length < 8) {
      emit(_current.copyWith(errorMessage: 'Please enter a valid national ID.'));
      return;
    }

    emit(
      _current.copyWith(
        identityVerified: true,
        clearError: true,
      ),
    );
  }

  void _onFirstNameUpdated(
    FirstNameUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(firstName: event.value, clearError: true));
  }

  void _onFatherNameUpdated(
    FatherNameUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(fatherName: event.value, clearError: true));
  }

  void _onGrandFatherNameUpdated(
    GrandFatherNameUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(grandFatherName: event.value, clearError: true));
  }

  void _onPhoneNumberUpdated(
    PhoneNumberUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(phoneNumber: event.value, clearError: true));
  }

  void _onEmailUpdated(
    EmailUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(email: event.value, clearError: true));
  }

  void _onProfilePicturePicked(
    ProfilePicturePicked event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(profilePicture: event.fileName, clearError: true));
  }

  void _onProfilePictureRemoved(
    ProfilePictureRemoved event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(clearProfilePicture: true, clearError: true));
  }

  void _onGenderUpdated(
    GenderUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(gender: event.value, clearError: true));
  }

  void _onBirthdateUpdated(
    BirthdateUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(birthdate: event.value, clearError: true));
  }

  void _onAddressUpdated(
    AddressUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(address: event.value, clearError: true));
  }

  void _onAsnafCategoryToggled(
    AsnafCategoryToggled event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    final selected = Set<AsnafCategory>.from(_current.selectedCategories);
    if (selected.contains(event.category)) {
      selected.remove(event.category);
    } else {
      selected.add(event.category);
    }
    emit(_current.copyWith(selectedCategories: selected, clearError: true));
  }

  void _onSituationUpdated(
    SituationDescriptionUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(situationDescription: event.description, clearError: true));
  }

  void _onProofPicked(
    SupportingProofPicked event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(uploadedProofName: event.fileName, clearError: true));
  }

  void _onProofRemoved(
    SupportingProofRemoved event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(clearUploadedProof: true, clearError: true));
  }

  void _onPayoutSelected(
    PayoutMethodSelected event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(payoutMethod: event.method, clearError: true));
  }

  void _onAccountUpdated(
    AccountOrMobileUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(accountOrMobileNumber: event.value, clearError: true));
  }

  void _onLegalNameUpdated(
    LegalNameUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(legalName: event.value, clearError: true));
  }

  void _onComplianceToggled(
    ComplianceToggled event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(hasAcceptedCompliance: event.accepted, clearError: true));
  }

  void _onAdvanceStep(
    RegistrationStepAdvanced event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    if (!_canMoveForward(_current)) return;

    switch (_current.step) {
      case BeneficiaryRegistrationStep.welcome:
        emit(_current.copyWith(step: BeneficiaryRegistrationStep.identity, clearError: true));
      case BeneficiaryRegistrationStep.identity:
        emit(_current.copyWith(step: BeneficiaryRegistrationStep.needs, clearError: true));
      case BeneficiaryRegistrationStep.needs:
        emit(_current.copyWith(step: BeneficiaryRegistrationStep.disbursement, clearError: true));
      case BeneficiaryRegistrationStep.disbursement:
        break;
    }
  }

  void _onBackStep(
    RegistrationStepWentBack event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    switch (_current.step) {
      case BeneficiaryRegistrationStep.welcome:
        break;
      case BeneficiaryRegistrationStep.identity:
        emit(_current.copyWith(step: BeneficiaryRegistrationStep.welcome, clearError: true));
      case BeneficiaryRegistrationStep.needs:
        emit(_current.copyWith(step: BeneficiaryRegistrationStep.identity, clearError: true));
      case BeneficiaryRegistrationStep.disbursement:
        emit(_current.copyWith(step: BeneficiaryRegistrationStep.needs, clearError: true));
    }
  }

  void _onSubmit(
    BeneficiarySubmissionRequested event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    if (_current.step != BeneficiaryRegistrationStep.disbursement) return;

    if (_current.accountOrMobileNumber.trim().isEmpty ||
        _current.legalName.trim().isEmpty ||
        !_current.hasAcceptedCompliance) {
      emit(
        _current.copyWith(
          errorMessage: 'Please complete all required fields before submitting.',
          submissionSuccess: false,
        ),
      );
      return;
    }

    emit(
      _current.copyWith(
        clearError: true,
        submissionSuccess: true,
      ),
    );
  }

  bool _canMoveForward(BeneficiaryRegistrationInitial current) {
    switch (current.step) {
      case BeneficiaryRegistrationStep.welcome:
        return true;
      case BeneficiaryRegistrationStep.identity:
        return current.isIdentityStepComplete;
      case BeneficiaryRegistrationStep.needs:
        return current.selectedCategories.isNotEmpty &&
            current.situationDescription.trim().isNotEmpty;
      case BeneficiaryRegistrationStep.disbursement:
        return false;
    }
  }

}
