import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/models/profile_model.dart';
import '../data/repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repository) : super(const ProfileInitial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileNisabAlertsToggled>(_onNisabAlertsToggled);
    on<ProfileBiometricToggled>(_onBiometricToggled);
    on<ProfileMadhhabSelected>(_onMadhhabSelected);
    on<ProfileLanguageSelected>(_onLanguageSelected);
    on<ProfileThemeSelected>(_onThemeSelected);
    on<ProfileLoggedOut>(_onLoggedOut);
  }

  final ProfileRepository _repository;

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await _repository.loadProfile();
      emit(ProfileLoaded(profile));
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
  }

  Future<void> _onNisabAlertsToggled(
    ProfileNisabAlertsToggled event,
    Emitter<ProfileState> emit,
  ) async {
    await _mutate(emit, (p) => p.copyWith(nisabAlerts: event.enabled));
  }

  Future<void> _onBiometricToggled(
    ProfileBiometricToggled event,
    Emitter<ProfileState> emit,
  ) async {
    await _mutate(emit, (p) => p.copyWith(biometricEnabled: event.enabled));
  }

  Future<void> _onMadhhabSelected(
    ProfileMadhhabSelected event,
    Emitter<ProfileState> emit,
  ) async {
    await _mutate(emit, (p) => p.copyWith(madhhab: event.madhhab));
  }

  Future<void> _onLanguageSelected(
    ProfileLanguageSelected event,
    Emitter<ProfileState> emit,
  ) async {
    await _mutate(emit, (p) => p.copyWith(language: event.language));
  }

  Future<void> _onThemeSelected(
    ProfileThemeSelected event,
    Emitter<ProfileState> emit,
  ) async {
    await _mutate(
      emit,
      (p) => p.copyWith(themePreference: event.themePreference),
    );
  }

  Future<void> _onLoggedOut(
    ProfileLoggedOut event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileInitial());
  }

  Future<void> _mutate(
    Emitter<ProfileState> emit,
    ProfileModel Function(ProfileModel current) update,
  ) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    final next = update(current.profile);
    emit(ProfileLoaded(next));
    try {
      await _repository.updateProfile(next);
    } catch (_) {
      emit(ProfileLoaded(current.profile));
    }
  }
}
