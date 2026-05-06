/// Formats a number with thousands separators (e.g. 42550000 -> "42,550,000").
/// Trims trailing zeros for whole numbers and keeps two decimals otherwise.
String formatThousands(num value) {
  final isInt = value == value.truncateToDouble();
  final str = isInt ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  final parts = str.split('.');
  final integer = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    if (i > 0 && (integer.length - i) % 3 == 0) buffer.write(',');
    buffer.write(integer[i]);
  }
  if (parts.length == 2) {
    buffer
      ..write('.')
      ..write(parts[1]);
  }
  return buffer.toString();
}
