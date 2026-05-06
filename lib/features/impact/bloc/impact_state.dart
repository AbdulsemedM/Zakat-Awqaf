import 'package:equatable/equatable.dart';

import '../data/models/impact_model.dart';

sealed class ImpactState extends Equatable {
  const ImpactState();

  @override
  List<Object?> get props => [];
}

final class ImpactInitial extends ImpactState {
  const ImpactInitial();
}

final class ImpactLoading extends ImpactState {
  const ImpactLoading();
}

final class ImpactLoaded extends ImpactState {
  const ImpactLoaded(this.model);

  final ImpactModel model;

  @override
  List<Object?> get props => [model];
}

final class ImpactError extends ImpactState {
  const ImpactError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
