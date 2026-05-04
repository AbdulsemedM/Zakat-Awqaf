import 'package:equatable/equatable.dart';

sealed class AwqafState extends Equatable {
  const AwqafState();

  @override
  List<Object?> get props => [];
}

final class AwqafInitial extends AwqafState {
  const AwqafInitial();
}

final class AwqafLoading extends AwqafState {
  const AwqafLoading();
}

final class AwqafLoaded extends AwqafState {
  const AwqafLoaded(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AwqafError extends AwqafState {
  const AwqafError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
