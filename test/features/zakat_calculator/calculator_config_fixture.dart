import 'package:mejlis_digital_hub/core/network/api_envelope.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_bloc.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_event.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/data/models/calculator_config.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/data/repository/calculator_config_repository.dart';

/// `data` of the sample `GET /api/zakat/v1/calculator/config` response in
/// the backend's ZAKAT-APP-API-GUIDE.
Map<String, dynamic> sampleConfigJson({DateTime? pricesAsOf}) => {
  'configVersion': 1,
  'pricesAsOf': (pricesAsOf ?? DateTime.utc(2026, 10, 1, 3)).toIso8601String(),
  'priceSource': 'GoldAPI.io + fxapi.app',
  'usdEtbRate': 161.418209,
  'goldPricePerGramEtb': {
    '24k': 19723.94,
    '22k': 18080.29,
    '21k': 17258.45,
    '18k': 14792.95,
    '14k': 11506.24,
  },
  'silverPricePerGramEtb': 239.77,
  'nisab': {
    'basis': 'gold',
    'goldGrams': 85,
    'silverGrams': 595,
    'valueEtb': 1676534.90,
  },
  'wealth': {'rate': 0.025, 'hawlLunarDays': 354},
  'crops': {'nisabKg': 653, 'rainFedRate': 0.10, 'irrigatedRate': 0.05},
  'livestock': {
    'sheepGoats': [
      {'min': 40, 'max': 120, 'due': '1 sheep'},
      {'min': 121, 'max': 200, 'due': '2 sheep'},
      {'min': 201, 'max': 300, 'due': '3 sheep'},
      {'min': 301, 'max': null, 'due': '1 sheep per 100', 'perHundred': 1},
    ],
    'cattle': {'minimum': 30, 'tabiPer': 30, 'musinnahPer': 40},
    'camels': [
      {'min': 5, 'max': 9, 'due': '1 sheep'},
      {'min': 10, 'max': 14, 'due': '2 sheep'},
      {'min': 15, 'max': 19, 'due': '3 sheep'},
      {'min': 20, 'max': 24, 'due': '4 sheep'},
      {'min': 25, 'max': 35, 'due': '1 bint makhad'},
      {'min': 36, 'max': 45, 'due': '1 bint labun'},
      {'min': 46, 'max': 60, 'due': '1 hiqqah'},
      {'min': 61, 'max': 75, 'due': "1 jadha'ah"},
      {'min': 76, 'max': 90, 'due': '2 bint labun'},
      {'min': 91, 'max': 120, 'due': '2 hiqqah'},
      {
        'min': 121,
        'max': null,
        'due': '1 bint labun per 40 and 1 hiqqah per 50',
        'bintLabunPer': 40,
        'hiqqahPer': 50,
      },
    ],
  },
  'livestockAverageUnitPriceEtb': {
    'sheep': 9000,
    'goat': 7000,
    'cattle': 60000,
    'camel': 180000,
  },
};

CalculatorConfig sampleConfig() =>
    CalculatorConfig.fromJson(sampleConfigJson());

/// Serves a fixed config, or fails like the server would.
class FakeCalculatorConfigRepository implements CalculatorConfigRepository {
  FakeCalculatorConfigRepository({this.cached, this.live, this.error});

  CalculatorConfig? cached;
  CalculatorConfig? live;
  ApiException? error;

  @override
  Future<CalculatorConfig?> readCached() async => cached;

  @override
  Future<CalculatorConfig> fetchLatest() async {
    final error = this.error;
    if (error != null) throw error;
    return live!;
  }
}

/// A bloc that has already loaded [sampleConfig].
Future<ZakatCalculatorBloc> loadedBloc() async {
  final bloc = ZakatCalculatorBloc(
    FakeCalculatorConfigRepository(live: sampleConfig()),
  )..add(const ZakatCalculatorStarted());
  await settle();
  return bloc;
}

Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 1));
