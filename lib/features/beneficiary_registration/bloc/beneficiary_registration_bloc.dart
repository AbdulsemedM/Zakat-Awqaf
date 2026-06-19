import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mejlis_digital_hub/core/common/utils/phone_e164.dart';
import 'package:mejlis_digital_hub/features/auth/data/auth_exception.dart';
import 'package:mejlis_digital_hub/features/auth/data/models/login_request.dart';
import 'package:mejlis_digital_hub/features/auth/data/models/set_password_request.dart';
import 'package:mejlis_digital_hub/features/auth/data/repository/auth_repository.dart';

import '../data/beneficiary_registration_exception.dart';
import '../data/beneficiary_sse_client.dart';
import '../data/models/asnaf_category.dart';
import '../data/models/beneficiary_create_request.dart';
import '../data/models/company_beneficiary_create_request.dart';
import '../data/national_id_generator.dart';
import '../data/repository/beneficiary_registration_repository.dart';
import 'beneficiary_registration_event.dart';
import 'beneficiary_registration_state.dart';

@injectable
class BeneficiaryRegistrationBloc extends Bloc<
    BeneficiaryRegistrationEvent,
    BeneficiaryRegistrationState
> {
  BeneficiaryRegistrationBloc(
    this._repository,
    this._sseClient,
    this._authRepository,
  ) : super(const BeneficiaryRegistrationInitial()) {
    on<BeneficiaryRegistrationStarted>(_onStarted);
    on<RegistrationMethodSelected>(_onMethodSelected);
    on<NationalIdUpdated>(_onNationalIdUpdated);
    on<FaydaRegistrationRequested>(_onFaydaRequested);
    on<FaydaSseCompletedSuccessfully>(_onFaydaSseSuccess);
    on<FaydaSseStreamFinished>(_onFaydaSseStreamFinished);
    on<FaydaSseConnectionFailed>(_onFaydaSseConnectionFailed);
    on<FaydaSseRetryRequested>(_onFaydaSseRetry);
    on<FaydaVerificationTimedOut>(_onFaydaVerificationTimedOut);
    on<FaydaSseReconnectRequested>(_onFaydaSseReconnectRequested);
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
    on<AsnafCategorySelected>(_onAsnafCategorySelected);
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
    on<TradingNameUpdated>(_onTradingNameUpdated);
    on<TradeRegistrationNumberUpdated>(_onTradeRegistrationNumberUpdated);
    on<TaxIdentificationNumberUpdated>(_onTaxIdentificationNumberUpdated);
    on<VatRegistrationNumberUpdated>(_onVatRegistrationNumberUpdated);
    on<InstitutionSubtypeUpdated>(_onInstitutionSubtypeUpdated);
    on<AuthorityToActRequiredToggled>(_onAuthorityToActRequiredToggled);
    on<InstitutionRegistrationRequested>(_onInstitutionRegistrationRequested);
    on<InstitutionDocumentPicked>(_onInstitutionDocumentPicked);
    on<InstitutionDocumentUploadRequested>(_onInstitutionDocumentUploadRequested);
    on<InstitutionRegistrationFinished>(_onInstitutionRegistrationFinished);
    on<DisbursementRegistrationFinished>(_onDisbursementRegistrationFinished);
    on<PasswordUpdated>(_onPasswordUpdated);
    on<ConfirmPasswordUpdated>(_onConfirmPasswordUpdated);
    on<SetPasswordRequested>(_onSetPasswordRequested);
  }

  final BeneficiaryRegistrationRepository _repository;
  final BeneficiarySseClient _sseClient;
  final AuthRepository _authRepository;

  static final _passwordUppercase = RegExp(r'[A-Z]');
  static final _passwordLowercase = RegExp(r'[a-z]');
  static final _passwordDigit = RegExp(r'\d');
  static final _passwordSpecial = RegExp(r'[^A-Za-z0-9]');

  StreamSubscription<BeneficiarySseVerificationEvent>? _sseSubscription;
  Timer? _faydaSseReconnectTimer;
  Timer? _faydaSseTimeoutTimer;
  bool _faydaSseMatched = false;
  int _faydaSseReconnectAttempts = 0;

  static const _faydaSseReconnectDelay = Duration(seconds: 3);
  static const _faydaSseWatchTimeout = Duration(minutes: 10);
  static const _maxFaydaSseReconnectAttempts = 5;

  BeneficiaryRegistrationInitial get _current =>
      state is BeneficiaryRegistrationInitial
          ? state as BeneficiaryRegistrationInitial
          : const BeneficiaryRegistrationInitial();

  @override
  Future<void> close() {
    _stopFaydaVerificationWatchers();
    return super.close();
  }

  void _onStarted(
    BeneficiaryRegistrationStarted event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    _stopFaydaVerificationWatchers();
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

    _stopFaydaVerificationWatchers();
    _faydaSseMatched = false;
    _faydaSseReconnectAttempts = 0;

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
      _startFaydaVerificationWatch(id);
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

    _stopFaydaVerificationWatchers();
    _faydaSseMatched = false;
    _faydaSseReconnectAttempts = 0;

    emit(
      _current.copyWith(
        awaitingFaydaSse: true,
        clearError: true,
      ),
    );
    _startFaydaVerificationWatch(id);
  }

  void _stopFaydaVerificationWatchers() {
    _faydaSseReconnectTimer?.cancel();
    _faydaSseReconnectTimer = null;
    _faydaSseTimeoutTimer?.cancel();
    _faydaSseTimeoutTimer = null;
    unawaited(_sseSubscription?.cancel());
    _sseSubscription = null;
  }

  void _startFaydaVerificationWatch(String beneficiaryId) {
    final id = beneficiaryId.trim();
    if (id.isEmpty) {
      return;
    }

    unawaited(_sseSubscription?.cancel());
    _sseSubscription = null;
    _faydaSseTimeoutTimer?.cancel();
    _faydaSseTimeoutTimer = null;

    _startSseSubscription(id);
    _startFaydaSseTimeoutWatch();
  }

  void _startFaydaSseTimeoutWatch() {
    _faydaSseTimeoutTimer?.cancel();
    _faydaSseTimeoutTimer = Timer(_faydaSseWatchTimeout, () {
      if (!isClosed) {
        add(const FaydaVerificationTimedOut());
      }
    });
  }

  void _scheduleFaydaSseReconnect() {
    if (_faydaSseMatched || isClosed) {
      return;
    }
    if (!_current.awaitingFaydaSse) {
      return;
    }
    if (_faydaSseReconnectAttempts >= _maxFaydaSseReconnectAttempts) {
      return;
    }
    if (_faydaSseReconnectTimer?.isActive == true) {
      return;
    }

    _faydaSseReconnectTimer = Timer(_faydaSseReconnectDelay, () {
      if (!isClosed) {
        add(const FaydaSseReconnectRequested());
      }
    });
  }

  void _onFaydaSseReconnectRequested(
    FaydaSseReconnectRequested event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    if (_faydaSseMatched || !_current.awaitingFaydaSse) {
      return;
    }
    final id = _current.createdBeneficiaryId?.trim();
    if (id == null || id.isEmpty) {
      return;
    }
    if (_faydaSseReconnectAttempts >= _maxFaydaSseReconnectAttempts) {
      return;
    }

    _faydaSseReconnectAttempts++;
    if (kDebugMode) {
      debugPrint(
        '[BeneficiarySse] Reconnect attempt $_faydaSseReconnectAttempts '
        'for id=$id',
      );
    }
    unawaited(_sseSubscription?.cancel());
    _sseSubscription = null;
    _startSseSubscription(id);
  }

  void _onFaydaVerificationTimedOut(
    FaydaVerificationTimedOut event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    if (_faydaSseMatched || !_current.awaitingFaydaSse) {
      return;
    }
    _stopFaydaVerificationWatchers();
    emit(
      _current.copyWith(
        awaitingFaydaSse: false,
        isFaydaPosting: false,
        errorMessage:
            'Fayda verification timed out. Please retry registration or contact support.',
      ),
    );
  }

  void _startSseSubscription(String beneficiaryId) {
    final id = beneficiaryId.trim();
    if (kDebugMode) {
      debugPrint(
        '[BeneficiarySse] Subscribing to verification stream for id=$id',
      );
    }

    _sseSubscription = _sseClient
        .watchBeneficiaryVerification(id)
        .handleError((Object e, StackTrace _) {
          if (kDebugMode) {
            debugPrint('[BeneficiarySse] Connection error for id=$id: $e');
          }
          add(FaydaSseConnectionFailed(_friendlyFaydaSseError(e)));
        })
        .listen(
          (sseEvent) {
            if (kDebugMode) {
              debugPrint(
                '[BeneficiarySse] Event received: beneficiaryId=${sseEvent.beneficiaryId}, '
                'status=${sseEvent.verificationStatus}',
              );
            }
            if (sseEvent.beneficiaryId.trim() == id &&
                sseEvent.isVerificationComplete) {
              add(
                FaydaSseCompletedSuccessfully(
                  passwordSetupToken:
                      sseEvent.passwordSetupToken?.trim() ?? '',
                ),
              );
            }
          },
          onDone: () {
            if (kDebugMode) {
              debugPrint('[BeneficiarySse] Stream closed for id=$id');
            }
            add(const FaydaSseStreamFinished());
          },
        );
  }

  String _friendlyFaydaSseError(Object error) {
    if (error is DioException && error.type == DioExceptionType.receiveTimeout) {
      return 'Still waiting for Fayda verification. We will reconnect automatically.';
    }
    return 'Connection to verification updates was interrupted. '
        'We will reconnect automatically.';
  }

  void _onFaydaSseSuccess(
    FaydaSseCompletedSuccessfully event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    _faydaSseMatched = true;
    _stopFaydaVerificationWatchers();
    _faydaSseReconnectAttempts = 0;
    final token = event.passwordSetupToken.trim();
    emit(
      _current.copyWith(
        awaitingFaydaSse: false,
        faydaVerificationComplete: true,
        isFaydaPosting: false,
        step: BeneficiaryRegistrationStep.setPassword,
        passwordSetupToken: token.isNotEmpty ? token : null,
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
    if (kDebugMode) {
      debugPrint('[BeneficiarySse] Stream closed; scheduling SSE reconnect');
    }
    _scheduleFaydaSseReconnect();
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
    _scheduleFaydaSseReconnect();

    if (_faydaSseReconnectAttempts >= _maxFaydaSseReconnectAttempts) {
      emit(
        _current.copyWith(
          awaitingFaydaSse: false,
          isFaydaPosting: false,
          errorMessage:
              'Verification is still processing. If you completed Fayda in the browser, tap Retry listening or contact support.',
        ),
      );
      _stopFaydaVerificationWatchers();
      return;
    }

    emit(
      _current.copyWith(
        isFaydaPosting: false,
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

  void _onAsnafCategorySelected(
    AsnafCategorySelected event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(selectedCategory: event.category, clearError: true));
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

  void _onTradingNameUpdated(
    TradingNameUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(tradingName: event.value, clearError: true));
  }

  void _onTradeRegistrationNumberUpdated(
    TradeRegistrationNumberUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(
      _current.copyWith(
        tradeRegistrationNumber: event.value,
        clearError: true,
      ),
    );
  }

  void _onTaxIdentificationNumberUpdated(
    TaxIdentificationNumberUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(
      _current.copyWith(
        taxIdentificationNumber: event.value,
        clearError: true,
      ),
    );
  }

  void _onVatRegistrationNumberUpdated(
    VatRegistrationNumberUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(
      _current.copyWith(
        vatRegistrationNumber: event.value,
        clearError: true,
      ),
    );
  }

  void _onInstitutionSubtypeUpdated(
    InstitutionSubtypeUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(
      _current.copyWith(
        institutionSubtype: event.value,
        clearError: true,
      ),
    );
  }

  void _onAuthorityToActRequiredToggled(
    AuthorityToActRequiredToggled event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(
      _current.copyWith(
        authorityToActDocumentRequired: event.required,
        clearError: true,
      ),
    );
  }

  void _onInstitutionDocumentPicked(
    InstitutionDocumentPicked event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    final updated = Map<String, String>.from(_current.pickedDocumentPaths);
    updated[event.documentCode] = event.filePath;
    emit(
      _current.copyWith(
        pickedDocumentPaths: updated,
        clearError: true,
      ),
    );
  }

  BeneficiaryRegistrationStep? _nextStepAfter(BeneficiaryRegistrationInitial c) {
    if (c.method == RegistrationMethod.institution) {
      return switch (c.step) {
        BeneficiaryRegistrationStep.welcome =>
          BeneficiaryRegistrationStep.institutionDetails,
        BeneficiaryRegistrationStep.institutionDetails =>
          c.institutionRegistrationSubmitted
              ? (c.passwordSetupComplete
                  ? BeneficiaryRegistrationStep.institutionDocuments
                  : BeneficiaryRegistrationStep.setPassword)
              : BeneficiaryRegistrationStep.setPassword,
        BeneficiaryRegistrationStep.setPassword =>
          BeneficiaryRegistrationStep.institutionDocuments,
        BeneficiaryRegistrationStep.institutionDocuments => null,
        BeneficiaryRegistrationStep.identity => null,
        BeneficiaryRegistrationStep.needs => null,
        BeneficiaryRegistrationStep.disbursement => null,
      };
    }
    if (c.method == RegistrationMethod.fastTrack) {
      return switch (c.step) {
        BeneficiaryRegistrationStep.welcome => BeneficiaryRegistrationStep.needs,
        BeneficiaryRegistrationStep.needs =>
          BeneficiaryRegistrationStep.disbursement,
        BeneficiaryRegistrationStep.disbursement => null,
        BeneficiaryRegistrationStep.identity => null,
        BeneficiaryRegistrationStep.institutionDetails => null,
        BeneficiaryRegistrationStep.setPassword => null,
        BeneficiaryRegistrationStep.institutionDocuments => null,
      };
    }
    return switch (c.step) {
      BeneficiaryRegistrationStep.welcome => BeneficiaryRegistrationStep.identity,
      BeneficiaryRegistrationStep.identity =>
        c.manualIdentitySubmitted && !c.passwordSetupComplete
            ? BeneficiaryRegistrationStep.setPassword
            : BeneficiaryRegistrationStep.needs,
      BeneficiaryRegistrationStep.needs =>
        BeneficiaryRegistrationStep.disbursement,
      BeneficiaryRegistrationStep.disbursement => null,
      BeneficiaryRegistrationStep.institutionDetails => null,
      BeneficiaryRegistrationStep.setPassword => null,
      BeneficiaryRegistrationStep.institutionDocuments => null,
    };
  }

  BeneficiaryRegistrationStep? _prevStepAfter(BeneficiaryRegistrationInitial c) {
    if (c.method == RegistrationMethod.institution) {
      return switch (c.step) {
        BeneficiaryRegistrationStep.institutionDetails =>
          BeneficiaryRegistrationStep.welcome,
        BeneficiaryRegistrationStep.setPassword =>
          BeneficiaryRegistrationStep.institutionDetails,
        BeneficiaryRegistrationStep.institutionDocuments =>
          BeneficiaryRegistrationStep.setPassword,
        BeneficiaryRegistrationStep.welcome => null,
        BeneficiaryRegistrationStep.identity => null,
        BeneficiaryRegistrationStep.needs => null,
        BeneficiaryRegistrationStep.disbursement => null,
      };
    }
    if (c.method == RegistrationMethod.fastTrack) {
      return switch (c.step) {
        BeneficiaryRegistrationStep.setPassword =>
          BeneficiaryRegistrationStep.welcome,
        BeneficiaryRegistrationStep.needs => BeneficiaryRegistrationStep.welcome,
        BeneficiaryRegistrationStep.disbursement =>
          BeneficiaryRegistrationStep.needs,
        BeneficiaryRegistrationStep.welcome => null,
        BeneficiaryRegistrationStep.identity => null,
        BeneficiaryRegistrationStep.institutionDetails => null,
        BeneficiaryRegistrationStep.institutionDocuments => null,
      };
    }
    return switch (c.step) {
      BeneficiaryRegistrationStep.setPassword =>
        BeneficiaryRegistrationStep.identity,
      BeneficiaryRegistrationStep.identity => BeneficiaryRegistrationStep.welcome,
      BeneficiaryRegistrationStep.needs => BeneficiaryRegistrationStep.identity,
      BeneficiaryRegistrationStep.disbursement =>
        BeneficiaryRegistrationStep.needs,
      BeneficiaryRegistrationStep.welcome => null,
      BeneficiaryRegistrationStep.institutionDetails => null,
      BeneficiaryRegistrationStep.institutionDocuments => null,
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

    if (_current.step == BeneficiaryRegistrationStep.institutionDetails &&
        _current.method == RegistrationMethod.institution &&
        !_current.institutionRegistrationSubmitted) {
      add(const InstitutionRegistrationRequested());
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
          createdBeneficiaryId: result.dto.id,
          registeredBeneficiary: result.dto,
          passwordSetupToken: result.dto.passwordSetupToken,
          step: BeneficiaryRegistrationStep.setPassword,
          clearError: true,
          clearPasswordFields: true,
        ),
      );
    } on BeneficiaryRegistrationException catch (e) {
      emit(
        _current.copyWith(
          isSubmitting: false,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        _current.copyWith(
          isSubmitting: false,
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
      category: s.selectedCategory!.apiValue,
      notes: s.notes.trim(),
      profilePicturePath: s.profilePicture,
    );
  }

  String _manualFullName(BeneficiaryRegistrationInitial s) {
    return [s.firstName, s.fatherName, s.grandFatherName]
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join(' ');
  }

  Future<void> _onInstitutionRegistrationRequested(
    InstitutionRegistrationRequested event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) async {
    if (_current.step != BeneficiaryRegistrationStep.institutionDetails) {
      return;
    }
    if (_current.method != RegistrationMethod.institution) {
      return;
    }
    if (_current.institutionRegistrationSubmitted) {
      final next = _nextStepAfter(_current);
      if (next != null) {
        emit(_current.copyWith(step: next, clearError: true));
      }
      return;
    }

    final validation = _validateInstitutionDetails(_current);
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
        clearInstitutionMeta: true,
      ),
    );

    final request = _buildCompanyCreateRequest(_current);

    try {
      final result = await _repository.registerCompany(request);
      if (result.statusCode != 201) {
        throw BeneficiaryRegistrationException(
          'Unexpected status: ${result.statusCode}',
        );
      }
      final dto = result.dto;
      emit(
        _current.copyWith(
          isSubmitting: false,
          institutionRegistrationSubmitted: true,
          createdBeneficiaryId: dto.id,
          registeredBeneficiary: dto,
          passwordSetupToken: dto.passwordSetupToken,
          companyDocumentUploadToken: dto.companyDocumentUploadToken,
          kycDocuments: dto.institutionRecommendedKycDocuments,
          institutionRequiredKycComplete:
              dto.institutionRequiredKycComplete ?? false,
          step: BeneficiaryRegistrationStep.setPassword,
          clearError: true,
          clearPasswordFields: true,
        ),
      );
    } on BeneficiaryRegistrationException catch (e) {
      emit(
        _current.copyWith(
          isSubmitting: false,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        _current.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onInstitutionDocumentUploadRequested(
    InstitutionDocumentUploadRequested event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) async {
    if (_current.step != BeneficiaryRegistrationStep.institutionDocuments) {
      return;
    }

    final companyId = _current.createdBeneficiaryId?.trim();
    final uploadToken = _current.companyDocumentUploadToken?.trim();
    final filePath = _current.pickedDocumentPaths[event.documentCode]?.trim();

    if (companyId == null ||
        companyId.isEmpty ||
        uploadToken == null ||
        uploadToken.isEmpty) {
      emit(
        _current.copyWith(
          errorMessage: 'Registration session expired. Please go back and try again.',
        ),
      );
      return;
    }
    if (filePath == null || filePath.isEmpty) {
      emit(
        _current.copyWith(
          errorMessage: 'Please select a file before uploading.',
        ),
      );
      return;
    }

    emit(
      _current.copyWith(
        uploadingDocumentCode: event.documentCode,
        clearError: true,
      ),
    );

    try {
      final result = await _repository.uploadCompanyDocument(
        companyId: companyId,
        uploadToken: uploadToken,
        documentCode: event.documentCode,
        filePath: filePath,
      );
      final dto = result.dto;
      emit(
        _current.copyWith(
          uploadingDocumentCode: null,
          clearUploadingDocumentCode: true,
          registeredBeneficiary: dto,
          kycDocuments: dto.institutionRecommendedKycDocuments,
          institutionRequiredKycComplete:
              dto.institutionRequiredKycComplete ?? false,
          companyDocumentUploadToken:
              dto.companyDocumentUploadToken ?? uploadToken,
          clearError: true,
        ),
      );
    } on BeneficiaryRegistrationException catch (e) {
      emit(
        _current.copyWith(
          uploadingDocumentCode: null,
          clearUploadingDocumentCode: true,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        _current.copyWith(
          uploadingDocumentCode: null,
          clearUploadingDocumentCode: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onPasswordUpdated(
    PasswordUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(password: event.value, clearError: true));
  }

  void _onConfirmPasswordUpdated(
    ConfirmPasswordUpdated event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    emit(_current.copyWith(confirmPassword: event.value, clearError: true));
  }

  Future<void> _onSetPasswordRequested(
    SetPasswordRequested event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) async {
    if (_current.step != BeneficiaryRegistrationStep.setPassword) {
      return;
    }
    if (_current.passwordSetupComplete) {
      if (_current.method == RegistrationMethod.institution) {
        emit(
          _current.copyWith(
            step: BeneficiaryRegistrationStep.institutionDocuments,
            clearError: true,
          ),
        );
      }
      return;
    }

    final validation = _validateSetPassword(_current);
    if (validation != null) {
      emit(_current.copyWith(errorMessage: validation));
      return;
    }

    final beneficiaryId = _current.createdBeneficiaryId?.trim();
    if (beneficiaryId == null || beneficiaryId.isEmpty) {
      emit(
        _current.copyWith(
          errorMessage: 'Missing beneficiary reference. Please restart registration.',
        ),
      );
      return;
    }

    final passwordSetupToken = _current.resolvedPasswordSetupToken;
    if (passwordSetupToken == null || passwordSetupToken.isEmpty) {
      emit(
        _current.copyWith(
          errorMessage:
              'Session expired. Please restart registration to set your password.',
        ),
      );
      return;
    }

    emit(_current.copyWith(isSettingPassword: true, clearError: true));

    final password = _current.password;

    try {
      await _authRepository.setBeneficiaryPassword(
        SetPasswordRequest(
          password: password,
          confirmPassword: _current.confirmPassword,
          passwordSetupToken: passwordSetupToken,
        ),
      );

      final loginPhone = _resolveAutoLoginPhone(_current);
      if (loginPhone != null) {
        try {
          await _authRepository.login(
            LoginRequest(username: loginPhone, password: password),
          );
        } on AuthException catch (_) {
          // Password saved; home redirect still proceeds.
        } catch (_) {
          // Password saved; home redirect still proceeds.
        }
      }

      if (_current.method == RegistrationMethod.institution) {
        emit(
          _current.copyWith(
            isSettingPassword: false,
            passwordSetupComplete: true,
            submissionSuccess: true,
            step: BeneficiaryRegistrationStep.institutionDocuments,
            clearError: true,
          ),
        );
      } else {
        emit(
          _current.copyWith(
            isSettingPassword: false,
            passwordSetupComplete: true,
            submissionSuccess: true,
            clearError: true,
          ),
        );
      }
    } on AuthException catch (e) {
      emit(
        _current.copyWith(
          isSettingPassword: false,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        _current.copyWith(
          isSettingPassword: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Phone from backend/Fayda profile only — never required from user on set-password.
  String? _resolveAutoLoginPhone(BeneficiaryRegistrationInitial s) {
    return PhoneE164.normalize(s.registeredBeneficiary?.phone ?? '');
  }

  String? _validateSetPassword(BeneficiaryRegistrationInitial s) {
    final password = s.password;
    final confirm = s.confirmPassword;

    if (password.isEmpty || confirm.isEmpty) {
      return 'Please enter and confirm your password.';
    }
    if (password != confirm) {
      return 'Passwords do not match.';
    }
    if (password.length < 10) {
      return 'Password must be at least 10 characters.';
    }
    if (!_passwordUppercase.hasMatch(password)) {
      return 'Password must include an uppercase letter.';
    }
    if (!_passwordLowercase.hasMatch(password)) {
      return 'Password must include a lowercase letter.';
    }
    if (!_passwordDigit.hasMatch(password)) {
      return 'Password must include a number.';
    }
    if (!_passwordSpecial.hasMatch(password)) {
      return 'Password must include a special character.';
    }
    return null;
  }

  void _onInstitutionRegistrationFinished(
    InstitutionRegistrationFinished event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    if (!_current.institutionRequiredKycComplete) {
      emit(
        _current.copyWith(
          errorMessage: 'Please upload all required documents before finishing.',
        ),
      );
      return;
    }
    emit(
      _current.copyWith(
        submissionSuccess: true,
        clearError: true,
      ),
    );
  }

  void _onDisbursementRegistrationFinished(
    DisbursementRegistrationFinished event,
    Emitter<BeneficiaryRegistrationState> emit,
  ) {
    if (_current.step != BeneficiaryRegistrationStep.disbursement) {
      return;
    }
    emit(
      _current.copyWith(
        submissionSuccess: true,
        clearError: true,
      ),
    );
  }

  String? _validateInstitutionDetails(BeneficiaryRegistrationInitial s) {
    if (!s.isInstitutionDetailsComplete) {
      return 'Please complete all required institution fields.';
    }
    if (PhoneE164.normalize(s.phoneNumber) == null) {
      return 'Enter a valid phone number (e.g. +251911223344 or 0911223344).';
    }
    if (!s.email.trim().contains('@')) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  CompanyBeneficiaryCreateRequest _buildCompanyCreateRequest(
    BeneficiaryRegistrationInitial s,
  ) {
    return CompanyBeneficiaryCreateRequest(
      legalName: s.legalName.trim(),
      tradingName: s.tradingName.trim(),
      tradeRegistrationNumber: s.tradeRegistrationNumber.trim(),
      taxIdentificationNumber: s.taxIdentificationNumber.trim(),
      vatRegistrationNumber: s.vatRegistrationNumber.trim(),
      phone: PhoneE164.normalize(s.phoneNumber)!,
      email: s.email.trim(),
      region: s.region.trim(),
      city: s.city.trim(),
      addressLine: s.address.trim(),
      institutionSubtype: s.institutionSubtype,
      authorityToActDocumentRequired: s.authorityToActDocumentRequired,
      notes: s.notes.trim(),
    );
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
      case BeneficiaryRegistrationStep.institutionDetails:
        return current.method == RegistrationMethod.institution &&
            current.isInstitutionDetailsComplete &&
            !current.isSubmitting;
      case BeneficiaryRegistrationStep.setPassword:
        return current.isSetPasswordStepComplete && !current.isSettingPassword;
      case BeneficiaryRegistrationStep.institutionDocuments:
        return current.institutionRequiredKycComplete &&
            current.uploadingDocumentCode == null;
      case BeneficiaryRegistrationStep.needs:
        return current.situationDescription.trim().isNotEmpty;
      case BeneficiaryRegistrationStep.disbursement:
        return current.hasAcceptedCompliance &&
            current.accountOrMobileNumber.trim().isNotEmpty &&
            current.legalName.trim().isNotEmpty;
    }
  }
}
