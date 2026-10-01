import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_envelope.dart';
import '../data/models/impact_model.dart';
import '../data/repository/impact_repository.dart';

final class ImpactStoryRequested extends Equatable {
  const ImpactStoryRequested({required this.id, required this.lang});

  final String id;
  final String lang;

  @override
  List<Object?> get props => [id, lang];
}

sealed class ImpactStoryState extends Equatable {
  const ImpactStoryState();

  @override
  List<Object?> get props => [];
}

final class ImpactStoryLoading extends ImpactStoryState {
  const ImpactStoryLoading();
}

final class ImpactStoryLoaded extends ImpactStoryState {
  const ImpactStoryLoaded(this.story);

  final ImpactStory story;

  @override
  List<Object?> get props => [story];
}

final class ImpactStoryNotFound extends ImpactStoryState {
  const ImpactStoryNotFound();
}

final class ImpactStoryFailed extends ImpactStoryState {
  const ImpactStoryFailed();
}

@injectable
class ImpactStoryBloc extends Bloc<ImpactStoryRequested, ImpactStoryState> {
  ImpactStoryBloc(this._repository) : super(const ImpactStoryLoading()) {
    on<ImpactStoryRequested>(_onRequested);
  }

  final ImpactRepository _repository;

  Future<void> _onRequested(
    ImpactStoryRequested event,
    Emitter<ImpactStoryState> emit,
  ) async {
    if (state is! ImpactStoryLoaded) emit(const ImpactStoryLoading());
    try {
      emit(
        ImpactStoryLoaded(
          await _repository.fetchStory(event.id, lang: event.lang),
        ),
      );
    } on ApiException catch (e) {
      emit(
        e.isNotFound ? const ImpactStoryNotFound() : const ImpactStoryFailed(),
      );
    }
  }
}
