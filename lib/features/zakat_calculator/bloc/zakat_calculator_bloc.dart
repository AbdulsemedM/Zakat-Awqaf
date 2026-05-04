import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/data_provider/zakat_local_data_provider.dart';
import '../data/data_provider/zakat_remote_data_provider.dart';
import '../data/repository/exchange_rate_repository_impl.dart';
import '../data/repository/mock_gold_price_repository.dart';
import 'zakat_calculator_event.dart';
import 'zakat_calculator_state.dart';

class ZakatCalculatorBloc extends Bloc<ZakatCalculatorEvent, ZakatCalculatorState> {
  ZakatCalculatorBloc({
    GoldPriceRepository? goldRepository,
    ExchangeRateRepository? exchangeRateRepository,
  }) : _goldRepository = goldRepository ?? const SeededGoldPriceRepository(),
       _exchangeRateRepository =
           exchangeRateRepository ??
           ExchangeRateRepositoryImpl(
             remote: ZakatRemoteDataProviderImpl(),
             local: InMemoryZakatLocalDataProvider(),
           ),
       super(ZakatCalculatorInitial()) {
    on<ZakatCalculatorStarted>(_onStarted);
    on<ZakatCategoryTabChanged>(_onTabChanged);
    on<WealthFieldsUpdated>(_onWealthChanged);
    on<BusinessAssetAdded>(_onBusinessAssetAdded);
    on<BusinessAssetRemoved>(_onBusinessAssetRemoved);
    on<BusinessAssetUpdated>(_onBusinessAssetUpdated);
    on<LiabilityAdded>(_onLiabilityAdded);
    on<LiabilityRemoved>(_onLiabilityRemoved);
    on<LiabilityUpdated>(_onLiabilityUpdated);
    on<LivestockFieldsUpdated>(_onLivestockChanged);
    on<CropFieldsUpdated>(_onCropChanged);
    on<RecomputeZakatRequested>(_onRecomputeRequested);
    on<PricingRefreshRequested>(_onPricingRefreshRequested);
  }

  final GoldPriceRepository _goldRepository;
  final ExchangeRateRepository _exchangeRateRepository;

  ZakatCalculatorInitial get _current =>
      state is ZakatCalculatorInitial
      ? state as ZakatCalculatorInitial
      : ZakatCalculatorInitial();

  Future<void> _onStarted(
    ZakatCalculatorStarted event,
    Emitter<ZakatCalculatorState> emit,
  ) async {
    await _refreshPricingAndRecompute(emit, ZakatCalculatorInitial());
  }

  void _onTabChanged(
    ZakatCategoryTabChanged event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    emit(_current.copyWith(activeTab: event.tab));
  }

  void _onWealthChanged(
    WealthFieldsUpdated event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    emit(
      _recompute(
        _current.copyWith(
          cashOnHand: event.cashOnHand,
          bankBalance: event.bankBalance,
          mobileWallet: event.mobileWallet,
          goldGrams: event.goldGrams,
          goldKarat: event.goldKarat,
          silverGrams: event.silverGrams,
        ),
      ),
    );
  }

  void _onBusinessAssetAdded(
    BusinessAssetAdded event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    final items = [..._current.businessAssets, const BusinessAssetItem()];
    emit(_recompute(_current.copyWith(businessAssets: items)));
  }

  void _onBusinessAssetRemoved(
    BusinessAssetRemoved event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    final items = [..._current.businessAssets];
    if (event.index < 0 || event.index >= items.length) return;
    items.removeAt(event.index);
    emit(_recompute(_current.copyWith(businessAssets: items)));
  }

  void _onBusinessAssetUpdated(
    BusinessAssetUpdated event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    final items = [..._current.businessAssets];
    if (event.index < 0 || event.index >= items.length) return;
    items[event.index] = items[event.index].copyWith(
      description: event.description,
      type: event.type,
      amount: event.amount,
    );
    emit(_recompute(_current.copyWith(businessAssets: items)));
  }

