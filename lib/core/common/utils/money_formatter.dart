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
}
