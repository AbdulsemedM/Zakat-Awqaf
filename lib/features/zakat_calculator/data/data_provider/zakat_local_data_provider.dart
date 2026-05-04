abstract class ZakatLocalDataProvider {
  Future<void> cacheUsdToEtbRate({
    required double rate,
    required DateTime timestamp,
  });

  Future<(double rate, DateTime timestamp)?> readCachedUsdToEtbRate();
}

class InMemoryZakatLocalDataProvider implements ZakatLocalDataProvider {
  double? _rate;
  DateTime? _timestamp;

  @override
  Future<void> cacheUsdToEtbRate({
    required double rate,
    required DateTime timestamp,
  }) async {
    _rate = rate;
    _timestamp = timestamp.toUtc();
  }

  @override
  Future<(double rate, DateTime timestamp)?> readCachedUsdToEtbRate() async {
    if (_rate == null || _timestamp == null) return null;
    return (_rate!, _timestamp!);
  }
}
