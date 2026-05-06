import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/bloc/zakat_calculator_state.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/data/repository/exchange_rate_repository_impl.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations.dart';

/// Localized copy for the Zakat calculator. Numeric rules mirror
/// [ZakatCalculatorBloc._recompute] for advisory, transparency, and crop text.
final class ZakatCalculatorStrings {
  ZakatCalculatorStrings._();

  static const double cropNisabKg = 653.0;
  static const String _camelNoDueEnglish = 'No due';

  static bool camelHasDue(ZakatCalculatorInitial s) =>
      s.camelZakatDueDescription != _camelNoDueEnglish;

  static String fxStatus(AppLocalizations l, FxRateSource source) {
    switch (source) {
      case FxRateSource.live:
        return l.calcFxLive;
      case FxRateSource.cache:
        return l.calcFxCache;
      case FxRateSource.fallback:
        return l.calcFxFallback;
    }
  }

  static String formatRateTimestamp(
    Locale locale,
    AppLocalizations l,
    DateTime? timestamp,
  ) {
    if (timestamp == null) return l.calcTimestampUnavailable;
    return DateFormat('yyyy-MM-dd HH:mm', locale.toString()).format(
      timestamp.toLocal(),
    );
  }

  /// Maps [ZakatCalculatorBloc] English camel tier strings to localized text.
  static String camelDueDescription(AppLocalizations l, String english) {
    switch (english) {
      case _camelNoDueEnglish:
        return l.calcCamelNoDue;
      case '1 sheep':
        return l.calcCamelSheepN(1);
      case '2 sheep':
        return l.calcCamelSheepN(2);
      case '3 sheep':
        return l.calcCamelSheepN(3);
      case '4 sheep':
        return l.calcCamelSheepN(4);
      case '1 bint makhad':
        return l.calcCamel1BintMakhad;
      case '1 bint labun':
        return l.calcCamel1BintLabun;
      case '1 hiqqah':
        return l.calcCamel1Hiqqah;
      case '1 jadhah':
        return l.calcCamel1Jadhah;
      case '2 bint labun':
        return l.calcCamel2BintLabun;
      case '2 hiqqah':
        return l.calcCamel2Hiqqah;
    }

    final combo = RegExp(
      r'^(\d+) hiqqah \+ (\d+) bint labun$',
    ).firstMatch(english);
    if (combo != null) {
      return l.calcCamelCombo(
        int.parse(combo.group(1)!),
        int.parse(combo.group(2)!),
      );
    }

    final approx = RegExp(
      r'^(\d+) bint labun \(approximate combo\)$',
    ).firstMatch(english);
    if (approx != null) {
      return l.calcCamelApproxBintLabun(int.parse(approx.group(1)!));
    }

    return english;
  }

  static String livestockSummary(AppLocalizations l, ZakatCalculatorInitial s) {
    final sheepDue = s.sheepZakatDueCount;
    final tabi = s.cattleTabiDueCount;
    final musinnah = s.cattleMusinnahDueCount;
    final camelLocalized = camelDueDescription(l, s.camelZakatDueDescription);
    final parts = <String>[];
    if (sheepDue > 0) {
      parts.add(l.calcLsSheepGoats(sheepDue));
    }
    if (tabi > 0 || musinnah > 0) {
      parts.add(l.calcLsCattle(tabi, musinnah));
    }
    if (s.camelZakatDueDescription != _camelNoDueEnglish) {
      parts.add(l.calcLsCamels(camelLocalized));
    }
    if (parts.isEmpty) {
      parts.add(l.calcLsNone);
    }
    return parts.join(l.calcBulletSeparator);
  }

  static String livestockAdvisory(AppLocalizations l, ZakatCalculatorInitial s) {
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
    ZakatCalculatorInitial s,
  ) {
    final sheepDue = s.sheepZakatDueCount;
    final tabi = s.cattleTabiDueCount;
    final musinnah = s.cattleMusinnahDueCount;
    final camelLocalized = camelDueDescription(l, s.camelZakatDueDescription);
    final lines = <String>[
      l.calcTransSheep(s.sheepOrGoats, sheepDue),
      l.calcTransCattle(s.cattle, tabi, musinnah),
      l.calcTransCamel(
        s.camels,
        s.camelZakatDueDescription == _camelNoDueEnglish
            ? l.calcCamelNoDue
            : camelLocalized,
      ),
    ];
    final advisory = livestockAdvisory(l, s);
    if (advisory.isNotEmpty) {
      lines.add(l.calcTransAdvisoryLine(advisory));
    }
    return lines.join('\n');
  }

  static String cropTransparency(AppLocalizations l, ZakatCalculatorInitial s) {
    final boundedRain = s.rainSharePercent.clamp(0, 100).toDouble();
    final boundedIrrigated = s.irrigatedSharePercent.clamp(0, 100).toDouble();
    final normalized = (boundedRain + boundedIrrigated) == 0
        ? 1.0
        : (boundedRain + boundedIrrigated);
    final rainShare = boundedRain / normalized;
    final irrigatedShare = boundedIrrigated / normalized;
    final cropRate = switch (s.cropIrrigationMode) {
      CropIrrigationMode.rainFed => 0.10,
      CropIrrigationMode.irrigated => 0.05,
      CropIrrigationMode.mixed =>
        (0.10 * rainShare) + (0.05 * irrigatedShare),
    };
    final cropDueKg = s.cropKg >= cropNisabKg ? s.cropKg * cropRate : 0.0;

    if (s.cropKg < cropNisabKg) {
      return l.calcCropTransBelow(
        s.cropKg.toStringAsFixed(2),
        cropNisabKg.toStringAsFixed(0),
      );
    }
    if (s.cropIrrigationMode == CropIrrigationMode.mixed) {
      return l.calcCropTransMixed(
        boundedRain.toStringAsFixed(0),
        boundedIrrigated.toStringAsFixed(0),
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
