import 'package:equatable/equatable.dart';

sealed class AwqafEvent extends Equatable {
  const AwqafEvent();

  @override
  List<Object?> get props => [];
}

final class AwqafStarted extends AwqafEvent {
  const AwqafStarted();
}