  void _onLiabilityAdded(
    LiabilityAdded event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    final items = [..._current.liabilities, const LiabilityItem()];
    emit(_recompute(_current.copyWith(liabilities: items)));
  }

  void _onLiabilityRemoved(
    LiabilityRemoved event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    final items = [..._current.liabilities];
    if (event.index < 0 || event.index >= items.length) return;
    items.removeAt(event.index);
    emit(_recompute(_current.copyWith(liabilities: items)));
  }

  void _onLiabilityUpdated(
    LiabilityUpdated event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    final items = [..._current.liabilities];
    if (event.index < 0 || event.index >= items.length) return;
    items[event.index] = items[event.index].copyWith(
      description: event.description,
      type: event.type,
      amount: event.amount,
    );
    emit(_recompute(_current.copyWith(liabilities: items)));
  }

  void _onLivestockChanged(
    LivestockFieldsUpdated event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    emit(
      _recompute(
        _current.copyWith(
          sheepOrGoats: event.sheepOrGoats,
          cattle: event.cattle,
          camels: event.camels,
          isPastureFedMostOfYear: event.isPastureFedMostOfYear,
          completedHawl: event.completedHawl,
          usedForWork: event.usedForWork,
        ),
      ),
    );
  }

  void _onCropChanged(
    CropFieldsUpdated event,
    Emitter<ZakatCalculatorState> emit,
  ) {
    emit(
      _recompute(
        _current.copyWith(
          cropKg: event.cropKg,
          cropIrrigationMode: event.cropIrrigationMode,
          rainSharePercent: event.rainSharePercent,
          irrigatedSharePercent: event.irrigatedSharePercent,
        ),
      ),
    );
  }

  Future<void> _onRecomputeRequested(
    RecomputeZakatRequested event,
    Emitter<ZakatCalculatorState> emit,
  ) async {
    await _refreshPricingAndRecompute(emit, _current);
  }

  Future<void> _onPricingRefreshRequested(
    PricingRefreshRequested event,
    Emitter<ZakatCalculatorState> emit,
  ) async {
    await _refreshPricingAndRecompute(emit, _current);
  }

  Future<void> _refreshPricingAndRecompute(
    Emitter<ZakatCalculatorState> emit,
    ZakatCalculatorInitial base,
  ) async {
    emit(base.copyWith(isPricingLoading: true));

    final goldModel = await _goldRepository.getGoldPriceModel();
    final fx = await _exchangeRateRepository.getUsdToEtbRate();

    emit(
      _recompute(
        base.copyWith(
          usdToEtbRate: fx.rate,
          rateTimestamp: fx.timestamp,
          rateSource: fx.source,
          goldSeedTimestamp: goldModel.timestamp,
          pricingStatusText: _sourceText(fx.source),
          platformGoldPricePerGram24kEtb: goldModel.priceGram24k * fx.rate,
          platformGoldPricePerGram22kEtb: goldModel.priceGram22k * fx.rate,
          platformGoldPricePerGram21kEtb: goldModel.priceGram21k * fx.rate,
          platformGoldPricePerGram18kEtb: goldModel.priceGram18k * fx.rate,
          platformGoldPricePerGram14kEtb: goldModel.priceGram14k * fx.rate,
          isPricingLoading: false,
        ),
      ),
    );
  }

