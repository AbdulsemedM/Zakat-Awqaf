import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/network/api_envelope.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_bloc.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_event.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_state.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/data/models/calculator_config.dart';

import 'calculator_config_fixture.dart';

ZakatCalculatorInitial _state(ZakatCalculatorBloc bloc) =>
    bloc.state as ZakatCalculatorInitial;

void main() {
  group('Calculator config', () {
    test('parses the sample response', () {
      final config = sampleConfig();
      expect(config.configVersion, 1);
      expect(config.nisab.basis, NisabBasis.gold);
      expect(config.nisab.valueEtb, 1676534.90);
      expect(config.goldPricePerGramEtb['21k'], 17258.45);
      expect(config.silverPricePerGramEtb, 239.77);
      expect(config.wealthRate, 0.025);
      expect(config.sheepGoats.last.max, isNull);
      expect(config.sheepGoats.last.perHundred, 1);
      expect(config.sheepGoats.first.perHundred, isNull);
      expect(config.livestockUnitPricesEtb['camel'], 180000);
    });

    test('silver basis and missing fields', () {
      final json = sampleConfigJson()
        ..['nisab'] = {
          'basis': 'silver',
          'goldGrams': 85,
          'silverGrams': 595,
          'valueEtb': 142663.15,
        }
        ..['usdEtbRate'] = null;
      final config = CalculatorConfig.fromJson(json);
      expect(config.nisab.basis, NisabBasis.silver);
      expect(config.nisab.basisGrams, 595);
      expect(config.usdEtbRate, isNull);

      expect(
        () => CalculatorConfig.fromJson(sampleConfigJson()..remove('nisab')),
        throwsFormatException,
      );
    });

    test('stale after 48 hours', () {
      final asOf = DateTime.utc(2026, 10, 1, 3);
      final config = CalculatorConfig.fromJson(
        sampleConfigJson(pricesAsOf: asOf),
      );
      expect(config.isStale(asOf.add(const Duration(hours: 47))), isFalse);
      expect(config.isStale(asOf.add(const Duration(hours: 49))), isTrue);
    });
  });

  group('Calculator bloc config loading', () {
    test('wealth uses config prices, nisab and rate', () async {
      final bloc = await loadedBloc();
      addTearDown(bloc.close);

      bloc.add(
        const WealthFieldsUpdated(
          cashOnHand: 1000000,
          goldGrams: 50,
          goldKarat: GoldKarat.k21,
          silverGrams: 100,
        ),
      );
      await settle();

      final s = _state(bloc);
      expect(s.goldPricePerGramEtb, 17258.45);
      expect(s.goldValueEtb, closeTo(50 * 17258.45, 0.001));
      expect(s.silverValueEtb, closeTo(100 * 239.77, 0.001));
      expect(s.nisabThresholdEtb, 1676534.90);
      final net = 1000000 + 50 * 17258.45 + 100 * 239.77;
      expect(s.aboveNisab, isTrue);
      expect(s.estimatedZakatDueEtb, closeTo(net * 0.025, 0.001));
    });

    test('no config and fetch fails: failed, 503 flagged', () async {
      final bloc = ZakatCalculatorBloc(
        FakeCalculatorConfigRepository(
          error: const ApiException('not ready', statusCode: 503),
        ),
      )..add(const ZakatCalculatorStarted());
      addTearDown(bloc.close);
      await settle();

      final s = _state(bloc);
      expect(s.config, isNull);
      expect(s.configStatus, CalculatorConfigStatus.failed);
      expect(s.configNotReady, isTrue);
    });

    test('cached config is used when the fetch fails', () async {
      final repository = FakeCalculatorConfigRepository(
        cached: sampleConfig(),
        error: const ApiException('offline'),
      );
      final bloc = ZakatCalculatorBloc(repository)
        ..add(const ZakatCalculatorStarted());
      addTearDown(bloc.close);
      await settle();

      var s = _state(bloc);
      expect(s.configStatus, CalculatorConfigStatus.ready);
      expect(s.configFromCache, isTrue);
      expect(s.configRefreshFailed, isTrue);
      expect(s.nisabThresholdEtb, 1676534.90);

      repository
        ..error = null
        ..live = sampleConfig();
      bloc.add(const CalculatorConfigRefreshRequested());
      await settle();

      s = _state(bloc);
      expect(s.configFromCache, isFalse);
      expect(s.configRefreshFailed, isFalse);
    });

    test('failed then retried succeeds', () async {
      final repository = FakeCalculatorConfigRepository(
        error: const ApiException('offline'),
      );
      final bloc = ZakatCalculatorBloc(repository)
        ..add(const ZakatCalculatorStarted());
      addTearDown(bloc.close);
      await settle();
      expect(_state(bloc).configStatus, CalculatorConfigStatus.failed);

      repository
        ..error = null
        ..live = sampleConfig();
      bloc.add(const CalculatorConfigRefreshRequested());
      await settle();
      expect(_state(bloc).configStatus, CalculatorConfigStatus.ready);
      expect(_state(bloc).configNotReady, isFalse);
    });
  });
}
