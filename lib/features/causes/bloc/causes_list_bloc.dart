import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_envelope.dart';
import '../data/models/cause.dart';
import '../data/repository/causes_repository.dart';
import 'causes_list_event.dart';
import 'causes_list_state.dart';

@injectable
class CausesListBloc extends Bloc<CausesListEvent, CausesListState> {
  CausesListBloc(this._repository) : super(const CausesListState()) {
    on<CausesListStarted>(
      (event, emit) => _reload(emit, state.copyWith(lang: event.lang)),
    );
    on<CausesStatusChanged>(
      (event, emit) => _reload(emit, state.copyWith(status: event.status)),
    );
    on<CausesCategoryChanged>(
      (event, emit) =>
          _reload(emit, state.copyWith(category: () => event.category)),
    );
    on<CausesNextPageRequested>(_onNextPage);
  }

  static const _pageSize = 20;

  final CausesRepository _repository;

  /// Bumped on every reload so a slow response for old filters is dropped.
  int _generation = 0;

  Future<void> _reload(
    Emitter<CausesListState> emit,
    CausesListState filters,
  ) async {
    final generation = ++_generation;
    emit(
      filters.copyWith(
        items: const [],
        page: 0,
        hasMore: false,
        loadStatus: CausesLoadStatus.loading,
        isLoadingMore: false,
        loadMoreFailed: false,
      ),
    );
    try {
      final page = await _fetch(filters, 1);
      if (generation != _generation) return;
      emit(
        state.copyWith(
          items: page.items,
          page: page.page,
          hasMore: page.hasMore,
          loadStatus: CausesLoadStatus.loaded,
        ),
      );
    } on ApiException {
      if (generation != _generation) return;
      emit(state.copyWith(loadStatus: CausesLoadStatus.failed));
    }
  }

  Future<void> _onNextPage(
    CausesNextPageRequested event,
    Emitter<CausesListState> emit,
  ) async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.loadStatus != CausesLoadStatus.loaded) {
      return;
    }
    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));
    try {
      final page = await _fetch(state, state.page + 1);
      if (generation != _generation) return;
      emit(
        state.copyWith(
          items: [...state.items, ...page.items],
          page: page.page,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } on ApiException {
      if (generation != _generation) return;
      emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }

  Future<CausesPage> _fetch(CausesListState filters, int page) {
    return _repository.fetchCauses(
      status: filters.status,
      category: filters.category,
      page: page,
      limit: _pageSize,
      lang: filters.lang,
    );
  }
}
