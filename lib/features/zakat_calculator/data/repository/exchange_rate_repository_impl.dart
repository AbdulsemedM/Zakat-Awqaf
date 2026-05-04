import '../data_provider/zakat_local_data_provider.dart';
import '../data_provider/zakat_remote_data_provider.dart';

enum FxRateSource { live, cache, fallback }

class FxRateQuote {
  const FxRateQuote({
    required this.rate,
    required this.timestamp,
    required this.source,
  });

  final double rate;
  final DateTime timestamp;
  final FxRateSource source;
}

abstract class ExchangeRateRepository {
  Future<FxRateQuote> getUsdToEtbRate();
}

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  ExchangeRateRepositoryImpl({
    required ZakatRemoteDataProvider remote,
    required ZakatLocalDataProvider local,
  }) : _remote = remote,
       _local = local;

  final ZakatRemoteDataProvider _remote;
  final ZakatLocalDataProvider _local;

  @override
  Future<FxRateQuote> getUsdToEtbRate() async {
    try {
      final payload = await _remote.fetchUsdToEtbRate();
      final rate = (payload['rate'] as num).toDouble();
      final timestampRaw = payload['timestamp']?.toString();
      final timestamp =
          timestampRaw == null
          ? DateTime.now().toUtc()
          : DateTime.tryParse(timestampRaw)?.toUtc() ?? DateTime.now().toUtc();
      await _local.cacheUsdToEtbRate(rate: rate, timestamp: timestamp);
      return FxRateQuote(
        rate: rate,
        timestamp: timestamp,
        source: FxRateSource.live,
      );
    } catch (_) {
      final cached = await _local.readCachedUsdToEtbRate();
      if (cached != null) {
        return FxRateQuote(
          rate: cached.$1,
          timestamp: cached.$2,
          source: FxRateSource.cache,
        );
      }
      return FxRateQuote(
        rate: 156.183869,
        timestamp: DateTime.now().toUtc(),
        source: FxRateSource.fallback,
      );
    }
  }
}
