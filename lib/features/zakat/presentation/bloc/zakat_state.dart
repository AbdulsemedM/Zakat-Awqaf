import 'package:equatable/equatable.dart';

import '../../domain/entities/zakat_summary.dart';

sealed class ZakatState extends Equatable {
  const ZakatState();

  @override
  List<Object?> get props => [];
}

final class ZakatInitial extends ZakatState {
  const ZakatInitial();
}

final class ZakatLoading extends ZakatState {
  const ZakatLoading();
}

final class ZakatLoaded extends ZakatState {
  const ZakatLoaded(this.summary);

  final ZakatSummary summary;

  @override
  List<Object?> get props => [summary];
}

final class ZakatError extends ZakatState {
  const ZakatError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
