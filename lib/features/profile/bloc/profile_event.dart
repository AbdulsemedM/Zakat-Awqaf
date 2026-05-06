import 'package:equatable/equatable.dart';

import '../data/models/profile_model.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

final class ProfileNisabAlertsToggled extends ProfileEvent {
  const ProfileNisabAlertsToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class ProfileBiometricToggled extends ProfileEvent {
  const ProfileBiometricToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class ProfileMadhhabSelected extends ProfileEvent {
  const ProfileMadhhabSelected(this.madhhab);

  final Madhhab madhhab;

  @override
  List<Object?> get props => [madhhab];
}

final class ProfileLanguageSelected extends ProfileEvent {
  const ProfileLanguageSelected(this.language);

  final AppLanguage language;

  @override
  List<Object?> get props => [language];
}

final class ProfileThemeSelected extends ProfileEvent {
  const ProfileThemeSelected(this.themePreference);

  final AppThemePreference themePreference;

  @override
  List<Object?> get props => [themePreference];
}

final class ProfileLoggedOut extends ProfileEvent {
  const ProfileLoggedOut();
}
