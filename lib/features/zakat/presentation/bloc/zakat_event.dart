import 'package:equatable/equatable.dart';

sealed class ZakatEvent extends Equatable {
  const ZakatEvent();

  @override
  List<Object?> get props => [];
}

final class ZakatStarted extends ZakatEvent {
  const ZakatStarted();
}
