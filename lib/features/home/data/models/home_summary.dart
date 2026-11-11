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
    this.liveCollectedEtb,
    this.offlineCollectedEtb,
    this.liveBeneficiariesSupported,
    this.offlineBeneficiariesSupported,
    this.offlineAsOfDate,
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

  /// [totalCollectedEtb] split into what was paid in the app and what was
  /// recorded outside it (entered by staff, as of [offlineAsOfDate]).
  final double? liveCollectedEtb;
  final double? offlineCollectedEtb;
  final int? liveBeneficiariesSupported;
  final int? offlineBeneficiariesSupported;
  final DateTime? offlineAsOfDate;

  /// Whether part of the total was recorded outside the app.
  bool get hasOfflineCollected =>
      totalCollectedEtb != null && (offlineCollectedEtb ?? 0) > 0;

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
      liveCollectedEtb: jsonDouble(json['liveCollectedEtb']),
      offlineCollectedEtb: jsonDouble(json['offlineCollectedEtb']),
      liveBeneficiariesSupported: jsonInt(json['liveBeneficiariesSupported']),
      offlineBeneficiariesSupported: jsonInt(
        json['offlineBeneficiariesSupported'],
      ),
      offlineAsOfDate: jsonDate(json['offlineAsOfDate']),
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
    liveCollectedEtb,
    offlineCollectedEtb,
    liveBeneficiariesSupported,
    offlineBeneficiariesSupported,
    offlineAsOfDate,
  ];
}
