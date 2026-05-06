import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/repository/impact_repository.dart';
import 'impact_event.dart';
import 'impact_state.dart';

@injectable
class ImpactBloc extends Bloc<ImpactEvent, ImpactState> {
  ImpactBloc(this._repository) : super(const ImpactInitial()) {
    on<ImpactStarted>(_onLoad);
    on<ImpactRefreshRequested>(_onLoad);
  }

  final ImpactRepository _repository;

  Future<void> _onLoad(
    ImpactEvent event,
    Emitter<ImpactState> emit,
  ) async {
    emit(const ImpactLoading());
    try {
      final model = await _repository.loadImpact();
      emit(ImpactLoaded(model));
    } catch (error) {
      emit(ImpactError(error.toString()));
    }
  }
}
