import 'package:equatable/equatable.dart';

import '../../../../core/network/api_envelope.dart';

enum FitrSeasonStatus { upcoming, open, closed }

/// `GET /api/zakat/v1/zakat-al-fitr/current`: the open season, else the next
/// upcoming one, else the most recent closed one.
class ZakatAlFitrSeason extends Equatable {
  const ZakatAlFitrSeason({
    required this.hijriYear,
    required this.status,
    required this.startsOn,
    required this.dueBy,
    required this.perPersonAmountEtb,
    this.basis,
  });

  /// Season dates are Addis Ababa calendar dates.
  static const _addisOffset = Duration(hours: 3);

  final int? hijriYear;
  final FitrSeasonStatus status;
  final DateTime startsOn;
  final DateTime dueBy;
  final double perPersonAmountEtb;
  final String? basis;

  /// Today's date in Addis Ababa.
  static DateTime addisToday(DateTime now) {
    final addis = now.toUtc().add(_addisOffset);
    return DateTime.utc(addis.year, addis.month, addis.day);
  }

  /// Whole days from today (Addis Ababa) until [startsOn] while upcoming, or
  /// until [dueBy] while open. Never negative.
  int daysRemaining(DateTime now) {
    final target = status == FitrSeasonStatus.upcoming ? startsOn : dueBy;
    final days = DateTime.utc(
      target.year,
      target.month,
      target.day,
    ).difference(addisToday(now)).inDays;
    return days < 0 ? 0 : days;
  }

  factory ZakatAlFitrSeason.fromJson(Map<String, dynamic> json) {
    final startsOn = jsonDate(json['startsOn']);
    final dueBy = jsonDate(json['dueBy']);
    final amount = jsonDouble(json['perPersonAmountEtb']);
    if (startsOn == null || dueBy == null || amount == null) {
      throw const FormatException('Incomplete Zakat al-Fitr season');
    }
    return ZakatAlFitrSeason(
      hijriYear: jsonInt(json['hijriYear']),
      status: switch (json['status']) {
        'open' => FitrSeasonStatus.open,
        'closed' => FitrSeasonStatus.closed,
        _ => FitrSeasonStatus.upcoming,
      },
      startsOn: startsOn,
      dueBy: dueBy,
      perPersonAmountEtb: amount,
      basis: jsonString(json['basis']),
    );
  }

  @override
  List<Object?> get props => [
    hijriYear,
    status,
    startsOn,
    dueBy,
    perPersonAmountEtb,
    basis,
  ];
}
