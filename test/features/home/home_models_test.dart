import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/common/utils/money_formatter.dart';
import 'package:mejlis_digital_hub/features/causes/data/models/cause.dart';
import 'package:mejlis_digital_hub/features/home/data/models/home_summary.dart';
import 'package:mejlis_digital_hub/features/home/data/models/zakat_al_fitr_season.dart';

void main() {
  group('HomeSummary', () {
    test('parses figures and handles nulls', () {
      final summary = HomeSummary.fromJson({
        'totalCollectedEtb': 12842300.00,
        'currentMonth': {
          'collectedEtb': 1120000.00,
          'previousMonthCollectedEtb': 0,
          'changePercent': null,
        },
        'totalBeneficiariesSupported': null,
        'asOf': '2026-10-01T10:15:00+03:00',
      });
      expect(summary.totalCollectedEtb, 12842300);
      expect(summary.currentMonthCollectedEtb, 1120000);
      expect(summary.changePercent, isNull);
      expect(summary.totalBeneficiariesSupported, isNull);

      final asOf = DateTime.utc(2026, 10, 1, 7, 15);
      expect(summary.isLive(asOf.add(const Duration(minutes: 59))), isTrue);
      expect(summary.isLive(asOf.add(const Duration(minutes: 61))), isFalse);

      final empty = HomeSummary.fromJson({'currentMonth': null});
      expect(empty.currentMonthCollectedEtb, isNull);
      expect(empty.isLive(DateTime.now()), isFalse);
    });
  });

  group('ZakatAlFitrSeason', () {
    final season = ZakatAlFitrSeason.fromJson({
      'hijriYear': 1448,
      'status': 'upcoming',
      'startsOn': '2027-03-01',
      'dueBy': '2027-03-09',
      'perPersonAmountEtb': 150.00,
      'basis': "Price of one sa' of staple food, set by the commission",
    });

    test('parses the sample', () {
      expect(season.status, FitrSeasonStatus.upcoming);
      expect(season.perPersonAmountEtb, 150);
    });

    test('days remaining use the Addis Ababa date', () {
      // 22:00 UTC on Feb 27 is already Feb 28 in Addis Ababa.
      expect(season.daysRemaining(DateTime.utc(2027, 2, 27, 22)), 1);
      expect(season.daysRemaining(DateTime.utc(2027, 2, 27, 20)), 2);

      final open = ZakatAlFitrSeason.fromJson({
        'status': 'open',
        'startsOn': '2027-03-01',
        'dueBy': '2027-03-09',
        'perPersonAmountEtb': 150,
      });
      expect(open.daysRemaining(DateTime.utc(2027, 3, 9, 6)), 0);
      expect(open.daysRemaining(DateTime.utc(2027, 3, 12)), 0);
    });
  });

  group('Cause', () {
    test('parses list item with nullable fields', () {
      final cause = Cause.fromJson({
        'id': '12',
        'title': 'Education Support',
        'category': 'education',
        'badge': 'urgent',
        'imageUrl': null,
        'goalEtb': null,
        'raisedEtb': 325000.00,
        'progress': null,
        'acceptsZakat': true,
      });
      expect(cause.category, CauseCategory.education);
      expect(cause.badge, CauseBadge.urgent);
      expect(cause.goalEtb, isNull);
      expect(cause.isGeneralFund, isFalse);

      final unknown = Cause.fromJson({'id': 'general', 'category': 'other'});
      expect(unknown.category, CauseCategory.general);
      expect(unknown.isGeneralFund, isTrue);
      expect(unknown.raisedEtb, isNull);
    });

    test('page and detail', () {
      final page = CausesPage.fromJson({
        'items': [
          {
            'id': 'general',
            'title': 'General Zakat fund',
            'category': 'general',
          },
        ],
        'pagination': {
          'page': 1,
          'limit': 50,
          'totalItems': 3,
          'totalPages': 2,
        },
      });
      expect(page.items.single.isGeneralFund, isTrue);
      expect(page.hasMore, isTrue);

      final detail = CauseDetail.fromJson({
        'id': '12',
        'title': 'Education Support',
        'body': 'Long text',
        'images': ['https://example.com/a.png'],
      });
      expect(detail.body, 'Long text');
      expect(detail.images, hasLength(1));
    });
  });

  test('compact ETB', () {
    expect(MoneyFormatter.etbCompact(1120000), 'ETB 1.12M');
    expect(MoneyFormatter.etbCompact(980000), 'ETB 980K');
    expect(MoneyFormatter.etbCompact(999999), 'ETB 1M');
    expect(MoneyFormatter.etbCompact(750), 'ETB 750');
  });
}
