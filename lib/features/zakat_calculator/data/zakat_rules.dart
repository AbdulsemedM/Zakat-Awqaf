import 'package:equatable/equatable.dart';

import 'models/calculator_config.dart';

/// Livestock due for camels, in the animals the tables name.
class CamelDue extends Equatable {
  const CamelDue({
    this.sheep = 0,
    this.bintMakhad = 0,
    this.bintLabun = 0,
    this.hiqqah = 0,
    this.jadhaah = 0,
    this.unparsed,
  });

  static const none = CamelDue();

  final int sheep;
  final int bintMakhad;
  final int bintLabun;
  final int hiqqah;
  final int jadhaah;

  /// A table `due` text the app could not read; shown as-is.
  final String? unparsed;

  int get camelCount => bintMakhad + bintLabun + hiqqah + jadhaah;

  bool get hasDue => sheep > 0 || camelCount > 0 || unparsed != null;

  @override
  List<Object?> get props => [
    sheep,
    bintMakhad,
    bintLabun,
    hiqqah,
    jadhaah,
    unparsed,
  ];
}

/// Zakat rules applied to a [CalculatorConfig]. Pure functions, no state.
abstract final class ZakatRules {
  static LivestockTier? tierFor(List<LivestockTier> tiers, int count) {
    for (final tier in tiers) {
      if (tier.covers(count)) return tier;
    }
    return null;
  }

  static int sheepDue(CalculatorConfig config, int count) {
    final tier = tierFor(config.sheepGoats, count);
    if (tier == null) return 0;
    final perHundred = tier.perHundred;
    if (perHundred != null) return (count ~/ 100) * perHundred;
    if (tier.dueItems.isNotEmpty) {
      return tier.dueItems
          .where((item) => item.kind == 'sheep')
          .fold(0, (sum, item) => sum + item.count);
    }
    // Configs before `dueItems` (version 1): read the English text.
    return _leadingCount(tier.due) ?? 0;
  }

  /// Returns `(tabi', musinnah)`.
  static (int, int) cattleDue(CalculatorConfig config, int count) {
    final rules = config.cattle;
    if (count < rules.minimum) return (0, 0);
    return bestCover(count, rules.tabiPer, rules.musinnahPer);
  }

  static CamelDue camelDue(CalculatorConfig config, int count) {
    final tier = tierFor(config.camels, count);
    if (tier == null) return CamelDue.none;
    final bintLabunPer = tier.bintLabunPer;
    final hiqqahPer = tier.hiqqahPer;
    if (bintLabunPer != null && hiqqahPer != null) {
      final (bintLabun, hiqqah) = bestCover(count, bintLabunPer, hiqqahPer);
      return CamelDue(bintLabun: bintLabun, hiqqah: hiqqah);
    }
    if (tier.dueItems.isNotEmpty) return _camelDueFromItems(tier.dueItems);
    // Configs before `dueItems` (version 1): read the English text.
    return _parseCamelDue(tier.due);
  }

  static CamelDue _camelDueFromItems(List<DueItem> items) {
    int count(String kind) => items
        .where((item) => item.kind == kind)
        .fold(0, (sum, item) => sum + item.count);
    const known = {'sheep', 'bint_makhad', 'bint_labun', 'hiqqah', 'jadhaah'};
    final unknown = items.where((item) => !known.contains(item.kind));
    if (unknown.isNotEmpty) {
      return CamelDue(
        unparsed: [
          for (final item in items) '${item.count} ${item.kind}',
        ].join(', '),
      );
    }
    return CamelDue(
      sheep: count('sheep'),
      bintMakhad: count('bint_makhad'),
      bintLabun: count('bint_labun'),
      hiqqah: count('hiqqah'),
      jadhaah: count('jadhaah'),
    );
  }

  /// Picks `(a, b)` so that `a × perA + b × perB` covers as much of [count]
  /// as possible without exceeding it, preferring more of [perB] (the older
  /// animal) on ties.
  static (int, int) bestCover(int count, int perA, int perB) {
    if (perA <= 0 || perB <= 0) return (0, 0);
    for (var covered = count; covered > 0; covered--) {
      for (var b = covered ~/ perB; b >= 0; b--) {
        final rest = covered - b * perB;
        if (rest % perA == 0) return (rest ~/ perA, b);
      }
    }
    return (0, 0);
  }

  /// `(rain-fed share × rain rate) + (irrigated share × irrigated rate)`.
  static double mixedCropRate(
    CropRules rules,
    double rainSharePercent,
    double irrigatedSharePercent,
  ) {
    final total = rainSharePercent + irrigatedSharePercent;
    final normalized = total == 0 ? 1.0 : total;
    return rules.rainFedRate * (rainSharePercent / normalized) +
        rules.irrigatedRate * (irrigatedSharePercent / normalized);
  }

  /// ETB market estimate of a livestock due at the average unit prices.
  /// Sheep are priced as sheep; tabi'/musinnah as cattle; every camel age
  /// class at the camel average. `null` when a needed price is missing.
  static double? livestockEstimateEtb(
    CalculatorConfig config, {
    required int sheep,
    required int cattle,
    required CamelDue camel,
  }) {
    final prices = config.livestockUnitPricesEtb;
    final sheepCount = sheep + camel.sheep;
    if (camel.unparsed != null) return null;
    double total = 0;
    for (final (count, key) in [
      (sheepCount, 'sheep'),
      (cattle, 'cattle'),
      (camel.camelCount, 'camel'),
    ]) {
      if (count == 0) continue;
      final price = prices[key];
      if (price == null) return null;
      total += count * price;
    }
    return total;
  }

  static int? _leadingCount(String due) =>
      int.tryParse(RegExp(r'^\s*(\d+)').firstMatch(due)?.group(1) ?? '');

  static CamelDue _parseCamelDue(String due) {
    final match = RegExp(r'^\s*(\d+)\s+(.+?)\s*$').firstMatch(due);
    if (match == null) return CamelDue(unparsed: due);
    final count = int.parse(match.group(1)!);
    final animal = match.group(2)!.toLowerCase().replaceAll(RegExp("['’]"), '');
    return switch (animal) {
      'sheep' => CamelDue(sheep: count),
      'bint makhad' => CamelDue(bintMakhad: count),
      'bint labun' => CamelDue(bintLabun: count),
      'hiqqah' => CamelDue(hiqqah: count),
      'jadhaah' || 'jadhah' => CamelDue(jadhaah: count),
      _ => CamelDue(unparsed: due),
    };
  }
}
