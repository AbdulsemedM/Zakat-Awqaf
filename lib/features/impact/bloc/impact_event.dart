import 'dart:async';

import 'package:equatable/equatable.dart';

sealed class ImpactEvent extends Equatable {
  const ImpactEvent();

  @override
  List<Object?> get props => [];
}

/// First load or a language change.
final class ImpactStarted extends ImpactEvent {
  const ImpactStarted(this.lang);

  final String lang;

  @override
  List<Object?> get props => [lang];
}

final class ImpactRefreshRequested extends ImpactEvent {
  const ImpactRefreshRequested({this.done});

  /// Completed once everything has loaded or failed (pull-to-refresh).
  final Completer<void>? done;
}

/// Shows one region's figures; `null` goes back to national.
final class ImpactRegionSelected extends ImpactEvent {
  const ImpactRegionSelected(this.regionCode);

  final String? regionCode;

  @override
  List<Object?> get props => [regionCode];
}
