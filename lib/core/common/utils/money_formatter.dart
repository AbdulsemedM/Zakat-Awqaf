class MoneyFormatter {
  MoneyFormatter._();

  static String etb(double value) {
    final isNegative = value < 0;
    final absolute = value.abs();
    final fixed = absolute.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts[0];
    final decimal = parts[1];

    final withCommas = whole.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );

    final signed = isNegative ? '-$withCommas' : withCommas;
    return 'ETB $signed.$decimal';
  }

  /// Short form for tight spaces: `ETB 1.12M`, `ETB 980K`, `ETB 750`.
  static String etbCompact(double value) {
    final absolute = value.abs();
    final sign = value < 0 ? '-' : '';
    for (final (limit, suffix) in const [(1e9, 'B'), (1e6, 'M'), (1e3, 'K')]) {
      // 0.9995 so 999,999 reads `1M`, not `1000K`.
      if (absolute >= limit * 0.9995) {
        final scaled = (absolute / limit).toStringAsFixed(2);
        final trimmed = scaled.replaceFirst(RegExp(r'\.?0+$'), '');
        return 'ETB $sign$trimmed$suffix';
      }
    }
    return 'ETB $sign${absolute.toStringAsFixed(0)}';
  }
}
