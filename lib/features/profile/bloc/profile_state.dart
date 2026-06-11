import 'package:equatable/equatable.dart';

import '../data/models/profile_model.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(
    this.profile, {
    this.feedbackMessage,
    this.feedbackIsError = false,
  });

  final ProfileModel profile;
  final String? feedbackMessage;
  final bool feedbackIsError;

  @override
  List<Object?> get props => [profile, feedbackMessage, feedbackIsError];
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
