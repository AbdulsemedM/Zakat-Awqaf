import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_bloc.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_event.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_state.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/data/zakat_rules.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/presentation/zakat_calculator_strings.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations_en.dart';

import 'calculator_config_fixture.dart';

Future<ZakatCalculatorInitial> _applyLivestockUpdate(
  ZakatCalculatorBloc bloc,
  LivestockFieldsUpdated event,
) async {
  bloc.add(event);
  await settle();
  return bloc.state as ZakatCalculatorInitial;
}

void main() {
  final config = sampleConfig();

  group('Livestock Zakat rules (server tables)', () {
    test('sheep/goats boundary cases', () {
      final cases = {
        39: 0,
        40: 1,
        120: 1,
        121: 2,
        200: 2,
        201: 3,
        300: 3,
        // Open-ended row: 1 sheep per full 100.
        301: 3,
        399: 3,
        400: 4,
        550: 5,
      };
      for (final MapEntry(key: head, value: due) in cases.entries) {
        expect(ZakatRules.sheepDue(config, head), due, reason: '$head sheep');
      }
    });

    test('cattle representative combination cases', () {
      final cases = {
        29: (0, 0),
        30: (1, 0),
        39: (1, 0),
        40: (0, 1),
        59: (0, 1),
        60: (2, 0),
        70: (1, 1),
        80: (0, 2),
        90: (3, 0),
        100: (2, 1),
      };
      for (final MapEntry(key: head, value: due) in cases.entries) {
        expect(ZakatRules.cattleDue(config, head), due, reason: '$head cattle');
      }
    });

    test('camel tier cases', () {
      final cases = {
        4: CamelDue.none,
        5: const CamelDue(sheep: 1),
        10: const CamelDue(sheep: 2),
        15: const CamelDue(sheep: 3),
        20: const CamelDue(sheep: 4),
        25: const CamelDue(bintMakhad: 1),
        36: const CamelDue(bintLabun: 1),
        46: const CamelDue(hiqqah: 1),
        61: const CamelDue(jadhaah: 1),
        76: const CamelDue(bintLabun: 2),
        91: const CamelDue(hiqqah: 2),
        // 121+: 1 bint labun per 40 and 1 hiqqah per 50.
        121: const CamelDue(bintLabun: 3),
        130: const CamelDue(bintLabun: 2, hiqqah: 1),
        150: const CamelDue(hiqqah: 3),
      };
      for (final MapEntry(key: head, value: due) in cases.entries) {
        expect(ZakatRules.camelDue(config, head), due, reason: '$head camels');
      }
    });

    test('market estimate uses average unit prices', () {
      // 2 sheep + (1 tabi' + 1 musinnah) + 1 hiqqah
      final estimate = ZakatRules.livestockEstimateEtb(
        config,
        sheep: 2,
        cattle: 2,
        camel: const CamelDue(hiqqah: 1),
      );
      expect(estimate, 2 * 9000 + 2 * 60000 + 180000);

      // Camel dues paid in sheep are priced as sheep.
      expect(
        ZakatRules.livestockEstimateEtb(
          config,
          sheep: 0,
          cattle: 0,
          camel: const CamelDue(sheep: 3),
        ),
        3 * 9000,
      );
    });
  });

  group('Livestock in the bloc', () {
    test('counts update dues and the ETB estimate', () async {
      final bloc = await loadedBloc();
      addTearDown(bloc.close);

      final state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(sheepOrGoats: 150, cattle: 70, camels: 46),
      );
      expect(state.sheepZakatDueCount, 2);
      expect(state.cattleTabiDueCount, 1);
      expect(state.cattleMusinnahDueCount, 1);
      expect(state.camelDue, const CamelDue(hiqqah: 1));
      expect(state.livestockHasDue, isTrue);
      expect(state.livestockEstimatedValueEtb, 2 * 9000 + 2 * 60000 + 180000);
    });

    test('advisory toggles change messaging not numeric due', () async {
      final bloc = await loadedBloc();
      addTearDown(bloc.close);

      var state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(cattle: 70),
      );
      final tabiBefore = state.cattleTabiDueCount;
      final musinnahBefore = state.cattleMusinnahDueCount;

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(
          isPastureFedMostOfYear: false,
          completedHawl: false,
          usedForWork: true,
        ),
      );

      expect(state.cattleTabiDueCount, tabiBefore);
      expect(state.cattleMusinnahDueCount, musinnahBefore);
      expect(
        ZakatCalculatorStrings.livestockAdvisory(AppLocalizationsEn(), state),
        isNotEmpty,
      );
    });
  });
}
