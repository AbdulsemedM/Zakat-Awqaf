import 'package:equatable/equatable.dart';

sealed class ImpactEvent extends Equatable {
  const ImpactEvent();

  @override
  List<Object?> get props => [];
}

final class ImpactStarted extends ImpactEvent {
  const ImpactStarted();
}

final class ImpactRefreshRequested extends ImpactEvent {
  const ImpactRefreshRequested();
}
