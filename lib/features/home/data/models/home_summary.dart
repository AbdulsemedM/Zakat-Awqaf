import 'package:equatable/equatable.dart';

import '../../../../core/network/api_envelope.dart';

/// `GET /api/zakat/v1/home/summary`. Any figure can be `null` while its
/// source has not answered; hide it rather than showing a placeholder.
class HomeSummary extends Equatable {
  const HomeSummary({
    this.totalCollectedEtb,
    this.currentMonthCollectedEtb,
    this.previousMonthCollectedEtb,
    this.changePercent,
    this.totalBeneficiariesSupported,
    this.asOf,
  });

  /// "LIVE" only while the oldest figure is fresher than this.
  static const liveWindow = Duration(hours: 1);

  final double? totalCollectedEtb;
  final double? currentMonthCollectedEtb;
  final double? previousMonthCollectedEtb;

  /// Percent change vs last month; `null` when last month was 0 (no badge).
  final double? changePercent;
  final int? totalBeneficiariesSupported;

  /// Time of the oldest figure shown.
  final DateTime? asOf;

  bool isLive(DateTime now) {
    final asOf = this.asOf;
    return asOf != null && now.difference(asOf) < liveWindow;
  }

  factory HomeSummary.fromJson(Map<String, dynamic> json) {
    final month = json['currentMonth'];
    final currentMonth = month is Map ? month : const {};
    return HomeSummary(
      totalCollectedEtb: jsonDouble(json['totalCollectedEtb']),
      currentMonthCollectedEtb: jsonDouble(currentMonth['collectedEtb']),
      previousMonthCollectedEtb: jsonDouble(
        currentMonth['previousMonthCollectedEtb'],
      ),
      changePercent: jsonDouble(currentMonth['changePercent']),
      totalBeneficiariesSupported: jsonInt(json['totalBeneficiariesSupported']),
      asOf: jsonDate(json['asOf']),
    );
  }

  @override
  List<Object?> get props => [
    totalCollectedEtb,
    currentMonthCollectedEtb,
    previousMonthCollectedEtb,
    changePercent,
    totalBeneficiariesSupported,
    asOf,
  ];
}
