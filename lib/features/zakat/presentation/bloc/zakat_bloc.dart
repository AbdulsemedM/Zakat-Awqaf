import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/zakat_repository.dart';
import 'zakat_event.dart';
import 'zakat_state.dart';

@injectable
class ZakatBloc extends Bloc<ZakatEvent, ZakatState> {
  ZakatBloc(this._repository) : super(const ZakatInitial()) {
    on<ZakatStarted>(_onStarted);
  }

  final ZakatRepository _repository;

  Future<void> _onStarted(
    ZakatStarted event,
    Emitter<ZakatState> emit,
  ) async {
    emit(const ZakatLoading());
    final result = await _repository.getSummary();
    result.fold(
      (f) => emit(ZakatError(f.message ?? 'Unknown error')),
      (s) => emit(ZakatLoaded(s)),
    );
  }
}
