import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'awqaf_event.dart';
import 'awqaf_state.dart';

@injectable
class AwqafBloc extends Bloc<AwqafEvent, AwqafState> {
  AwqafBloc() : super(const AwqafInitial()) {
    on<AwqafStarted>(_onStarted);
  }

  Future<void> _onStarted(
    AwqafStarted event,
    Emitter<AwqafState> emit,
  ) async {
    emit(const AwqafLoading());
    await Future<void>.delayed(Duration.zero);
    emit(const AwqafLoaded('Awqaf modules ready'));
  }
}
