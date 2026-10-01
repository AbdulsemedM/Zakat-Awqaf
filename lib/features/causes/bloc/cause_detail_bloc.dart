import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_envelope.dart';
import '../data/models/cause.dart';
import '../data/repository/causes_repository.dart';

final class CauseDetailRequested extends Equatable {
  const CauseDetailRequested({required this.id, required this.lang});

  final String id;
  final String lang;

  @override
  List<Object?> get props => [id, lang];
}

sealed class CauseDetailState extends Equatable {
  const CauseDetailState();

  @override
  List<Object?> get props => [];
}

final class CauseDetailLoading extends CauseDetailState {
  const CauseDetailLoading();
}

final class CauseDetailLoaded extends CauseDetailState {
  const CauseDetailLoaded(this.detail);

  final CauseDetail detail;

  @override
  List<Object?> get props => [detail];
}

/// Unpublished or unknown cause (404).
final class CauseDetailNotFound extends CauseDetailState {
  const CauseDetailNotFound();
}

final class CauseDetailFailed extends CauseDetailState {
  const CauseDetailFailed();
}

@injectable
class CauseDetailBloc extends Bloc<CauseDetailRequested, CauseDetailState> {
  CauseDetailBloc(this._repository) : super(const CauseDetailLoading()) {
    on<CauseDetailRequested>(_onRequested);
  }

  final CausesRepository _repository;

  Future<void> _onRequested(
    CauseDetailRequested event,
    Emitter<CauseDetailState> emit,
  ) async {
    if (state is! CauseDetailLoaded) emit(const CauseDetailLoading());
    try {
      emit(
        CauseDetailLoaded(
          await _repository.fetchCause(event.id, lang: event.lang),
        ),
      );
    } on ApiException catch (e) {
      emit(
        e.isNotFound ? const CauseDetailNotFound() : const CauseDetailFailed(),
      );
    }
  }
}
