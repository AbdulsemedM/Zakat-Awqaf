import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mejlis_digital_hub/core/common/utils/phone_e164.dart';

import '../data/beneficiary_registration_exception.dart';
import '../data/beneficiary_sse_client.dart';
import '../data/models/beneficiary_create_request.dart';
import '../data/national_id_generator.dart';
import '../data/repository/beneficiary_registration_repository.dart';
import 'beneficiary_registration_event.dart';
import 'beneficiary_registration_state.dart';

@injectable
class BeneficiaryRegistrationBloc extends Bloc<
    BeneficiaryRegistrationEvent,
    BeneficiaryRegistrationState
> {
  BeneficiaryRegistrationBloc(this._repository, this._sseClient)
      : super(const BeneficiaryRegistrationInitial()) {
    on<BeneficiaryRegistrationStarted>(_onStarted);
    on<RegistrationMethodSelected>(_onMethodSelected);
    on<NationalIdUpdated>(_onNationalIdUpdated);
    on<FaydaRegistrationRequested>(_onFaydaRequested);
    on<FaydaSseCompletedSuccessfully>(_onFaydaSseSuccess);
    on<FaydaSseStreamFinished>(_onFaydaSseStreamFinished);
    on<FaydaSseConnectionFailed>(_onFaydaSseConnectionFailed);
    on<FaydaSseRetryRequested>(_onFaydaSseRetry);
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
    on<RegionUpdated>(_onRegionUpdated);
    on<CityUpdated>(_onCityUpdated);
    on<NotesUpdated>(_onNotesUpdated);
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

  final BeneficiaryRegistrationRepository _repository;
  final BeneficiarySseClient _sseClient;

  StreamSubscription<BeneficiarySseVerificationEvent>? _sseSubscription;
  bool _faydaSseMatched = false;

  BeneficiaryRegistrationInitial get _current =>
      state is BeneficiaryRegistrationInitial
          ? state as BeneficiaryRegistrationInitial
          : const BeneficiaryRegistrationInitial();

  @override
  Future<void> close() {
    unawaited(_sseSubscription?.cancel());
    return super.close();
  }

  void _onStarted(
    BeneficiaryRegistrationStarted event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    unawaited(_sseSubscription?.cancel());
    _sseSubscription = null;
    emit(const BeneficiaryRegistrationInitial());
  }

  void _onMethodSelected(
    RegistrationMethodSelected event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(
      _current.copyWith(
        method: event.method,
        clearError: true,
        clearFaydaProgress: true,
        clearBeneficiaryMeta: true,
        manualIdentitySubmitted: false,
      ),
    );
  }

  void _onNationalIdUpdated(
    NationalIdUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(nationalId: event.nationalId, clearError: true));
  }

  Future<void> _onFaydaRequested(
    FaydaRegistrationRequested event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) async {
    if (_current.method != RegistrationMethod.fastTrack) {
      return;
    }
    if (_current.isFaydaPosting || _current.awaitingFaydaSse) {
      return;
    }
    if (_current.faydaVerificationComplete) {
      return;
    }

    unawaited(_sseSubscription?.cancel());
    _sseSubscription = null;
    _faydaSseMatched = false;

    final postingBase = _current;
    final generatedId =
        postingBase.generatedNationalId ?? generateFaydaNationalId();

    emit(
      postingBase.copyWith(
        isFaydaPosting: true,
        generatedNationalId: generatedId,
        clearError: true,
        clearBeneficiaryMeta: true,
      ),
    );

    try {
      final result = await _repository.register(
        NationalIdBeneficiaryCreateRequest(nationalId: generatedId),
      );
      if (result.statusCode != 202) {
        throw BeneficiaryRegistrationException(
          'Unexpected registration response (${result.statusCode}).',
        );
      }
      final link = result.dto.verificationLink?.trim();
      if (link == null || link.isEmpty) {
        throw BeneficiaryRegistrationException(
          'No verification link returned. Please try again.',
        );
      }
      final id = result.dto.id.trim();
      if (id.isEmpty) {
        throw BeneficiaryRegistrationException(
          'Missing beneficiary id in response.',
        );
      }

      final afterCreate = postingBase.copyWith(
        isFaydaPosting: false,
        awaitingFaydaSse: true,
        createdBeneficiaryId: result.dto.id,
        registeredBeneficiary: result.dto,
        verificationLink: link,
        generatedNationalId: generatedId,
        clearError: true,
      );
      emit(afterCreate);
      _startSseSubscription(id);
    } on BeneficiaryRegistrationException catch (e) {
      emit(
        postingBase.copyWith(
          isFaydaPosting: false,
          awaitingFaydaSse: false,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        postingBase.copyWith(
          isFaydaPosting: false,
          awaitingFaydaSse: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onFaydaSseRetry(
    FaydaSseRetryRequested event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    if (_current.method != RegistrationMethod.fastTrack) {
      return;
    }
    if (_current.faydaVerificationComplete) {
      return;
    }
    if (_current.isFaydaPosting || _current.awaitingFaydaSse) {
      return;
    }

    final id = _current.createdBeneficiaryId?.trim();
    final link = _current.verificationLink?.trim();
    if (id == null || id.isEmpty) {
      emit(
        _current.copyWith(
          errorMessage:
              'No beneficiary reference found. Please start verification again.',
        ),
      );
      return;
    }
    if (link == null || link.isEmpty) {
      emit(
        _current.copyWith(
          errorMessage:
              'No verification link available. Please start verification again.',
        ),
      );
      return;
    }

    unawaited(_sseSubscription?.cancel());
    _sseSubscription = null;
    _faydaSseMatched = false;

    emit(
      _current.copyWith(
        awaitingFaydaSse: true,
        clearError: true,
      ),
    );
    _startSseSubscription(id);
  }

  void _startSseSubscription(String beneficiaryId) {
    final id = beneficiaryId.trim();
    if (kDebugMode) {
      debugPrint(
        '[BeneficiarySse] Subscribing to verification stream for id=$id',
      );
    }

    _faydaSseMatched = false;
    _sseSubscription = _sseClient.watchBeneficiaryVerification(id).listen(
      (sseEvent) {
        if (kDebugMode) {
          debugPrint(
            '[BeneficiarySse] Event received: beneficiaryId=${sseEvent.beneficiaryId}, '
            'status=${sseEvent.verificationStatus}',
          );
        }
        if (sseEvent.beneficiaryId.trim() == id &&
            sseEvent.isVerificationComplete) {
          add(const FaydaSseCompletedSuccessfully());
        }
      },
      onDone: () {
        if (kDebugMode) {
          debugPrint('[BeneficiarySse] Stream closed for id=$id');
        }
        add(const FaydaSseStreamFinished());
      },
      onError: (Object e, StackTrace _) {
        if (kDebugMode) {
          debugPrint('[BeneficiarySse] Connection error for id=$id: $e');
        }
        add(FaydaSseConnectionFailed(e.toString()));
      },
      cancelOnError: false,
    );
  }

  void _onFaydaSseSuccess(
    FaydaSseCompletedSuccessfully event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    _faydaSseMatched = true;
    unawaited(_sseSubscription?.cancel());
    _sseSubscription = null;
    emit(
      _current.copyWith(
        awaitingFaydaSse: false,
        faydaVerificationComplete: true,
        isFaydaPosting: false,
        submissionSuccess: true,
        step: BeneficiaryRegistrationStep.needs,
        clearError: true,
      ),
    );
  }

  void _onFaydaSseStreamFinished(
    FaydaSseStreamFinished event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    if (_faydaSseMatched) {
      _faydaSseMatched = false;
      return;
    }
    if (!_current.awaitingFaydaSse) {
      return;
    }
    emit(
      _current.copyWith(
        awaitingFaydaSse: false,
        isFaydaPosting: false,
        errorMessage:
            'Verification is still processing. If you completed Fayda in the browser, check back later or contact support.',
      ),
    );
  }

  void _onFaydaSseConnectionFailed(
    FaydaSseConnectionFailed event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    if (_faydaSseMatched) {
      return;
    }
    if (!_current.awaitingFaydaSse) {
      return;
    }
    unawaited(_sseSubscription?.cancel());
    _sseSubscription = null;
    emit(
      _current.copyWith(
        awaitingFaydaSse: false,
        isFaydaPosting: false,
        errorMessage: event.message,
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

  void _onRegionUpdated(
    RegionUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(region: event.value, clearError: true));
  }

  void _onCityUpdated(
    CityUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(city: event.value, clearError: true));
  }

  void _onNotesUpdated(
    NotesUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(notes: event.value, clearError: true));
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

  BeneficiaryRegistrationStep? _nextStepAfter(BeneficiaryRegistrationInitial c) {
    if (c.method == RegistrationMethod.fastTrack) {
      return switch (c.step) {
        BeneficiaryRegistrationStep.welcome => BeneficiaryRegistrationStep.needs,
        BeneficiaryRegistrationStep.needs =>
          BeneficiaryRegistrationStep.disbursement,
        BeneficiaryRegistrationStep.disbursement => null,
        BeneficiaryRegistrationStep.identity => null,
      };
    }
    return switch (c.step) {
      BeneficiaryRegistrationStep.welcome => BeneficiaryRegistrationStep.identity,
      BeneficiaryRegistrationStep.identity => BeneficiaryRegistrationStep.needs,
      BeneficiaryRegistrationStep.needs =>
        BeneficiaryRegistrationStep.disbursement,
      BeneficiaryRegistrationStep.disbursement => null,
    };
  }

  BeneficiaryRegistrationStep? _prevStepAfter(BeneficiaryRegistrationInitial c) {
    if (c.method == RegistrationMethod.fastTrack) {
      return switch (c.step) {
        BeneficiaryRegistrationStep.needs => BeneficiaryRegistrationStep.welcome,
        BeneficiaryRegistrationStep.disbursement =>
          BeneficiaryRegistrationStep.needs,
        BeneficiaryRegistrationStep.welcome => null,
        BeneficiaryRegistrationStep.identity => null,
      };
    }
    return switch (c.step) {
      BeneficiaryRegistrationStep.identity => BeneficiaryRegistrationStep.welcome,
      BeneficiaryRegistrationStep.needs => BeneficiaryRegistrationStep.identity,
      BeneficiaryRegistrationStep.disbursement =>
        BeneficiaryRegistrationStep.needs,
      BeneficiaryRegistrationStep.welcome => null,
    };
  }

  Future<void> _onAdvanceStep(
    RegistrationStepAdvanced event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) async {
    if (!_canMoveForward(_current)) {
      return;
    }

    if (_current.step == BeneficiaryRegistrationStep.welcome &&
        _current.method == RegistrationMethod.fastTrack) {
      if (_current.faydaVerificationComplete) {
        final next = _nextStepAfter(_current);
        if (next != null) {
          emit(_current.copyWith(step: next, clearError: true));
        }
        return;
      }
      add(const FaydaRegistrationRequested());
      return;
    }

    if (_current.step == BeneficiaryRegistrationStep.identity &&
        _current.method == RegistrationMethod.manual &&
        !_current.manualIdentitySubmitted) {
      add(const BeneficiarySubmissionRequested());
      return;
    }

    final next = _nextStepAfter(_current);
    if (next == null) {
      return;
    }
    emit(_current.copyWith(step: next, clearError: true));
  }

  void _onBackStep(
    RegistrationStepWentBack event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    final prev = _prevStepAfter(_current);
    if (prev == null) {
      return;
    }
    emit(_current.copyWith(step: prev, clearError: true));
  }

  Future<void> _onSubmit(
    BeneficiarySubmissionRequested event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) async {
    if (_current.step != BeneficiaryRegistrationStep.identity) {
      return;
    }
    if (_current.method != RegistrationMethod.manual) {
      return;
    }
    if (_current.manualIdentitySubmitted) {
      final next = _nextStepAfter(_current);
      if (next != null) {
        emit(_current.copyWith(step: next, clearError: true));
      }
      return;
    }

    final validation = _validateManualIdentity(_current);
    if (validation != null) {
      emit(
        _current.copyWith(
          errorMessage: validation,
          submissionSuccess: false,
        ),
      );
      return;
    }

    emit(
      _current.copyWith(
        isSubmitting: true,
        clearError: true,
        clearBeneficiaryMeta: true,
      ),
    );

    final request = _buildFullCreateRequest(_current);

    try {
      final result = await _repository.register(request);
      if (result.statusCode != 201 && result.statusCode != 200) {
        throw BeneficiaryRegistrationException(
          'Unexpected status: ${result.statusCode}',
        );
      }
      emit(
        _current.copyWith(
          isSubmitting: false,
          manualIdentitySubmitted: true,
          submissionSuccess: true,
          createdBeneficiaryId: result.dto.id,
          registeredBeneficiary: result.dto,
          step: BeneficiaryRegistrationStep.needs,
          clearError: true,
        ),
      );
    } on BeneficiaryRegistrationException catch (e) {
      emit(
        _current.copyWith(
          isSubmitting: false,
          submissionSuccess: false,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        _current.copyWith(
          isSubmitting: false,
          submissionSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  String? _validateManualIdentity(BeneficiaryRegistrationInitial s) {
    if (!s.isIdentityStepComplete) {
      return 'Please complete all required identity fields.';
    }
    if (PhoneE164.normalize(s.phoneNumber) == null) {
      return 'Enter a valid phone number (e.g. +251911223344 or 0911223344).';
    }
    return null;
  }

  FullBeneficiaryCreateRequest _buildFullCreateRequest(BeneficiaryRegistrationInitial s) {
    final fullName = _manualFullName(s);
    final genderStr = switch (s.gender!) {
      Gender.male => 'male',
      Gender.female => 'female',
    };
    final dob = s.birthdate!;
    final dateOfBirth =
        '${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';

    return FullBeneficiaryCreateRequest(
      fullName: fullName,
      phone: PhoneE164.normalize(s.phoneNumber)!,
      email: s.email.trim(),
      dateOfBirth: dateOfBirth,
      gender: genderStr,
      region: s.region.trim(),
      city: s.city.trim(),
      addressLine: s.address.trim(),
      beneficiaryType: 'individual',
      notes: s.notes.trim(),
    );
  }

  String _manualFullName(BeneficiaryRegistrationInitial s) {
    return [s.firstName, s.fatherName, s.grandFatherName]
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join(' ');
  }

  bool _canMoveForward(BeneficiaryRegistrationInitial current) {
    switch (current.step) {
      case BeneficiaryRegistrationStep.welcome:
        if (current.method == RegistrationMethod.fastTrack) {
          return !current.isFaydaPosting && !current.awaitingFaydaSse;
        }
        return true;
      case BeneficiaryRegistrationStep.identity:
        return current.method == RegistrationMethod.manual &&
            current.isIdentityStepComplete &&
            !current.isSubmitting;
      case BeneficiaryRegistrationStep.needs:
        return current.selectedCategories.isNotEmpty &&
            current.situationDescription.trim().isNotEmpty;
      case BeneficiaryRegistrationStep.disbursement:
        return current.hasAcceptedCompliance &&
            current.accountOrMobileNumber.trim().isNotEmpty &&
            current.legalName.trim().isNotEmpty;
    }
  }
}
