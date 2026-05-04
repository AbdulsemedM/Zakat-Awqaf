import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/zakat_calculator/presentation/screens/zakat_calculator_screen.dart';

void main() {
  test('livestock Arabic glossary includes required terms', () {
    expect(kLivestockArabicTermDefinitions["tabi'"], 'one-year-old calf');
    expect(kLivestockArabicTermDefinitions['musinnah'], 'two-year-old cow');
    expect(
      kLivestockArabicTermDefinitions['bint makhad'],
      'one-year-old she-camel',
    );
    expect(
      kLivestockArabicTermDefinitions['bint labun'],
      'two-year-old she-camel',
    );
    expect(kLivestockArabicTermDefinitions['hiqqah'], 'three-year-old she-camel');
    expect(kLivestockArabicTermDefinitions['jadhah'], 'four-year-old she-camel');
  });
}
