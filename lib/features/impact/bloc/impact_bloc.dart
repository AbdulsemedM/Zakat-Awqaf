import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_envelope.dart';
import '../data/repository/impact_repository.dart';
import 'impact_event.dart';
import 'impact_state.dart';

@injectable
class ImpactBloc extends Bloc<ImpactEvent, ImpactState> {
  ImpactBloc(this._repository) : super(const ImpactState()) {
    on<ImpactStarted>(
      (event, emit) => _load(emit, state.copyWith(lang: event.lang)),
    );
    on<ImpactRefreshRequested>((event, emit) async {
      await _load(emit, state);
      event.done?.complete();
    });
    on<ImpactRegionSelected>(_onRegionSelected);
  }

  final ImpactRepository _repository;

  Future<void> _load(Emitter<ImpactState> emit, ImpactState base) async {
    final lang = base.lang;
    emit(
      base.copyWith(
        status: base.summary == null ? ImpactLoadStatus.loading : null,
      ),
    );
    await Future.wait([
      () async {
        try {
          final summary = await _repository.fetchSummary(
            regionCode: state.selectedRegionCode,
            lang: lang,
          );
          emit(
            state.copyWith(summary: summary, status: ImpactLoadStatus.loaded),
          );
        } on ApiException catch (e) {
          if (state.summary == null) {
            final notDeployed = e.statusCode == 401 || e.statusCode == 404;
            emit(
              state.copyWith(
                status: notDeployed
                    ? ImpactLoadStatus.unavailable
                    : ImpactLoadStatus.failed,
              ),
            );
          }
        }
      }(),
      () async {
        try {
          // Await first: `state` must be read after the response arrives.
          final regions = await _repository.fetchRegions(lang: lang);
          emit(state.copyWith(regions: regions));
        } on ApiException {
          // Keep the last regions; the map hides when there are none.
        }
      }(),
      () async {
        try {
          final stories = await _repository.fetchStories(lang: lang);
          emit(state.copyWith(stories: stories));
        } on ApiException {
          // Keep the last stories; the row hides when there are none.
        }
      }(),
    ]);
  }

  Future<void> _onRegionSelected(
    ImpactRegionSelected event,
    Emitter<ImpactState> emit,
  ) async {
    final previous = state.selectedRegionCode;
    final code = event.regionCode;
    if (code == previous) return;
    emit(state.copyWith(selectedRegionCode: () => code, isRegionLoading: true));
    try {
      final summary = await _repository.fetchSummary(
        regionCode: code,
        lang: state.lang,
      );
      // Ignore a response for a region the user has since moved away from.
      if (state.selectedRegionCode != code) return;
      emit(state.copyWith(summary: summary, isRegionLoading: false));
    } on ApiException {
      if (state.selectedRegionCode != code) return;
      emit(
        state.copyWith(
          selectedRegionCode: () => previous,
          isRegionLoading: false,
        ),
      );
    }
  }
}