  ZakatCalculatorInitial _recompute(ZakatCalculatorInitial current) {
    const silverPricePerGramEtb = 50.0;
    const nisabGoldGrams = 85.0;
    const cropNisabKg = 653.0;
    final selectedGoldPriceEtb = switch (current.goldKarat) {
      GoldKarat.k24 => current.platformGoldPricePerGram24kEtb,
      GoldKarat.k22 => current.platformGoldPricePerGram22kEtb,
      GoldKarat.k21 => current.platformGoldPricePerGram21kEtb,
      GoldKarat.k18 => current.platformGoldPricePerGram18kEtb,
      GoldKarat.k14 => current.platformGoldPricePerGram14kEtb,
    };

    final totalBusinessAssets = current.businessAssets.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final totalLiabilities = current.liabilities.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    final goldValue =
        current.goldGrams *
        selectedGoldPriceEtb;
    final silverValue = current.silverGrams * silverPricePerGramEtb;

    final nisabThreshold = nisabGoldGrams * current.platformGoldPricePerGram24kEtb;

    final totalWealth =
        current.cashOnHand +
        current.bankBalance +
        current.mobileWallet +
        totalBusinessAssets +
        goldValue +
        silverValue;
    final netWealth = totalWealth - totalLiabilities;
    final aboveNisab = netWealth >= nisabThreshold;
    final estimatedDue = aboveNisab ? netWealth * 0.025 : 0.0;
    final sheepDue = _calculateSheepDue(current.sheepOrGoats);
    final cattleDue = _calculateCattleDue(current.cattle);
    final camelDue = _calculateCamelDue(current.camels);
    final livestockSummary = [
      if (sheepDue > 0) 'Sheep/Goats: $sheepDue sheep',
      if (cattleDue.$1 > 0 || cattleDue.$2 > 0)
        'Cattle: ${cattleDue.$1} tabi\' + ${cattleDue.$2} musinnah',
      if (camelDue != 'No due') 'Camels: $camelDue',
      if (sheepDue == 0 &&
          cattleDue.$1 == 0 &&
          cattleDue.$2 == 0 &&
          camelDue == 'No due')
        'No livestock due under current counts',
    ].join(' • ');
    final livestockAdvisories = [
      if (!current.isPastureFedMostOfYear)
        'Not pasture-fed most of the year: check trade/business treatment with scholars.',
      if (!current.completedHawl)
        'Hawl not completed: many scholars require one lunar year for livestock zakat.',
      if (current.usedForWork)
        'Work animals are typically exempt from livestock zakat.',
    ].join(' ');
    final livestockTransparency = [
      'Sheep/Goats threshold: ${current.sheepOrGoats} >= 40 => due $sheepDue sheep.',
      'Cattle threshold: ${current.cattle} >= 30 => due ${cattleDue.$1} tabi\', ${cattleDue.$2} musinnah (30/40 combination).',
      'Camel threshold: ${current.camels} >= 5 => due $camelDue.',
      if (livestockAdvisories.isNotEmpty) 'Advisory: $livestockAdvisories',
    ].join('\n');

    final boundedRain = current.rainSharePercent.clamp(0, 100).toDouble();
    final boundedIrrigated = current.irrigatedSharePercent.clamp(0, 100).toDouble();
    final normalized = (boundedRain + boundedIrrigated) == 0 ? 1.0 : (boundedRain + boundedIrrigated);
    final rainShare = boundedRain / normalized;
    final irrigatedShare = boundedIrrigated / normalized;

    final cropRate = switch (current.cropIrrigationMode) {
      CropIrrigationMode.rainFed => 0.10,
      CropIrrigationMode.irrigated => 0.05,
      CropIrrigationMode.mixed => (0.10 * rainShare) + (0.05 * irrigatedShare),
    };
    final cropDueKg = current.cropKg >= cropNisabKg ? current.cropKg * cropRate : 0.0;
    final cropTransparency = current.cropKg < cropNisabKg
        ? 'Harvest ${current.cropKg.toStringAsFixed(2)}kg is below Nisab ($cropNisabKg kg), so no crop Zakat is due.'
        : current.cropIrrigationMode == CropIrrigationMode.mixed
            ? 'Mixed irrigation: rain ${boundedRain.toStringAsFixed(0)}%, irrigated ${boundedIrrigated.toStringAsFixed(0)}%. '
                'Effective rate = ${(cropRate * 100).toStringAsFixed(2)}%. '
                'Formula: ${current.cropKg.toStringAsFixed(2)} × ${(cropRate * 100).toStringAsFixed(2)}% = ${cropDueKg.toStringAsFixed(2)}kg.'
            : '${current.cropIrrigationMode == CropIrrigationMode.rainFed ? 'Rain-fed' : 'Irrigated'} rate ${(cropRate * 100).toStringAsFixed(1)}%. '
                'Formula: ${current.cropKg.toStringAsFixed(2)} × ${(cropRate * 100).toStringAsFixed(1)}% = ${cropDueKg.toStringAsFixed(2)}kg.';

    return current.copyWith(
      nisabThresholdEtb: nisabThreshold,
      totalBusinessAssetsEtb: totalBusinessAssets,
      totalLiabilitiesEtb: totalLiabilities,
      goldValueEtb: goldValue,
      silverValueEtb: silverValue,
      totalWealthEtb: totalWealth,
      netWealthEtb: netWealth,
      aboveNisab: aboveNisab,
      estimatedZakatDueEtb: estimatedDue,
      sheepZakatDueCount: sheepDue,
      cattleTabiDueCount: cattleDue.$1,
      cattleMusinnahDueCount: cattleDue.$2,
      camelZakatDueDescription: camelDue,
      livestockSummaryText: livestockSummary,
      livestockTransparencyText: livestockTransparency,
      livestockAdvisoryText: livestockAdvisories,
      rainSharePercent: boundedRain,
      irrigatedSharePercent: boundedIrrigated,
      cropEffectiveRate: cropRate,
      cropZakatDueKg: cropDueKg,
      cropTransparencyText: cropTransparency,
    );
  }

