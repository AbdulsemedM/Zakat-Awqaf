import '../../../../core/common/utils/money_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../causes/data/models/cause.dart';
import '../../../zakat_calculator/bloc/zakat_calculator_state.dart';
import '../../../zakat_calculator/presentation/zakat_calculator_strings.dart';

enum ZakatAmountEntryMode { fixed, userEstimatedEtb }

/// What the payment screen is collecting; drives its wording.
enum PaymentPurpose { zakat, sadaqah }

/// Navigation extra for [`ZakatPaymentScreen`].
class ZakatPaymentArgs {
  const ZakatPaymentArgs({
    required this.activeTab,
    required this.amountEntryMode,
    this.fixedAmountEtb,
    this.overviewTitle,
    this.overviewPrimaryValue = '',
    this.overviewDueLabel = '',
    this.overviewDueValue = '',
    this.livestockSummaryText,
    this.livestockTransparencyText,
    this.cropTransparencyText,
    this.amountNote,
    this.certificateNaturalUnitLine,
    this.purpose = PaymentPurpose.zakat,
    this.configVersion,
    this.initialCauseId,
    this.initialCauseTitle,
  });

  final ZakatCategoryTab activeTab;
  final ZakatAmountEntryMode amountEntryMode;
  final double? fixedAmountEtb;

  /// Mirrors [`_TabOverviewCard`] conceptually; no overview card when `null`.
  final String? overviewTitle;
  final String overviewPrimaryValue;
  final String overviewDueLabel;
  final String overviewDueValue;

  final String? livestockSummaryText;
  final String? livestockTransparencyText;
  final String? cropTransparencyText;

  /// Shown under the amount, e.g. how a prefilled estimate was worked out.
  final String? amountNote;

  /// Optional one-line text for certificate PDF (livestock/crops natural units).
  final String? certificateNaturalUnitLine;

  final PaymentPurpose purpose;

  /// Calculator rules version that produced the amount; sent with the
  /// zakat payment so the backend knows which rules were used.
  final int? configVersion;

  /// Cause preselected in the project dropdown (e.g. from a cause card).
  final String? initialCauseId;
  final String? initialCauseTitle;

  static bool canOpenPayment(ZakatCalculatorInitial s) {
    switch (s.activeTab) {
      case ZakatCategoryTab.wealth:
        return s.aboveNisab && s.estimatedZakatDueEtb > 0;
      case ZakatCategoryTab.livestock:
        return s.livestockHasDue;
      case ZakatCategoryTab.crops:
        return s.cropAboveNisab && s.cropZakatDueKg > 0;
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

  /// Zakat for a cause picked on the home screen or the causes list.
  static ZakatPaymentArgs forCause(Cause cause) {
    return ZakatPaymentArgs(
      activeTab: ZakatCategoryTab.wealth,
      amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
      initialCauseId: cause.id,
      initialCauseTitle: cause.title,
    );
  }

  static ZakatPaymentArgs fromCalculator(
    AppLocalizations l,
    ZakatCalculatorInitial s,
  ) {
    final configVersion = s.config?.configVersion;
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
          configVersion: configVersion,
        );
      case ZakatCategoryTab.livestock:
        final livestockCount = s.sheepOrGoats + s.cattle + s.camels;
        final summary = ZakatCalculatorStrings.livestockSummary(l, s);
        final transparency = ZakatCalculatorStrings.livestockTransparency(l, s);
        final estimate = s.livestockHasDue
            ? s.livestockEstimatedValueEtb
            : null;
        return ZakatPaymentArgs(
          activeTab: s.activeTab,
          amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
          fixedAmountEtb: estimate,
          overviewTitle: l.calcOverviewLivestockTitle,
          overviewPrimaryValue: l.calcAnimalsCount(livestockCount),
          overviewDueLabel: l.calcLivestockDueLabel,
          overviewDueValue: summary,
          livestockSummaryText: summary,
          livestockTransparencyText: transparency,
          amountNote: estimate != null ? l.calcLivestockEstimateNote : null,
          certificateNaturalUnitLine: summary,
          configVersion: configVersion,
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
          certificateNaturalUnitLine: l.calcCertCropDueLine(
            s.cropZakatDueKg.toStringAsFixed(2),
          ),
          configVersion: configVersion,
        );
    }
  }
}
