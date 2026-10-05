import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/impact/data/models/impact_model.dart';
import 'package:mejlis_digital_hub/features/profile/data/profile_mapper.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/data/models/calculator_config.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/data/zakat_rules.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/models/zakat_payment_models.dart';

import 'zakat_calculator/calculator_config_fixture.dart';

/// Shapes from `ZAKAT_APP_BACKEND_BLOCKERS_ANSWERS.md`.
void main() {
  group('Livestock dueItems (config version 2)', () {
    CalculatorConfig withDueItems() {
      final json = sampleConfigJson();
      final livestock = json['livestock'] as Map<String, dynamic>;
      // The text says one thing, dueItems another: dueItems must win.
      livestock['sheepGoats'] = [
        {
          'min': 40,
          'max': 120,
          'due': 'ein Schaf',
          'dueItems': [
            {'kind': 'sheep', 'count': 1},
          ],
        },
        {'min': 121, 'max': null, 'due': '…', 'perHundred': 1},
      ];
      livestock['camels'] = [
        {
          'min': 76,
          'max': 90,
          'due': '2 بنت لبون',
          'dueItems': [
            {'kind': 'bint_labun', 'count': 2},
          ],
        },
        {
          'min': 61,
          'max': 75,
          'due': '1 jadha\'ah',
          'dueItems': [
            {'kind': 'jadhaah', 'count': 1},
          ],
        },
        {
          'min': 121,
          'max': null,
          'due': '…',
          'bintLabunPer': 40,
          'hiqqahPer': 50,
        },
      ];
      return CalculatorConfig.fromJson(json);
    }

    test('parsed on closed rows only', () {
      final config = withDueItems();
      expect(config.camels.first.dueItems, [
        const DueItem(kind: 'bint_labun', count: 2),
      ]);
      expect(config.camels.last.dueItems, isEmpty);
    });

    test('rules read the animals from dueItems, not the text', () {
      final config = withDueItems();
      expect(ZakatRules.sheepDue(config, 50), 1);
      expect(ZakatRules.camelDue(config, 80), const CamelDue(bintLabun: 2));
      expect(ZakatRules.camelDue(config, 70), const CamelDue(jadhaah: 1));
      expect(
        ZakatRules.camelDue(config, 130),
        const CamelDue(bintLabun: 2, hiqqah: 1),
      );
    });

    test('version 1 configs (no dueItems) still read the text', () {
      expect(
        ZakatRules.camelDue(sampleConfig(), 80),
        const CamelDue(bintLabun: 2),
      );
    });
  });

  test('giving summary', () {
    final summary = GivingSummary.fromJson({
      'period': {'label': '1448 AH', 'from': '2026-06-16', 'to': '2027-06-05'},
      'totalZakatPaidEtb': 12500.00,
      'totalSadaqahEtb': 0.00,
      'paymentsCount': 3,
      'beneficiariesHelped': null,
      'causesSupported': 1,
      'allTime': {'totalZakatPaidEtb': 20000.00, 'paymentsCount': 5},
    });
    expect(summary.periodLabel, '1448 AH');
    expect(summary.totalZakatPaidEtb, 12500);
    expect(summary.beneficiariesHelped, isNull);
    expect(summary.allTimeZakatPaidEtb, 20000);
    expect(summary.allTimePaymentsCount, 5);
  });

  test('donor profile from /auth/v1/me', () {
    final profile = ProfileMapper.withAuthMe(
      ProfileMapper.defaultLocalOverlay(),
      {
        'sub': 'abc',
        'displayName': 'Amina Hassen',
        'phone': '+251911223344',
        'roles': ['DONOR'],
        'donorSummary': {'totalZakatPaid': 0},
      },
    );
    expect(profile.name, 'Amina Hassen');
    expect(profile.phone, '+251911223344');
    expect(profile.email, '');
  });

  test('impact summary keeps regionCode; null lives stay null', () {
    final summary = ImpactSummary.fromJson({
      'scope': 'region',
      'regionCode': 'addis_ababa',
      'regionName': 'Addis Ababa',
      'livesTouched': null,
    });
    expect(summary.regionCode, 'addis_ababa');
    expect(summary.livesTouched, isNull);
  });
}
