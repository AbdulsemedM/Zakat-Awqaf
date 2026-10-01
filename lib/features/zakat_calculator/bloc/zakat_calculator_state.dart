import 'package:equatable/equatable.dart';

import '../data/models/calculator_config.dart';
import '../data/zakat_rules.dart';

enum ZakatCategoryTab { wealth, livestock, crops }

enum GoldKarat {
  k24(purity: 1.0, label: '24k'),
  k22(purity: 22 / 24, label: '22k'),
  k21(purity: 21 / 24, label: '21k'),
  k18(purity: 18 / 24, label: '18k'),
  k14(purity: 14 / 24, label: '14k');

  const GoldKarat({required this.purity, required this.label});
  final double purity;
  final String label;
}

enum BusinessAssetType { inventory, receivable, other }

enum LiabilityType { shortTermDebt, payable, other }

enum CropIrrigationMode { rainFed, irrigated, mixed }

/// Where the calculator config (prices + rules) stands.
enum CalculatorConfigStatus { loading, ready, failed }

class BusinessAssetItem extends Equatable {
  const BusinessAssetItem({
    this.description = '',
    this.type = BusinessAssetType.other,
    this.amount = 0,
  });

  final String description;
  final BusinessAssetType type;
  final double amount;

  BusinessAssetItem copyWith({
    String? description,
    BusinessAssetType? type,
    double? amount,
  }) {
    return BusinessAssetItem(
      description: description ?? this.description,
      type: type ?? this.type,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [description, type, amount];
}

class LiabilityItem extends Equatable {
  const LiabilityItem({
    this.description = '',
    this.type = LiabilityType.other,
    this.amount = 0,
  });

  final String description;
  final LiabilityType type;
  final double amount;

  LiabilityItem copyWith({
    String? description,
    LiabilityType? type,
    double? amount,
  }) {
    return LiabilityItem(
      description: description ?? this.description,
      type: type ?? this.type,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [description, type, amount];
}

sealed class ZakatCalculatorState extends Equatable {
  const ZakatCalculatorState({
    required this.activeTab,
    required this.cashOnHand,
    required this.bankBalance,
    required this.mobileWallet,
    required this.goldGrams,
    required this.goldKarat,
    required this.silverGrams,
    required this.businessAssets,
    required this.liabilities,
    required this.sheepOrGoats,
    required this.cattle,
    required this.camels,
    required this.isPastureFedMostOfYear,
    required this.completedHawl,
    required this.usedForWork,
    required this.sheepZakatDueCount,
    required this.cattleTabiDueCount,
    required this.cattleMusinnahDueCount,
    required this.camelDue,
    this.livestockEstimatedValueEtb,
    required this.cropKg,
    required this.cropIrrigationMode,
    required this.rainSharePercent,
    required this.irrigatedSharePercent,
    required this.cropEffectiveRate,
    required this.cropZakatDueKg,
    required this.goldPricePerGramEtb,
    required this.nisabThresholdEtb,
    required this.totalBusinessAssetsEtb,
    required this.totalLiabilitiesEtb,
    required this.goldValueEtb,
    required this.silverValueEtb,
    required this.totalWealthEtb,
    required this.netWealthEtb,
    required this.aboveNisab,
    required this.estimatedZakatDueEtb,
    this.config,
    required this.configStatus,
    required this.configFromCache,
    required this.configRefreshFailed,
    required this.configNotReady,
  });

  final ZakatCategoryTab activeTab;
  final double cashOnHand;
  final double bankBalance;
  final double mobileWallet;
  final double goldGrams;
  final GoldKarat goldKarat;
  final double silverGrams;
  final List<BusinessAssetItem> businessAssets;
  final List<LiabilityItem> liabilities;

  final int sheepOrGoats;
  final int cattle;
  final int camels;
  final bool isPastureFedMostOfYear;
  final bool completedHawl;
  final bool usedForWork;
  final int sheepZakatDueCount;
  final int cattleTabiDueCount;
  final int cattleMusinnahDueCount;
  final CamelDue camelDue;

  /// Market value of the livestock due at the config's average unit prices.
  final double? livestockEstimatedValueEtb;
  final double cropKg;
  final CropIrrigationMode cropIrrigationMode;
  final double rainSharePercent;
  final double irrigatedSharePercent;
  final double cropEffectiveRate;
  final double cropZakatDueKg;

  /// Price per gram for the selected [goldKarat].
  final double goldPricePerGramEtb;
  final double nisabThresholdEtb;

  final double totalBusinessAssetsEtb;
  final double totalLiabilitiesEtb;
  final double goldValueEtb;
  final double silverValueEtb;
  final double totalWealthEtb;
  final double netWealthEtb;
  final bool aboveNisab;
  final double estimatedZakatDueEtb;

  /// Prices and rules; `null` until loaded (from the server or the cache).
  final CalculatorConfig? config;
  final CalculatorConfigStatus configStatus;

  /// [config] is the copy saved on the device, not a fresh one.
  final bool configFromCache;

  /// The last refresh failed and [config] is the saved copy.
  final bool configRefreshFailed;

  /// The server has no prices yet (503).
  final bool configNotReady;

  bool get livestockHasDue =>
      sheepZakatDueCount > 0 ||
      cattleTabiDueCount > 0 ||
      cattleMusinnahDueCount > 0 ||
      camelDue.hasDue;

  bool get cropAboveNisab => config != null && cropKg >= config!.crops.nisabKg;

  @override
  List<Object?> get props => [
    activeTab,
    cashOnHand,
    bankBalance,
    mobileWallet,
    goldGrams,
    goldKarat,
    silverGrams,
    businessAssets,
    liabilities,
    sheepOrGoats,
    cattle,
    camels,
    isPastureFedMostOfYear,
    completedHawl,
    usedForWork,
    sheepZakatDueCount,
    cattleTabiDueCount,
    cattleMusinnahDueCount,
    camelDue,
    livestockEstimatedValueEtb,
    cropKg,
    cropIrrigationMode,
    rainSharePercent,
    irrigatedSharePercent,
    cropEffectiveRate,
    cropZakatDueKg,
    goldPricePerGramEtb,
    nisabThresholdEtb,
    totalBusinessAssetsEtb,
    totalLiabilitiesEtb,
    goldValueEtb,
    silverValueEtb,
    totalWealthEtb,
    netWealthEtb,
    aboveNisab,
    estimatedZakatDueEtb,
    config,
    configStatus,
    configFromCache,
    configRefreshFailed,
    configNotReady,
  ];
}

final class ZakatCalculatorInitial extends ZakatCalculatorState {
  const ZakatCalculatorInitial({
    super.activeTab = ZakatCategoryTab.wealth,
    super.cashOnHand = 0,
    super.bankBalance = 0,
    super.mobileWallet = 0,
    super.goldGrams = 0,
    super.goldKarat = GoldKarat.k24,
    super.silverGrams = 0,
    super.businessAssets = const [],
    super.liabilities = const [],
    super.sheepOrGoats = 0,
    super.cattle = 0,
    super.camels = 0,
    super.isPastureFedMostOfYear = true,
    super.completedHawl = true,
    super.usedForWork = false,
    super.sheepZakatDueCount = 0,
    super.cattleTabiDueCount = 0,
    super.cattleMusinnahDueCount = 0,
    super.camelDue = CamelDue.none,
    super.livestockEstimatedValueEtb,
    super.cropKg = 0,
    super.cropIrrigationMode = CropIrrigationMode.rainFed,
    super.rainSharePercent = 50,
    super.irrigatedSharePercent = 50,
    super.cropEffectiveRate = 0,
    super.cropZakatDueKg = 0,
    super.goldPricePerGramEtb = 0,
    super.nisabThresholdEtb = 0,
    super.totalBusinessAssetsEtb = 0,
    super.totalLiabilitiesEtb = 0,
    super.goldValueEtb = 0,
    super.silverValueEtb = 0,
    super.totalWealthEtb = 0,
    super.netWealthEtb = 0,
    super.aboveNisab = false,
    super.estimatedZakatDueEtb = 0,
    super.config,
    super.configStatus = CalculatorConfigStatus.loading,
    super.configFromCache = false,
    super.configRefreshFailed = false,
    super.configNotReady = false,
  });

  ZakatCalculatorInitial copyWith({
    ZakatCategoryTab? activeTab,
    double? cashOnHand,
    double? bankBalance,
    double? mobileWallet,
    double? goldGrams,
    GoldKarat? goldKarat,
    double? silverGrams,
    List<BusinessAssetItem>? businessAssets,
    List<LiabilityItem>? liabilities,
    int? sheepOrGoats,
    int? cattle,
    int? camels,
    bool? isPastureFedMostOfYear,
    bool? completedHawl,
    bool? usedForWork,
    int? sheepZakatDueCount,
    int? cattleTabiDueCount,
    int? cattleMusinnahDueCount,
    CamelDue? camelDue,
    double? Function()? livestockEstimatedValueEtb,
    double? cropKg,
    CropIrrigationMode? cropIrrigationMode,
    double? rainSharePercent,
    double? irrigatedSharePercent,
    double? cropEffectiveRate,
    double? cropZakatDueKg,
    double? goldPricePerGramEtb,
    double? nisabThresholdEtb,
    double? totalBusinessAssetsEtb,
    double? totalLiabilitiesEtb,
    double? goldValueEtb,
    double? silverValueEtb,
    double? totalWealthEtb,
    double? netWealthEtb,
    bool? aboveNisab,
    double? estimatedZakatDueEtb,
    CalculatorConfig? config,
    CalculatorConfigStatus? configStatus,
    bool? configFromCache,
    bool? configRefreshFailed,
    bool? configNotReady,
  }) {
    return ZakatCalculatorInitial(
      activeTab: activeTab ?? this.activeTab,
      cashOnHand: cashOnHand ?? this.cashOnHand,
      bankBalance: bankBalance ?? this.bankBalance,
      mobileWallet: mobileWallet ?? this.mobileWallet,
      goldGrams: goldGrams ?? this.goldGrams,
      goldKarat: goldKarat ?? this.goldKarat,
      silverGrams: silverGrams ?? this.silverGrams,
      businessAssets: businessAssets ?? this.businessAssets,
      liabilities: liabilities ?? this.liabilities,
      sheepOrGoats: sheepOrGoats ?? this.sheepOrGoats,
      cattle: cattle ?? this.cattle,
      camels: camels ?? this.camels,
      isPastureFedMostOfYear:
          isPastureFedMostOfYear ?? this.isPastureFedMostOfYear,
      completedHawl: completedHawl ?? this.completedHawl,
      usedForWork: usedForWork ?? this.usedForWork,
      sheepZakatDueCount: sheepZakatDueCount ?? this.sheepZakatDueCount,
      cattleTabiDueCount: cattleTabiDueCount ?? this.cattleTabiDueCount,
      cattleMusinnahDueCount:
          cattleMusinnahDueCount ?? this.cattleMusinnahDueCount,
      camelDue: camelDue ?? this.camelDue,
      livestockEstimatedValueEtb: livestockEstimatedValueEtb != null
          ? livestockEstimatedValueEtb()
          : this.livestockEstimatedValueEtb,
      cropKg: cropKg ?? this.cropKg,
      cropIrrigationMode: cropIrrigationMode ?? this.cropIrrigationMode,
      rainSharePercent: rainSharePercent ?? this.rainSharePercent,
      irrigatedSharePercent:
          irrigatedSharePercent ?? this.irrigatedSharePercent,
      cropEffectiveRate: cropEffectiveRate ?? this.cropEffectiveRate,
      cropZakatDueKg: cropZakatDueKg ?? this.cropZakatDueKg,
      goldPricePerGramEtb: goldPricePerGramEtb ?? this.goldPricePerGramEtb,
      nisabThresholdEtb: nisabThresholdEtb ?? this.nisabThresholdEtb,
      totalBusinessAssetsEtb:
          totalBusinessAssetsEtb ?? this.totalBusinessAssetsEtb,
      totalLiabilitiesEtb: totalLiabilitiesEtb ?? this.totalLiabilitiesEtb,
      goldValueEtb: goldValueEtb ?? this.goldValueEtb,
      silverValueEtb: silverValueEtb ?? this.silverValueEtb,
      totalWealthEtb: totalWealthEtb ?? this.totalWealthEtb,
      netWealthEtb: netWealthEtb ?? this.netWealthEtb,
      aboveNisab: aboveNisab ?? this.aboveNisab,
      estimatedZakatDueEtb: estimatedZakatDueEtb ?? this.estimatedZakatDueEtb,
      config: config ?? this.config,
      configStatus: configStatus ?? this.configStatus,
      configFromCache: configFromCache ?? this.configFromCache,
      configRefreshFailed: configRefreshFailed ?? this.configRefreshFailed,
      configNotReady: configNotReady ?? this.configNotReady,
    );
  }
}
