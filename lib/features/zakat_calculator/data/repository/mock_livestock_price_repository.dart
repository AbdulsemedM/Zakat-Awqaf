abstract class LivestockPriceRepository {
  Future<Map<String, double>> getMarketPrices();
}
