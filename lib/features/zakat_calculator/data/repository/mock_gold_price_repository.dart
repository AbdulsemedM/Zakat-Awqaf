import '../models/gold_price_model.dart';

abstract class GoldPriceRepository {
  Future<GoldPriceModel> getGoldPriceModel();
  Future<Map<String, double>> getGoldPricesUsdByKarat();
}

class SeededGoldPriceRepository implements GoldPriceRepository {
  const SeededGoldPriceRepository();

  static const Map<String, dynamic> _seededPayload = {
    'timestamp': 1777883649,
    'metal': 'XAU',
    'currency': 'USD',
    'price_gram_24k': 147.1596,
    'price_gram_22k': 134.8963,
    'price_gram_21k': 128.7646,
    'price_gram_18k': 110.3697,
    'price_gram_14k': 85.8431,
  };

  @override
  Future<GoldPriceModel> getGoldPriceModel() async {
    return GoldPriceModel.fromSeededPayload(_seededPayload);
  }

  @override
  Future<Map<String, double>> getGoldPricesUsdByKarat() async {
    final model = await getGoldPriceModel();
    return {
      '24k': model.priceGram24k,
      '22k': model.priceGram22k,
      '21k': model.priceGram21k,
      '18k': model.priceGram18k,
      '14k': model.priceGram14k,
    };
  }
}
