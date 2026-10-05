import 'package:equatable/equatable.dart';

/// `GET /api/zakat/v1/calculator/config` — prices and rules set by the
/// commission. Every number the calculator uses comes from here.
class CalculatorConfig extends Equatable {
  const CalculatorConfig({
    required this.configVersion,
    required this.pricesAsOf,
    required this.priceSource,
    required this.usdEtbRate,
    required this.goldPricePerGramEtb,
    required this.silverPricePerGramEtb,
    required this.nisab,
    required this.wealthRate,
    required this.hawlLunarDays,
    required this.crops,
    required this.sheepGoats,
    required this.cattle,
    required this.camels,
    required this.livestockUnitPricesEtb,
    required this.json,
  });

  /// Prices older than this get a "may be out of date" notice.
  static const staleAfter = Duration(hours: 48);

  final int configVersion;
  final DateTime pricesAsOf;
  final String? priceSource;
  final double? usdEtbRate;

  /// Keyed by karat label: `24k`, `22k`, `21k`, `18k`, `14k`.
  final Map<String, double> goldPricePerGramEtb;
  final double silverPricePerGramEtb;
  final NisabRule nisab;
  final double wealthRate;
  final int? hawlLunarDays;
  final CropRules crops;
  final List<LivestockTier> sheepGoats;
  final CattleRules cattle;
  final List<LivestockTier> camels;

  /// Keyed by `sheep`, `goat`, `cattle`, `camel`.
  final Map<String, double> livestockUnitPricesEtb;

  /// The response `data` as received, kept for the offline cache.
  final Map<String, dynamic> json;

  bool isStale(DateTime now) => now.difference(pricesAsOf) > staleAfter;

  factory CalculatorConfig.fromJson(Map<String, dynamic> json) {
    final livestock = _map(json, 'livestock');
    final wealth = _map(json, 'wealth');
    return CalculatorConfig(
      configVersion: _int(json, 'configVersion'),
      pricesAsOf: _date(json, 'pricesAsOf'),
      priceSource: json['priceSource']?.toString(),
      usdEtbRate: (json['usdEtbRate'] as num?)?.toDouble(),
      goldPricePerGramEtb: _doubleMap(_map(json, 'goldPricePerGramEtb')),
      silverPricePerGramEtb: _double(json, 'silverPricePerGramEtb'),
      nisab: NisabRule.fromJson(_map(json, 'nisab')),
      wealthRate: _double(wealth, 'rate'),
      hawlLunarDays: (wealth['hawlLunarDays'] as num?)?.toInt(),
      crops: CropRules.fromJson(_map(json, 'crops')),
      sheepGoats: _tiers(livestock, 'sheepGoats'),
      cattle: CattleRules.fromJson(_map(livestock, 'cattle')),
      camels: _tiers(livestock, 'camels'),
      livestockUnitPricesEtb: json['livestockAverageUnitPriceEtb'] is Map
          ? _doubleMap(_map(json, 'livestockAverageUnitPriceEtb'))
          : const {},
      json: json,
    );
  }

  @override
  List<Object?> get props => [json];
}

enum NisabBasis { gold, silver }

class NisabRule extends Equatable {
  const NisabRule({
    required this.basis,
    required this.goldGrams,
    required this.silverGrams,
    required this.valueEtb,
  });

  final NisabBasis basis;
  final double goldGrams;
  final double silverGrams;

  /// Precomputed threshold: grams of the [basis] metal × its price.
  final double valueEtb;

  double get basisGrams => basis == NisabBasis.gold ? goldGrams : silverGrams;

  factory NisabRule.fromJson(Map<String, dynamic> json) {
    final basis = json['basis']?.toString();
    return NisabRule(
      basis: basis == 'silver' ? NisabBasis.silver : NisabBasis.gold,
      goldGrams: _double(json, 'goldGrams'),
      silverGrams: _double(json, 'silverGrams'),
      valueEtb: _double(json, 'valueEtb'),
    );
  }

  @override
  List<Object?> get props => [basis, goldGrams, silverGrams, valueEtb];
}

