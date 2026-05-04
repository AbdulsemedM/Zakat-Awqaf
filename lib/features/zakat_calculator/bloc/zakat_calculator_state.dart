import 'package:equatable/equatable.dart';
import '../data/repository/exchange_rate_repository_impl.dart';

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
    required this.camelZakatDueDescription,
    required this.livestockSummaryText,
    required this.livestockTransparencyText,
    required this.livestockAdvisoryText,
    required this.cropKg,
    required this.cropIrrigationMode,
    required this.rainSharePercent,
    required this.irrigatedSharePercent,
    required this.cropEffectiveRate,
    required this.cropZakatDueKg,
    required this.cropTransparencyText,
    required this.platformGoldPricePerGram24kEtb,
    required this.platformGoldPricePerGram22kEtb,
    required this.platformGoldPricePerGram21kEtb,
    required this.platformGoldPricePerGram18kEtb,
    required this.platformGoldPricePerGram14kEtb,
    required this.nisabThresholdEtb,
    required this.totalBusinessAssetsEtb,
    required this.totalLiabilitiesEtb,
    required this.goldValueEtb,
    required this.silverValueEtb,
    required this.totalWealthEtb,
    required this.netWealthEtb,
    required this.aboveNisab,
    required this.estimatedZakatDueEtb,
    required this.usdToEtbRate,
    this.rateTimestamp,
    required this.rateSource,
    required this.goldSeedTimestamp,
    required this.pricingStatusText,
    required this.isPricingLoading,
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
  final String camelZakatDueDescription;
  final String livestockSummaryText;
  final String livestockTransparencyText;
  final String livestockAdvisoryText;
  final double cropKg;
  final CropIrrigationMode cropIrrigationMode;
  final double rainSharePercent;
  final double irrigatedSharePercent;
  final double cropEffectiveRate;
  final double cropZakatDueKg;
  final String cropTransparencyText;

  final double platformGoldPricePerGram24kEtb;
  final double platformGoldPricePerGram22kEtb;
  final double platformGoldPricePerGram21kEtb;
  final double platformGoldPricePerGram18kEtb;
  final double platformGoldPricePerGram14kEtb;
  final double nisabThresholdEtb;

  final double totalBusinessAssetsEtb;
  final double totalLiabilitiesEtb;
  final double goldValueEtb;
  final double silverValueEtb;
  final double totalWealthEtb;
  final double netWealthEtb;
  final bool aboveNisab;
  final double estimatedZakatDueEtb;
  final double usdToEtbRate;
  final DateTime? rateTimestamp;
  final FxRateSource rateSource;
  final int goldSeedTimestamp;
  final String pricingStatusText;
  final bool isPricingLoading;

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
    camelZakatDueDescription,
    livestockSummaryText,
    livestockTransparencyText,
    livestockAdvisoryText,
    cropKg,
    cropIrrigationMode,
    rainSharePercent,
    irrigatedSharePercent,
    cropEffectiveRate,
    cropZakatDueKg,
    cropTransparencyText,
    platformGoldPricePerGram24kEtb,
    platformGoldPricePerGram22kEtb,
    platformGoldPricePerGram21kEtb,
    platformGoldPricePerGram18kEtb,
    platformGoldPricePerGram14kEtb,
    nisabThresholdEtb,
    totalBusinessAssetsEtb,
    totalLiabilitiesEtb,
    goldValueEtb,
    silverValueEtb,
    totalWealthEtb,
    netWealthEtb,
    aboveNisab,
    estimatedZakatDueEtb,
    usdToEtbRate,
    rateTimestamp,
    rateSource,
    goldSeedTimestamp,
    pricingStatusText,
    isPricingLoading,
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
    super.camelZakatDueDescription = 'No due',
    super.livestockSummaryText = 'No livestock due',
    super.livestockTransparencyText = '',
    super.livestockAdvisoryText = '',
    super.cropKg = 0,
    super.cropIrrigationMode = CropIrrigationMode.rainFed,
    super.rainSharePercent = 50,
    super.irrigatedSharePercent = 50,
    super.cropEffectiveRate = 0.10,
    super.cropZakatDueKg = 0,
    super.cropTransparencyText = '',
    super.platformGoldPricePerGram24kEtb = 4165.0,
    super.platformGoldPricePerGram22kEtb = 3818.8,
    super.platformGoldPricePerGram21kEtb = 3645.2,
    super.platformGoldPricePerGram18kEtb = 3120.0,
    super.platformGoldPricePerGram14kEtb = 2426.8,
    super.nisabThresholdEtb = 354025.0,
    super.totalBusinessAssetsEtb = 0,
    super.totalLiabilitiesEtb = 0,
    super.goldValueEtb = 0,
    super.silverValueEtb = 0,
    super.totalWealthEtb = 0,
    super.netWealthEtb = 0,
    super.aboveNisab = false,
    super.estimatedZakatDueEtb = 0,
    super.usdToEtbRate = 156.183869,
    super.rateTimestamp,
    super.rateSource = FxRateSource.fallback,
    super.goldSeedTimestamp = 1777883649,
    super.pricingStatusText = 'Using fallback FX rate',
    super.isPricingLoading = false,
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
    String? camelZakatDueDescription,
    String? livestockSummaryText,
    String? livestockTransparencyText,
    String? livestockAdvisoryText,
    double? cropKg,
    CropIrrigationMode? cropIrrigationMode,
    double? rainSharePercent,
    double? irrigatedSharePercent,
    double? cropEffectiveRate,
    double? cropZakatDueKg,
    String? cropTransparencyText,
    double? platformGoldPricePerGram24kEtb,
    double? platformGoldPricePerGram22kEtb,
    double? platformGoldPricePerGram21kEtb,
    double? platformGoldPricePerGram18kEtb,
    double? platformGoldPricePerGram14kEtb,
    double? nisabThresholdEtb,
    double? totalBusinessAssetsEtb,
    double? totalLiabilitiesEtb,
    double? goldValueEtb,
    double? silverValueEtb,
    double? totalWealthEtb,
    double? netWealthEtb,
    bool? aboveNisab,
    double? estimatedZakatDueEtb,
    double? usdToEtbRate,
    DateTime? rateTimestamp,
    FxRateSource? rateSource,
    int? goldSeedTimestamp,
    String? pricingStatusText,
    bool? isPricingLoading,
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
      isPastureFedMostOfYear: isPastureFedMostOfYear ?? this.isPastureFedMostOfYear,
      completedHawl: completedHawl ?? this.completedHawl,
      usedForWork: usedForWork ?? this.usedForWork,
      sheepZakatDueCount: sheepZakatDueCount ?? this.sheepZakatDueCount,
      cattleTabiDueCount: cattleTabiDueCount ?? this.cattleTabiDueCount,
      cattleMusinnahDueCount: cattleMusinnahDueCount ?? this.cattleMusinnahDueCount,
      camelZakatDueDescription: camelZakatDueDescription ?? this.camelZakatDueDescription,
      livestockSummaryText: livestockSummaryText ?? this.livestockSummaryText,
      livestockTransparencyText: livestockTransparencyText ?? this.livestockTransparencyText,
      livestockAdvisoryText: livestockAdvisoryText ?? this.livestockAdvisoryText,
      cropKg: cropKg ?? this.cropKg,
      cropIrrigationMode: cropIrrigationMode ?? this.cropIrrigationMode,
      rainSharePercent: rainSharePercent ?? this.rainSharePercent,
      irrigatedSharePercent: irrigatedSharePercent ?? this.irrigatedSharePercent,
      cropEffectiveRate: cropEffectiveRate ?? this.cropEffectiveRate,
      cropZakatDueKg: cropZakatDueKg ?? this.cropZakatDueKg,
      cropTransparencyText: cropTransparencyText ?? this.cropTransparencyText,
      platformGoldPricePerGram24kEtb:
          platformGoldPricePerGram24kEtb ?? this.platformGoldPricePerGram24kEtb,
      platformGoldPricePerGram22kEtb:
          platformGoldPricePerGram22kEtb ?? this.platformGoldPricePerGram22kEtb,
      platformGoldPricePerGram21kEtb:
          platformGoldPricePerGram21kEtb ?? this.platformGoldPricePerGram21kEtb,
      platformGoldPricePerGram18kEtb:
          platformGoldPricePerGram18kEtb ?? this.platformGoldPricePerGram18kEtb,
      platformGoldPricePerGram14kEtb:
          platformGoldPricePerGram14kEtb ?? this.platformGoldPricePerGram14kEtb,
      nisabThresholdEtb: nisabThresholdEtb ?? this.nisabThresholdEtb,
      totalBusinessAssetsEtb: totalBusinessAssetsEtb ?? this.totalBusinessAssetsEtb,
      totalLiabilitiesEtb: totalLiabilitiesEtb ?? this.totalLiabilitiesEtb,
      goldValueEtb: goldValueEtb ?? this.goldValueEtb,
      silverValueEtb: silverValueEtb ?? this.silverValueEtb,
      totalWealthEtb: totalWealthEtb ?? this.totalWealthEtb,
      netWealthEtb: netWealthEtb ?? this.netWealthEtb,
      aboveNisab: aboveNisab ?? this.aboveNisab,
      estimatedZakatDueEtb: estimatedZakatDueEtb ?? this.estimatedZakatDueEtb,
      usdToEtbRate: usdToEtbRate ?? this.usdToEtbRate,
      rateTimestamp: rateTimestamp ?? this.rateTimestamp,
      rateSource: rateSource ?? this.rateSource,
      goldSeedTimestamp: goldSeedTimestamp ?? this.goldSeedTimestamp,
      pricingStatusText: pricingStatusText ?? this.pricingStatusText,
      isPricingLoading: isPricingLoading ?? this.isPricingLoading,
    );
  }
}
