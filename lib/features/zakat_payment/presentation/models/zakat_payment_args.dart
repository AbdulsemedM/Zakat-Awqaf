import '../../../../core/common/utils/money_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_en.dart';
import '../../../causes/data/models/cause.dart';
import '../../../home/data/models/zakat_al_fitr_season.dart';
import '../../../zakat_calculator/bloc/zakat_calculator_state.dart';
import '../../../zakat_calculator/presentation/zakat_calculator_strings.dart';
import '../../data/models/zakat_payment_models.dart';

enum ZakatAmountEntryMode { fixed, userEstimatedEtb }

/// Navigation extra for [`ZakatPaymentScreen`].
class ZakatPaymentArgs {
  const ZakatPaymentArgs({
    required this.zakatType,
    required this.activeTab,
    required this.amountEntryMode,
    this.fixedAmountEtb,
    this.overviewTitle,
    this.overviewPrimaryValue = '',
    this.overviewDueLabel = '',
    this.overviewDueValue = '',
    this.livestockTransparencyText,
    this.cropTransparencyText,
    this.amountNote,
    this.calculation,
    this.initialCauseId,
    this.initialCauseTitle,
  });

  /// Sent as `zakatType`.
  final ZakatType zakatType;

  /// Drives the screen's wording (natural units note, amount hint).
  final ZakatCategoryTab activeTab;
  final ZakatAmountEntryMode amountEntryMode;
  final double? fixedAmountEtb;

  /// Mirrors [`_TabOverviewCard`] conceptually; no overview card when `null`.
  final String? overviewTitle;
  final String overviewPrimaryValue;
  final String overviewDueLabel;
  final String overviewDueValue;

  final String? livestockTransparencyText;
  final String? cropTransparencyText;

  /// Shown under the amount, e.g. how a prefilled estimate was worked out.
  final String? amountNote;

  /// Sent as `calculation` with the payment. `naturalUnitSummary` in it is
  /// printed on the certificate, so it is always English (the PDF cannot
  /// render Ethiopic or Arabic yet).
  final Map<String, dynamic>? calculation;

  /// Cause preselected in the project dropdown (e.g. from a cause card).
  final String? initialCauseId;
  final String? initialCauseTitle;

  /// Zakat for a cause picked on the home screen or the causes list:
  /// `zakatType: general`, no calculation.
  static ZakatPaymentArgs forCause(Cause cause) {
    return ZakatPaymentArgs(
      zakatType: ZakatType.general,
      activeTab: ZakatCategoryTab.wealth,
      amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
      initialCauseId: cause.id,
      initialCauseTitle: cause.title,
    );
  }

  /// Zakat al-Fitr for [householdSize] people at the season's amount.
  static ZakatPaymentArgs forFitr(
    AppLocalizations l,
    ZakatAlFitrSeason season,
    int householdSize,
  ) {
    final amount = householdSize * season.perPersonAmountEtb;
    return ZakatPaymentArgs(
      zakatType: ZakatType.fitr,
      activeTab: ZakatCategoryTab.wealth,
      amountEntryMode: ZakatAmountEntryMode.fixed,
      fixedAmountEtb: amount,
      overviewTitle: l.zakatAlFitr,
      overviewPrimaryValue: l.fitrHouseholdOf(householdSize),
      overviewDueLabel: l.calcZakatDueLabel,
      overviewDueValue: MoneyFormatter.etb(amount),
      calculation: {
        'householdSize': householdSize,
        'perPersonAmountEtb': season.perPersonAmountEtb,
        'naturalUnitSummary':
            'Zakat al-Fitr for $householdSize '
            '${householdSize == 1 ? 'person' : 'persons'}',
      },
    );
  }

  static ZakatPaymentArgs fromCalculator(
    AppLocalizations l,
    ZakatCalculatorInitial s,
  ) {
    final configVersion = s.config?.configVersion;
    final en = AppLocalizationsEn();
    switch (s.activeTab) {
      case ZakatCategoryTab.wealth:
        return ZakatPaymentArgs(
          zakatType: ZakatType.wealth,
          activeTab: s.activeTab,
          amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
          fixedAmountEtb: s.estimatedZakatDueEtb,
          overviewTitle: l.calcOverviewNetWorthTitle,
          overviewPrimaryValue: MoneyFormatter.etb(s.netWealthEtb),
          overviewDueLabel: l.calcZakatDueLabel,
          overviewDueValue: MoneyFormatter.etb(s.estimatedZakatDueEtb),
          calculation: {
            'configVersion': ?configVersion,
            'zakatableEtb': double.parse(s.netWealthEtb.toStringAsFixed(2)),
            'nisabEtb': s.nisabThresholdEtb,
            'amountIsMarketEstimate': false,
          },
        );
      case ZakatCategoryTab.livestock:
        final livestockCount = s.sheepOrGoats + s.cattle + s.camels;
        final summary = ZakatCalculatorStrings.livestockSummary(l, s);
        final transparency = ZakatCalculatorStrings.livestockTransparency(l, s);
        final estimate = s.livestockHasDue
            ? s.livestockEstimatedValueEtb
            : null;
        return ZakatPaymentArgs(
          zakatType: ZakatType.livestock,
          activeTab: s.activeTab,
          amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
          fixedAmountEtb: estimate,
          overviewTitle: l.calcOverviewLivestockTitle,
          overviewPrimaryValue: l.calcAnimalsCount(livestockCount),
          overviewDueLabel: l.calcLivestockDueLabel,
          overviewDueValue: summary,
          livestockTransparencyText: transparency,
          amountNote: estimate != null ? l.calcLivestockEstimateNote : null,
          calculation: {
            'configVersion': ?configVersion,
            'naturalUnitSummary': ZakatCalculatorStrings.livestockSummary(
              en,
              s,
            ),
            'amountIsMarketEstimate': true,
          },
        );
      case ZakatCategoryTab.crops:
        final transparency = ZakatCalculatorStrings.cropTransparency(l, s);
        final dueKg = s.cropZakatDueKg.toStringAsFixed(2);
        return ZakatPaymentArgs(
          zakatType: ZakatType.crops,
          activeTab: s.activeTab,
          amountEntryMode: ZakatAmountEntryMode.userEstimatedEtb,
          overviewTitle: l.calcOverviewCropTitle,
          overviewPrimaryValue: l.calcKgHarvest(s.cropKg.toStringAsFixed(2)),
          overviewDueLabel: l.calcCropZakatDueLabel,
          overviewDueValue: '$dueKg kg',
          cropTransparencyText: transparency,
          calculation: {
            'configVersion': ?configVersion,
            'naturalUnitSummary': en.calcCertCropDueLine(dueKg),
            'amountIsMarketEstimate': true,
          },
        );
    }
  }
}
