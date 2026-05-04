import 'package:freezed_annotation/freezed_annotation.dart';

part 'zakat_summary.freezed.dart';

@freezed
class ZakatSummary with _$ZakatSummary {
  const factory ZakatSummary({
    required String id,
    required double amount,
    required String currency,
  }) = _ZakatSummary;
}
