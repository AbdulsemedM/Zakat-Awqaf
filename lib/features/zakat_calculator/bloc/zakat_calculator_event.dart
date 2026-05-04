import 'package:equatable/equatable.dart';

import 'zakat_calculator_state.dart';

sealed class ZakatCalculatorEvent extends Equatable {
  const ZakatCalculatorEvent();

  @override
  List<Object?> get props => [];
}

final class ZakatCalculatorStarted extends ZakatCalculatorEvent {
  const ZakatCalculatorStarted();
}

final class ZakatCategoryTabChanged extends ZakatCalculatorEvent {
  const ZakatCategoryTabChanged(this.tab);
  final ZakatCategoryTab tab;
  @override
  List<Object?> get props => [tab];
}

final class WealthFieldsUpdated extends ZakatCalculatorEvent {
  const WealthFieldsUpdated({
    this.cashOnHand,
    this.bankBalance,
    this.mobileWallet,
    this.goldGrams,
    this.goldKarat,
    this.silverGrams,
  });

  final double? cashOnHand;
  final double? bankBalance;
  final double? mobileWallet;
  final double? goldGrams;
  final GoldKarat? goldKarat;
  final double? silverGrams;

  @override
  List<Object?> get props => [
    cashOnHand,
    bankBalance,
    mobileWallet,
    goldGrams,
    goldKarat,
    silverGrams,
  ];
}

final class BusinessAssetAdded extends ZakatCalculatorEvent {
  const BusinessAssetAdded();
}

final class BusinessAssetRemoved extends ZakatCalculatorEvent {
  const BusinessAssetRemoved(this.index);
  final int index;
  @override
  List<Object?> get props => [index];
}

final class BusinessAssetUpdated extends ZakatCalculatorEvent {
  const BusinessAssetUpdated({
    required this.index,
    this.description,
    this.type,
    this.amount,
  });
  final int index;
  final String? description;
  final BusinessAssetType? type;
  final double? amount;

  @override
  List<Object?> get props => [index, description, type, amount];
}

final class LiabilityAdded extends ZakatCalculatorEvent {
  const LiabilityAdded();
}

final class LiabilityRemoved extends ZakatCalculatorEvent {
  const LiabilityRemoved(this.index);
  final int index;
  @override
  List<Object?> get props => [index];
}

final class LiabilityUpdated extends ZakatCalculatorEvent {
  const LiabilityUpdated({
    required this.index,
    this.description,
    this.type,
    this.amount,
  });
  final int index;
  final String? description;
  final LiabilityType? type;
  final double? amount;

  @override
  List<Object?> get props => [index, description, type, amount];
}

final class LivestockFieldsUpdated extends ZakatCalculatorEvent {
  const LivestockFieldsUpdated({
    this.sheepOrGoats,
    this.cattle,
    this.camels,
    this.isPastureFedMostOfYear,
    this.completedHawl,
    this.usedForWork,
  });
  final int? sheepOrGoats;
  final int? cattle;
  final int? camels;
  final bool? isPastureFedMostOfYear;
  final bool? completedHawl;
  final bool? usedForWork;

  @override
  List<Object?> get props => [
    sheepOrGoats,
    cattle,
    camels,
    isPastureFedMostOfYear,
    completedHawl,
    usedForWork,
  ];
}

final class CropFieldsUpdated extends ZakatCalculatorEvent {
  const CropFieldsUpdated({
    this.cropKg,
    this.cropIrrigationMode,
    this.rainSharePercent,
    this.irrigatedSharePercent,
  });
  final double? cropKg;
  final CropIrrigationMode? cropIrrigationMode;
  final double? rainSharePercent;
  final double? irrigatedSharePercent;

  @override
  List<Object?> get props => [
    cropKg,
    cropIrrigationMode,
    rainSharePercent,
    irrigatedSharePercent,
  ];
}

final class RecomputeZakatRequested extends ZakatCalculatorEvent {
  const RecomputeZakatRequested();
}

final class PricingRefreshRequested extends ZakatCalculatorEvent {
  const PricingRefreshRequested({this.fromCalculate = false});
  final bool fromCalculate;

  @override
  List<Object?> get props => [fromCalculate];
}
