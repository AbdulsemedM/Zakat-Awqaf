import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mejlis_digital_hub/core/common/utils/money_formatter.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_state.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/data/models/calculator_config.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/data/zakat_rules.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations.dart';

/// Localized copy for the Zakat calculator. Every number comes from the
/// state that [ZakatCalculatorBloc] computed or from its [CalculatorConfig].
final class ZakatCalculatorStrings {
  ZakatCalculatorStrings._();

  /// `0.025` → `2.5`, `0.1` → `10`.
  static String percent(double rate) => _trim(rate * 100);

  static String grams(double grams) => _trim(grams);

  static String _trim(double value) {
    final fixed = value.toStringAsFixed(2);
    return fixed.contains('.')
        ? fixed.replaceFirst(RegExp(r'\.?0+$'), '')
        : fixed;
  }

  static String nisabMetal(AppLocalizations l, NisabBasis basis) =>
      basis == NisabBasis.gold ? l.calcNisabMetalGold : l.calcNisabMetalSilver;

  /// Price per gram of the metal nisab is based on (24k for gold).
  static double nisabMetalPricePerGram(CalculatorConfig config) =>
      config.nisab.basis == NisabBasis.gold
      ? config.goldPricePerGramEtb['24k'] ?? 0
      : config.silverPricePerGramEtb;

  static String pricesAsOf(
    Locale locale,
    AppLocalizations l,
    CalculatorConfig config,
  ) {
    final date = DateFormat(
      'yyyy-MM-dd HH:mm',
      locale.toString(),
    ).format(config.pricesAsOf.toLocal());
    final source = config.priceSource?.trim() ?? '';
    return source.isEmpty
        ? l.calcPricesAsOfNoSource(date)
        : l.calcPricesAsOf(date, source);
  }

  static String livestockNisabNote(
    AppLocalizations l,
    CalculatorConfig config,
  ) {
    int firstMin(List<LivestockTier> tiers) =>
        tiers.isEmpty ? 0 : tiers.first.min;
    return l.calcStep1LivestockNisabNote(
      firstMin(config.sheepGoats),
      config.cattle.minimum,
      firstMin(config.camels),
      config.cattle.tabiPer,
      config.cattle.musinnahPer,
    );
  }

  static String cropBody(AppLocalizations l, CalculatorConfig config) =>
      l.calcStep1CropBody(
        grams(config.crops.nisabKg),
        percent(config.crops.rainFedRate),
        percent(config.crops.irrigatedRate),
      );

  static String howCropZakatWorks(
    AppLocalizations l,
    CalculatorConfig config,
  ) => l.calcHowCropZakatWorksBody(
    grams(config.crops.nisabKg),
    percent(config.crops.rainFedRate),
    percent(config.crops.irrigatedRate),
  );

  static String camelDueDescription(AppLocalizations l, CamelDue due) {
    final unparsed = due.unparsed;
    if (unparsed != null) return unparsed;
    final parts = [
      if (due.sheep > 0) l.calcCamelSheepN(due.sheep),
      if (due.bintMakhad > 0) l.calcCamelBintMakhadN(due.bintMakhad),
      if (due.bintLabun > 0) l.calcCamelBintLabunN(due.bintLabun),
      if (due.hiqqah > 0) l.calcCamelHiqqahN(due.hiqqah),
      if (due.jadhaah > 0) l.calcCamelJadhahN(due.jadhaah),
    ];
    return parts.isEmpty ? l.calcCamelNoDue : parts.join(' + ');
  }

  static String livestockSummary(AppLocalizations l, ZakatCalculatorState s) {
    final tabi = s.cattleTabiDueCount;
    final musinnah = s.cattleMusinnahDueCount;
    final parts = <String>[
      if (s.sheepZakatDueCount > 0) l.calcLsSheepGoats(s.sheepZakatDueCount),
      if (tabi > 0 || musinnah > 0) l.calcLsCattle(tabi, musinnah),
      if (s.camelDue.hasDue) l.calcLsCamels(camelDueDescription(l, s.camelDue)),
    ];
    if (parts.isEmpty) {
      parts.add(l.calcLsNone);
    }
    return parts.join(l.calcBulletSeparator);
  }

  static String livestockAdvisory(AppLocalizations l, ZakatCalculatorState s) {
    final parts = <String>[];
    if (!s.isPastureFedMostOfYear) {
      parts.add(l.calcAdvNotPasture);
    }
    if (!s.completedHawl) {
      parts.add(l.calcAdvHawl);
    }
    if (s.usedForWork) {
      parts.add(l.calcAdvWork);
    }
    return parts.join(' ');
  }

  static String livestockTransparency(
    AppLocalizations l,
    ZakatCalculatorState s,
  ) {
    final config = s.config;
    if (config == null) return '';
    int firstMin(List<LivestockTier> tiers) =>
        tiers.isEmpty ? 0 : tiers.first.min;
    final lines = <String>[
      l.calcTransSheep(
        s.sheepOrGoats,
        s.sheepZakatDueCount,
        firstMin(config.sheepGoats),
      ),
      l.calcTransCattle(
        s.cattle,
        s.cattleTabiDueCount,
        s.cattleMusinnahDueCount,
        config.cattle.minimum,
        config.cattle.tabiPer,
        config.cattle.musinnahPer,
      ),
      l.calcTransCamel(
        s.camels,
        camelDueDescription(l, s.camelDue),
        firstMin(config.camels),
      ),
    ];
    final estimate = s.livestockEstimatedValueEtb;
    if (s.livestockHasDue && estimate != null) {
      lines.add(l.calcLivestockEstimateLine(MoneyFormatter.etb(estimate)));
    }
    final advisory = livestockAdvisory(l, s);
    if (advisory.isNotEmpty) {
      lines.add(l.calcTransAdvisoryLine(advisory));
    }
    return lines.join('\n');
  }

