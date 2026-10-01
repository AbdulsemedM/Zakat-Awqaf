import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_bloc.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_event.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_state.dart';

import 'calculator_config_fixture.dart';

Future<ZakatCalculatorInitial> _applyCropUpdate(
  ZakatCalculatorBloc bloc,
  CropFieldsUpdated event,
) async {
  bloc.add(event);
  await settle();
  return bloc.state as ZakatCalculatorInitial;
}

void main() {
  group('Ushr crop rules', () {
    test('below nisab gives zero crop due', () async {
      final bloc = await loadedBloc();
      addTearDown(bloc.close);

      final state = await _applyCropUpdate(
        bloc,
        const CropFieldsUpdated(cropKg: 600),
      );
      expect(state.cropZakatDueKg, 0);
      expect(state.cropAboveNisab, isFalse);
    });

    test('rain-fed applies 10 percent', () async {
      final bloc = await loadedBloc();
      addTearDown(bloc.close);

      final state = await _applyCropUpdate(
        bloc,
        const CropFieldsUpdated(
          cropIrrigationMode: CropIrrigationMode.rainFed,
          cropKg: 1000,
        ),
      );
      expect(state.cropEffectiveRate, closeTo(0.10, 0.0001));
      expect(state.cropZakatDueKg, closeTo(100, 0.0001));
    });

    test('irrigated applies 5 percent', () async {
      final bloc = await loadedBloc();
      addTearDown(bloc.close);

      final state = await _applyCropUpdate(
        bloc,
        const CropFieldsUpdated(
          cropIrrigationMode: CropIrrigationMode.irrigated,
          cropKg: 1000,
        ),
      );
      expect(state.cropEffectiveRate, closeTo(0.05, 0.0001));
      expect(state.cropZakatDueKg, closeTo(50, 0.0001));
    });

    test('mixed uses weighted rate from entered split', () async {
      final bloc = await loadedBloc();
      addTearDown(bloc.close);

      final state = await _applyCropUpdate(
        bloc,
        const CropFieldsUpdated(
          cropIrrigationMode: CropIrrigationMode.mixed,
          rainSharePercent: 70,
          irrigatedSharePercent: 30,
          cropKg: 1000,
        ),
      );
      // (0.10 * 0.70) + (0.05 * 0.30) = 0.085
      expect(state.cropEffectiveRate, closeTo(0.085, 0.0001));
      expect(state.cropZakatDueKg, closeTo(85, 0.0001));
      expect(state.cropIrrigationMode, CropIrrigationMode.mixed);
    });
  });
}
