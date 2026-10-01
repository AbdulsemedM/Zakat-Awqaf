import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_envelope.dart';
import '../../causes/data/models/cause.dart';
import '../../causes/data/repository/causes_repository.dart';
import '../data/models/home_summary.dart';
import '../data/models/zakat_al_fitr_season.dart';
import '../data/repository/home_repository.dart';

/// Loads (or reloads, e.g. pull-to-refresh or a language change) every
/// live home widget.
final class HomeLoadRequested extends Equatable {
  const HomeLoadRequested(this.lang, {this.done});

  final String lang;

  /// Completed once every part has loaded or failed (pull-to-refresh).
  final Completer<void>? done;

  @override
  List<Object?> get props => [lang];
}

/// Each part loads on its own: a part that fails keeps its last value, and a
/// part that has never loaded stays `null` / empty so its widget is hidden.
class HomeState extends Equatable {
  const HomeState({
    this.summary,
    this.urgentCauses = const [],
    this.fitrSeason,
  });

  final HomeSummary? summary;
  final List<Cause> urgentCauses;
  final ZakatAlFitrSeason? fitrSeason;

  @override
  List<Object?> get props => [summary, urgentCauses, fitrSeason];
}

@injectable
class HomeBloc extends Bloc<HomeLoadRequested, HomeState> {
  HomeBloc(this._homeRepository, this._causesRepository)
    : super(const HomeState()) {
    on<HomeLoadRequested>(_onLoad);
  }

  static const _urgentCausesLimit = 10;

  final HomeRepository _homeRepository;
  final CausesRepository _causesRepository;

  Future<void> _onLoad(HomeLoadRequested event, Emitter<HomeState> emit) async {
    final lang = event.lang;
    await Future.wait([
      _guard(() async {
        final summary = await _homeRepository.fetchSummary(lang: lang);
        emit(_copy(summary: summary));
      }),
      _guard(() async {
        final page = await _causesRepository.fetchCauses(
          urgentOnly: true,
          limit: _urgentCausesLimit,
          lang: lang,
        );
        emit(_copy(urgentCauses: page.items));
      }),
      _guard(() async {
        final season = await _homeRepository.fetchCurrentFitrSeason(lang: lang);
        // No season set up: hide the widget.
        emit(_copy(fitrSeason: () => season));
      }),
    ]);
    event.done?.complete();
  }

  HomeState _copy({
    HomeSummary? summary,
    List<Cause>? urgentCauses,
    ZakatAlFitrSeason? Function()? fitrSeason,
  }) {
    return HomeState(
      summary: summary ?? state.summary,
      urgentCauses: urgentCauses ?? state.urgentCauses,
      fitrSeason: fitrSeason != null ? fitrSeason() : state.fitrSeason,
    );
  }

  static Future<void> _guard(Future<void> Function() load) async {
    try {
      await load();
    } on ApiException {
      // Keep the last value; the widget hides itself if there is none.
    }
  }
}
