class ExchangeRateModel {
  const ExchangeRateModel({
    required this.base,
    required this.target,
    required this.rate,
    required this.timestamp,
  });

  final String base;
  final String target;
  final double rate;
  final DateTime timestamp;
}
