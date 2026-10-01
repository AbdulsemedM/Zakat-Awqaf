import 'package:equatable/equatable.dart';

import '../data/models/cause.dart';

sealed class CausesListEvent extends Equatable {
  const CausesListEvent();

  @override
  List<Object?> get props => [];
}

/// First load, a language change, or pull-to-refresh: reloads page 1.
final class CausesListStarted extends CausesListEvent {
  const CausesListStarted(this.lang);

  final String lang;

  @override
  List<Object?> get props => [lang];
}

final class CausesStatusChanged extends CausesListEvent {
  const CausesStatusChanged(this.status);

  final CauseStatus status;

  @override
  List<Object?> get props => [status];
}

/// `null` shows every category.
final class CausesCategoryChanged extends CausesListEvent {
  const CausesCategoryChanged(this.category);

  final CauseCategory? category;

  @override
  List<Object?> get props => [category];
}

final class CausesNextPageRequested extends CausesListEvent {
  const CausesNextPageRequested();
}
