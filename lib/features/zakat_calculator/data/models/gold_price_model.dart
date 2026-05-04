class GoldPriceModel {
  const GoldPriceModel({
    required this.timestamp,
    required this.metal,
    required this.currency,
    required this.priceGram24k,
    required this.priceGram22k,
    required this.priceGram21k,
    required this.priceGram18k,
    required this.priceGram14k,
  });

  final int timestamp;
  final String metal;
  final String currency;
  final double priceGram24k;
  final double priceGram22k;
  final double priceGram21k;
  final double priceGram18k;
  final double priceGram14k;

  double priceByKarat(String karat) {
    switch (karat) {
      case '24k':
        return priceGram24k;
      case '22k':
        return priceGram22k;
      case '21k':
        return priceGram21k;
      case '18k':
        return priceGram18k;
      case '14k':
        return priceGram14k;
      default:
        return priceGram24k;
    }
  }

  factory GoldPriceModel.fromSeededPayload(Map<String, dynamic> json) {
    return GoldPriceModel(
      timestamp: (json['timestamp'] as num).toInt(),
      metal: json['metal'] as String,
      currency: json['currency'] as String,
      priceGram24k: (json['price_gram_24k'] as num).toDouble(),
      priceGram22k: (json['price_gram_22k'] as num).toDouble(),
      priceGram21k: (json['price_gram_21k'] as num).toDouble(),
      priceGram18k: (json['price_gram_18k'] as num).toDouble(),
      priceGram14k: (json['price_gram_14k'] as num).toDouble(),
    );
  }
}
