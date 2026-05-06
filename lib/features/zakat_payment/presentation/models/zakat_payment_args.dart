import '../../../../core/common/utils/money_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../zakat_calculator/bloc/zakat_calculator_state.dart';
import '../../../zakat_calculator/presentation/zakat_calculator_strings.dart';

enum ZakatAmountEntryMode { fixed, userEstimatedEtb }

/// Navigation extra for [`ZakatPaymentScreen`].
class ZakatPaymentArgs {
  const ZakatPaymentArgs({
    required this.activeTab,
    required this.amountEntryMode,
    this.fixedAmountEtb,
    required this.overviewTitle,
    required this.overviewPrimaryValue,
    required this.overviewDueLabel,
    required this.overviewDueValue,
    this.livestockSummaryText,
    this.livestockTransparencyText,
    this.cropTransparencyText,
    this.certificateNaturalUnitLine,
  });

  final ZakatCategoryTab activeTab;
  final ZakatAmountEntryMode amountEntryMode;
  final double? fixedAmountEtb;

  /// Mirrors [`_TabOverviewCard`] conceptually.
  final String overviewTitle;
  final String overviewPrimaryValue;
  final String overviewDueLabel;
  final String overviewDueValue;

  final String? livestockSummaryText;
  final String? livestockTransparencyText;
  final String? cropTransparencyText;

  /// Optional one-line text for certificate PDF (livestock/crops natural units).
  final String? certificateNaturalUnitLine;

  static bool canOpenPayment(ZakatCalculatorInitial s) {
    switch (s.activeTab) {
      case ZakatCategoryTab.wealth:
        return s.aboveNisab && s.estimatedZakatDueEtb > 0;
      case ZakatCategoryTab.livestock:
        return s.sheepZakatDueCount > 0 ||
            s.cattleTabiDueCount > 0 ||
            s.cattleMusinnahDueCount > 0 ||
            s.camelZakatDueDescription != 'No due';
      case ZakatCategoryTab.crops:
        return s.cropKg >= 653 && s.cropZakatDueKg > 0;
    }
  }

  static String blockedMessage(AppLocalizations l, ZakatCalculatorInitial s) {
    switch (s.activeTab) {
      case ZakatCategoryTab.wealth:
        return l.calcPayBlockedWealth;
      case ZakatCategoryTab.livestock:
        return l.calcPayBlockedLivestock;
      case ZakatCategoryTab.crops:
        return l.calcPayBlockedCrops;
    }
  }

  static ZakatPaymentArgs fromCalculator(AppLocalizations l, ZakatCalculatorInitial s) {
    switch (s.activeTab) {
      case ZakatCategoryTab.wealth:
        return ZakatPaymentArgs(
          activeTab: s.activeTab,
          amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
          fixedAmountEtb: s.estimatedZakatDueEtb,
          overviewTitle: l.calcOverviewNetWorthTitle,
          overviewPrimaryValue: MoneyFormatter.etb(s.netWealthEtb),
          overviewDueLabel: l.calcZakatDueLabel,
          overviewDueValue: MoneyFormatter.etb(s.estimatedZakatDueEtb),
        );
      case ZakatCategoryTab.livestock:
        final livestockCount = s.sheepOrGoats + s.cattle + s.camels;
        final summary = ZakatCalculatorStrings.livestockSummary(l, s);
        final transparency = ZakatCalculatorStrings.livestockTransparency(l, s);
        return ZakatPaymentArgs(
          activeTab: s.activeTab,
          amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
          overviewTitle: l.calcOverviewLivestockTitle,
          overviewPrimaryValue: l.calcAnimalsCount(livestockCount),
          overviewDueLabel: l.calcLivestockDueLabel,
          overviewDueValue: summary,
          livestockSummaryText: summary,
          livestockTransparencyText: transparency,
          certificateNaturalUnitLine: summary,
        );
      case ZakatCategoryTab.crops:
        final transparency = ZakatCalculatorStrings.cropTransparency(l, s);
        return ZakatPaymentArgs(
          activeTab: s.activeTab,
          amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
          overviewTitle: l.calcOverviewCropTitle,
          overviewPrimaryValue: l.calcKgHarvest(s.cropKg.toStringAsFixed(2)),
          overviewDueLabel: l.calcCropZakatDueLabel,
          overviewDueValue: '${s.cropZakatDueKg.toStringAsFixed(2)} kg',
          cropTransparencyText: transparency,
          certificateNaturalUnitLine:
              l.calcCertCropDueLine(s.cropZakatDueKg.toStringAsFixed(2)),
        );
    }
  }
}