  static String wealthTransparency(AppLocalizations l, ZakatCalculatorState s) {
    final config = s.config;
    if (config == null) return '';
    final karatLabel = s.goldKarat.localizedLabel(l);
    final liquidSubtotal = s.cashOnHand + s.bankBalance + s.mobileWallet;
    final nisab = config.nisab;
    final lines = <String>[
      l.calcWealthTransLiquidsLine(
        MoneyFormatter.etb(s.cashOnHand),
        MoneyFormatter.etb(s.bankBalance),
        MoneyFormatter.etb(s.mobileWallet),
        MoneyFormatter.etb(liquidSubtotal),
      ),
      l.calcWealthTransBusinessLine(
        MoneyFormatter.etb(s.totalBusinessAssetsEtb),
      ),
      l.calcWealthTransGoldLine(
        s.goldGrams.toStringAsFixed(2),
        karatLabel,
        MoneyFormatter.etb(s.goldPricePerGramEtb),
        MoneyFormatter.etb(s.goldValueEtb),
      ),
      l.calcWealthTransSilverLine(
        s.silverGrams.toStringAsFixed(2),
        config.silverPricePerGramEtb.toStringAsFixed(2),
        MoneyFormatter.etb(s.silverValueEtb),
      ),
      l.calcWealthTransRollupLine(
        MoneyFormatter.etb(liquidSubtotal),
        MoneyFormatter.etb(s.totalBusinessAssetsEtb),
        MoneyFormatter.etb(s.goldValueEtb),
        MoneyFormatter.etb(s.silverValueEtb),
        MoneyFormatter.etb(s.totalWealthEtb),
      ),
      l.calcWealthTransNetLine(
        MoneyFormatter.etb(s.totalLiabilitiesEtb),
        MoneyFormatter.etb(s.netWealthEtb),
      ),
      l.calcWealthTransNisabLine(
        grams(nisab.basisGrams),
        nisabMetal(l, nisab.basis),
        MoneyFormatter.etb(nisabMetalPricePerGram(config)),
        MoneyFormatter.etb(s.nisabThresholdEtb),
      ),
    ];
    if (s.aboveNisab) {
      lines.add(
        l.calcWealthTransDueAbove(
          MoneyFormatter.etb(s.netWealthEtb),
          MoneyFormatter.etb(s.estimatedZakatDueEtb),
          MoneyFormatter.etb(s.nisabThresholdEtb),
          percent(config.wealthRate),
        ),
      );
    } else {
      lines.add(
        l.calcWealthTransDueBelow(
          MoneyFormatter.etb(s.netWealthEtb),
          MoneyFormatter.etb(s.nisabThresholdEtb),
          MoneyFormatter.etb(s.estimatedZakatDueEtb),
        ),
      );
    }
    return lines.join('\n');
  }

  static String cropTransparency(AppLocalizations l, ZakatCalculatorState s) {
    final config = s.config;
    if (config == null) return '';
    final cropRate = s.cropEffectiveRate;
    final cropDueKg = s.cropZakatDueKg;

    if (!s.cropAboveNisab) {
      return l.calcCropTransBelow(
        s.cropKg.toStringAsFixed(2),
        grams(config.crops.nisabKg),
      );
    }
    if (s.cropIrrigationMode == CropIrrigationMode.mixed) {
      return l.calcCropTransMixed(
        s.rainSharePercent.toStringAsFixed(0),
        s.irrigatedSharePercent.toStringAsFixed(0),
        (cropRate * 100).toStringAsFixed(2),
        s.cropKg.toStringAsFixed(2),
        (cropRate * 100).toStringAsFixed(2),
        cropDueKg.toStringAsFixed(2),
      );
    }
    final ratePercent = (cropRate * 100).toStringAsFixed(1);
    if (s.cropIrrigationMode == CropIrrigationMode.rainFed) {
      return l.calcCropTransRainFed(
        ratePercent,
        s.cropKg.toStringAsFixed(2),
        ratePercent,
        cropDueKg.toStringAsFixed(2),
      );
    }
    return l.calcCropTransIrrigated(
      ratePercent,
      s.cropKg.toStringAsFixed(2),
      ratePercent,
      cropDueKg.toStringAsFixed(2),
    );
  }

  static String cropModeLabel(AppLocalizations l, CropIrrigationMode mode) {
    switch (mode) {
      case CropIrrigationMode.rainFed:
        return l.calcCropModeRainFed;
      case CropIrrigationMode.irrigated:
        return l.calcCropModeIrrigated;
      case CropIrrigationMode.mixed:
        return l.calcCropModeMixed;
    }
  }

  static List<MapEntry<String, String>> arabicTermEntries(AppLocalizations l) {
    return [
      MapEntry("tabi'", l.calcArabicDefTabi),
      MapEntry('musinnah', l.calcArabicDefMusinnah),
      MapEntry('bint makhad', l.calcArabicDefBintMakhad),
      MapEntry('bint labun', l.calcArabicDefBintLabun),
      MapEntry('hiqqah', l.calcArabicDefHiqqah),
      MapEntry('jadhah', l.calcArabicDefJadhah),
    ];
  }
}

extension GoldKaratL10n on GoldKarat {
  String localizedLabel(AppLocalizations l) {
    switch (this) {
      case GoldKarat.k24:
        return l.calcGoldK24;
      case GoldKarat.k22:
        return l.calcGoldK22;
      case GoldKarat.k21:
        return l.calcGoldK21;
      case GoldKarat.k18:
        return l.calcGoldK18;
      case GoldKarat.k14:
        return l.calcGoldK14;
    }
  }
}
