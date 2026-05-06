import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/presentation/zakat_calculator_strings.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations_en.dart';

void main() {
  test('livestock Arabic glossary includes required terms', () {
    final l = AppLocalizationsEn();
    final map = {
      for (final e in ZakatCalculatorStrings.arabicTermEntries(l)) e.key: e.value,
    };
    expect(map["tabi'"], 'one-year-old calf');
    expect(map['musinnah'], 'two-year-old cow');
    expect(map['bint makhad'], 'one-year-old she-camel');
    expect(map['bint labun'], 'two-year-old she-camel');
    expect(map['hiqqah'], 'three-year-old she-camel');
    expect(map['jadhah'], 'four-year-old she-camel');
  });
}