class CropRules extends Equatable {
  const CropRules({
    required this.nisabKg,
    required this.rainFedRate,
    required this.irrigatedRate,
  });

  final double nisabKg;
  final double rainFedRate;
  final double irrigatedRate;

  factory CropRules.fromJson(Map<String, dynamic> json) => CropRules(
    nisabKg: _double(json, 'nisabKg'),
    rainFedRate: _double(json, 'rainFedRate'),
    irrigatedRate: _double(json, 'irrigatedRate'),
  );

  @override
  List<Object?> get props => [nisabKg, rainFedRate, irrigatedRate];
}

class CattleRules extends Equatable {
  const CattleRules({
    required this.minimum,
    required this.tabiPer,
    required this.musinnahPer,
  });

  final int minimum;
  final int tabiPer;
  final int musinnahPer;

  factory CattleRules.fromJson(Map<String, dynamic> json) => CattleRules(
    minimum: _int(json, 'minimum'),
    tabiPer: _int(json, 'tabiPer'),
    musinnahPer: _int(json, 'musinnahPer'),
  );

  @override
  List<Object?> get props => [minimum, tabiPer, musinnahPer];
}

/// One row of a livestock table: applies when `min ≤ count ≤ max`.
/// The open-ended last row has `max == null` and carries the per-N fields.
class LivestockTier extends Equatable {
  const LivestockTier({
    required this.min,
    required this.max,
    required this.due,
    this.perHundred,
    this.bintLabunPer,
    this.hiqqahPer,
    this.dueItems = const [],
  });

  final int min;
  final int? max;

  /// Display text only (it will be translated); read [dueItems] instead.
  final String due;
  final int? perHundred;
  final int? bintLabunPer;
  final int? hiqqahPer;

  /// The animals due on a closed row, e.g. `[(bint_labun, 2)]`. Empty on
  /// open-ended rows (they use the per-N fields) and on older configs.
  final List<DueItem> dueItems;

  bool covers(int count) => count >= min && (max == null || count <= max!);

  factory LivestockTier.fromJson(Map<String, dynamic> json) => LivestockTier(
    min: _int(json, 'min'),
    max: (json['max'] as num?)?.toInt(),
    due: json['due']?.toString() ?? '',
    perHundred: (json['perHundred'] as num?)?.toInt(),
    bintLabunPer: (json['bintLabunPer'] as num?)?.toInt(),
    hiqqahPer: (json['hiqqahPer'] as num?)?.toInt(),
    dueItems: [
      if (json['dueItems'] case final List items)
        for (final item in items)
          if (item case {'kind': final String kind, 'count': final num count})
            DueItem(kind: kind, count: count.toInt()),
    ],
  );

  @override
  List<Object?> get props => [
    min,
    max,
    due,
    perHundred,
    bintLabunPer,
    hiqqahPer,
    dueItems,
  ];
}

/// One animal kind and count in a livestock row's `dueItems`. `kind` is one of
/// `sheep`, `bint_makhad`, `bint_labun`, `hiqqah`, `jadhaah`.
class DueItem extends Equatable {
  const DueItem({required this.kind, required this.count});

  final String kind;
  final int count;

  @override
  List<Object?> get props => [kind, count];
}

Map<String, dynamic> _map(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map) throw FormatException('Missing object "$key"');
  return Map<String, dynamic>.from(value);
}

double _double(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num) throw FormatException('Missing number "$key"');
  return value.toDouble();
}

int _int(Map<String, dynamic> json, String key) => _double(json, key).toInt();

DateTime _date(Map<String, dynamic> json, String key) {
  final value = DateTime.tryParse(json[key]?.toString() ?? '');
  if (value == null) throw FormatException('Missing timestamp "$key"');
  return value;
}

Map<String, double> _doubleMap(Map<String, dynamic> json) => {
  for (final entry in json.entries)
    if (entry.value is num) entry.key: (entry.value as num).toDouble(),
};

List<LivestockTier> _tiers(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) throw FormatException('Missing list "$key"');
  return [
    for (final row in value)
      if (row is Map) LivestockTier.fromJson(Map<String, dynamic>.from(row)),
  ];
}
