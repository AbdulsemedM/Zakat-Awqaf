import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_bloc.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_event.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_state.dart';

Future<ZakatCalculatorInitial> _applyLivestockUpdate(
  ZakatCalculatorBloc bloc,
  LivestockFieldsUpdated event,
) async {
  bloc.add(event);
  await Future<void>.delayed(const Duration(milliseconds: 1));
  return bloc.state as ZakatCalculatorInitial;
}

void main() {
  group('Livestock Zakat rules', () {
    test('sheep/goats boundary cases', () async {
      final bloc = ZakatCalculatorBloc();
      addTearDown(bloc.close);

      var state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(sheepOrGoats: 39),
      );
      expect(state.sheepZakatDueCount, 0);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(sheepOrGoats: 40),
      );
      expect(state.sheepZakatDueCount, 1);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(sheepOrGoats: 120),
      );
      expect(state.sheepZakatDueCount, 1);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(sheepOrGoats: 121),
      );
      expect(state.sheepZakatDueCount, 2);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(sheepOrGoats: 200),
      );
      expect(state.sheepZakatDueCount, 2);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(sheepOrGoats: 201),
      );
      expect(state.sheepZakatDueCount, 3);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(sheepOrGoats: 300),
      );
      expect(state.sheepZakatDueCount, 3);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(sheepOrGoats: 301),
      );
      expect(state.sheepZakatDueCount, 4);
    });

    test('cattle representative combination cases', () async {
      final bloc = ZakatCalculatorBloc();
      addTearDown(bloc.close);

      var state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(cattle: 30),
      );
      expect(state.cattleTabiDueCount, 1);
      expect(state.cattleMusinnahDueCount, 0);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(cattle: 40),
      );
      expect(state.cattleTabiDueCount, 0);
      expect(state.cattleMusinnahDueCount, 1);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(cattle: 60),
      );
      expect(state.cattleTabiDueCount, 2);
      expect(state.cattleMusinnahDueCount, 0);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(cattle: 70),
      );
      expect(state.cattleTabiDueCount, 1);
      expect(state.cattleMusinnahDueCount, 1);

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(cattle: 80),
      );
      expect(state.cattleTabiDueCount, 0);
      expect(state.cattleMusinnahDueCount, 2);
    });

    test('camel representative tier cases', () async {
      final bloc = ZakatCalculatorBloc();
      addTearDown(bloc.close);

      var state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(camels: 5),
      );
      expect(state.camelZakatDueDescription, '1 sheep');

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(camels: 10),
      );
      expect(state.camelZakatDueDescription, '2 sheep');

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(camels: 15),
      );
      expect(state.camelZakatDueDescription, '3 sheep');

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(camels: 20),
      );
      expect(state.camelZakatDueDescription, '4 sheep');

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(camels: 25),
      );
      expect(state.camelZakatDueDescription, '1 bint makhad');

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(camels: 36),
      );
      expect(state.camelZakatDueDescription, '1 bint labun');

      state = await _applyLivestockUpdate(
        bloc,
        const LivestockFieldsUpdated(camels: 46),
      );
      expect(state.camelZakatDueDescription, '1 hiqqah');
    });

    test('advisory toggles change messaging not numeric due', () async {
      final bloc = ZakatCalculatorBloc();
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
      expect(state.livestockAdvisoryText, isNotEmpty);
    });
  });
}
