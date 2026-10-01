import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_envelope.dart';
import '../data/models/calculator_config.dart';
import '../data/repository/calculator_config_repository.dart';
import '../data/zakat_rules.dart';
import 'zakat_calculator_event.dart';
import 'zakat_calculator_state.dart';

@injectable
class ZakatCalculatorBloc
    extends Bloc<ZakatCalculatorEvent, ZakatCalculatorState> {
  ZakatCalculatorBloc(this._configRepository)
    : super(const ZakatCalculatorInitial()) {
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
    on<CalculatorConfigRefreshRequested>(_onConfigRefreshRequested);
  }

  final CalculatorConfigRepository _configRepository;

  ZakatCalculatorInitial get _current => state is ZakatCalculatorInitial
      ? state as ZakatCalculatorInitial
      : const ZakatCalculatorInitial();

  Future<void> _onStarted(
    ZakatCalculatorStarted event,
    Emitter<ZakatCalculatorState> emit,
  ) async {
    final cached = await _configRepository.readCached();
    if (cached != null && _current.config == null) {
      emit(
        _recompute(
          _current.copyWith(
            config: cached,
            configStatus: CalculatorConfigStatus.ready,
            configFromCache: true,
          ),
        ),
      );
    }
    await _loadConfig(emit);
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

  Future<void> _onConfigRefreshRequested(
    CalculatorConfigRefreshRequested event,
    Emitter<ZakatCalculatorState> emit,
  ) async {
    await _loadConfig(emit);
  }

  /// Fetches the live config. On failure keeps a config already shown
  /// (flagged as a failed refresh); never falls back to built-in numbers.
  Future<void> _loadConfig(Emitter<ZakatCalculatorState> emit) async {
    if (_current.config == null) {
      emit(_current.copyWith(configStatus: CalculatorConfigStatus.loading));
    }
    try {
      final config = await _configRepository.fetchLatest();
      emit(
        _recompute(
          _current.copyWith(
            config: config,
            configStatus: CalculatorConfigStatus.ready,
            configFromCache: false,
            configRefreshFailed: false,
            configNotReady: false,
          ),
        ),
      );
    } on ApiException catch (e) {
      if (_current.config != null) {
        emit(_current.copyWith(configRefreshFailed: true));
        return;
      }
      emit(
        _current.copyWith(
          configStatus: CalculatorConfigStatus.failed,
          configNotReady: e.statusCode == 503,
        ),
      );
    }
  }

  ZakatCalculatorInitial _recompute(ZakatCalculatorInitial current) {
    final config = current.config;
    if (config == null) return current;

    final selectedGoldPriceEtb = _goldPricePerGram(config, current.goldKarat);

    final totalBusinessAssets = current.businessAssets.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final totalLiabilities = current.liabilities.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    final goldValue = current.goldGrams * selectedGoldPriceEtb;
    final silverValue = current.silverGrams * config.silverPricePerGramEtb;
    final nisabThreshold = config.nisab.valueEtb;

    final totalWealth =
        current.cashOnHand +
        current.bankBalance +
        current.mobileWallet +
        totalBusinessAssets +
        goldValue +
        silverValue;
    final netWealth = totalWealth - totalLiabilities;
    final aboveNisab = netWealth >= nisabThreshold;
    final estimatedDue = aboveNisab ? netWealth * config.wealthRate : 0.0;

    final sheepDue = ZakatRules.sheepDue(config, current.sheepOrGoats);
    final (tabi, musinnah) = ZakatRules.cattleDue(config, current.cattle);
    final camelDue = ZakatRules.camelDue(config, current.camels);
    final livestockEstimate = ZakatRules.livestockEstimateEtb(
      config,
      sheep: sheepDue,
      cattle: tabi + musinnah,
      camel: camelDue,
    );

    final boundedRain = current.rainSharePercent.clamp(0, 100).toDouble();
    final boundedIrrigated = current.irrigatedSharePercent
        .clamp(0, 100)
        .toDouble();
    final cropRate = switch (current.cropIrrigationMode) {
      CropIrrigationMode.rainFed => config.crops.rainFedRate,
      CropIrrigationMode.irrigated => config.crops.irrigatedRate,
      CropIrrigationMode.mixed => ZakatRules.mixedCropRate(
        config.crops,
        boundedRain,
        boundedIrrigated,
      ),
    };
    final cropDueKg = current.cropKg >= config.crops.nisabKg
        ? current.cropKg * cropRate
        : 0.0;

    return current.copyWith(
      goldPricePerGramEtb: selectedGoldPriceEtb,
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
      cattleTabiDueCount: tabi,
      cattleMusinnahDueCount: musinnah,
      camelDue: camelDue,
      livestockEstimatedValueEtb: () => livestockEstimate,
      rainSharePercent: boundedRain,
      irrigatedSharePercent: boundedIrrigated,
      cropEffectiveRate: cropRate,
      cropZakatDueKg: cropDueKg,
    );
  }

  /// The config's price for [karat], or the 24k price scaled by purity when
  /// the config does not list that karat.
  static double _goldPricePerGram(CalculatorConfig config, GoldKarat karat) {
    final prices = config.goldPricePerGramEtb;
    return prices[karat.label] ?? (prices['24k'] ?? 0) * karat.purity;
  }
}