  String _sourceText(FxRateSource source) {
    switch (source) {
      case FxRateSource.live:
        return 'FX source: live';
      case FxRateSource.cache:
        return 'FX source: cache fallback';
      case FxRateSource.fallback:
        return 'FX source: default fallback';
    }
  }

  int _calculateSheepDue(int sheepOrGoats) {
    if (sheepOrGoats < 40) return 0;
    if (sheepOrGoats <= 120) return 1;
    if (sheepOrGoats <= 200) return 2;
    if (sheepOrGoats <= 300) return 3;
    return 3 + ((sheepOrGoats - 300 + 99) ~/ 100);
  }

  (int, int) _calculateCattleDue(int cattle) {
    if (cattle < 30) return (0, 0);

    (int, int)? solveExact(int n) {
      for (var musinnah = n ~/ 40; musinnah >= 0; musinnah--) {
        final remainder = n - (musinnah * 40);
        if (remainder >= 0 && remainder % 30 == 0) {
          return (remainder ~/ 30, musinnah);
        }
      }
      return null;
    }

    final exact = solveExact(cattle);
    if (exact != null) return exact;

    for (var candidate = cattle - 1; candidate >= 30; candidate--) {
      final lower = solveExact(candidate);
      if (lower != null) return lower;
    }
    return (0, 0);
  }

  String _calculateCamelDue(int camels) {
    if (camels < 5) return 'No due';
    if (camels <= 9) return '1 sheep';
    if (camels <= 14) return '2 sheep';
    if (camels <= 19) return '3 sheep';
    if (camels <= 24) return '4 sheep';
    if (camels <= 35) return '1 bint makhad';
    if (camels <= 45) return '1 bint labun';
    if (camels <= 60) return '1 hiqqah';
    if (camels <= 75) return '1 jadhah';
    if (camels <= 90) return '2 bint labun';
    if (camels <= 120) return '2 hiqqah';

    for (var hiqqah = camels ~/ 50; hiqqah >= 0; hiqqah--) {
      final remainder = camels - (hiqqah * 50);
      if (remainder >= 0 && remainder % 40 == 0) {
        final bintLabun = remainder ~/ 40;
        final parts = <String>[];
        if (hiqqah > 0) parts.add('$hiqqah hiqqah');
        if (bintLabun > 0) parts.add('$bintLabun bint labun');
        if (parts.isNotEmpty) return parts.join(' + ');
      }
    }

    final bintLabun = camels ~/ 40;
    return '$bintLabun bint labun (approximate combo)';
  }
}
