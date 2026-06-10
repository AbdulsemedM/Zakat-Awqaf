import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/common/utils/phone_e164.dart';

void main() {
  group('PhoneE164.normalize', () {
    test('local format with leading zero', () {
      expect(
        PhoneE164.normalize('0987654321'),
        '+251987654321',
      );
    });

    test('nine digits without leading zero', () {
      expect(
        PhoneE164.normalize('987654321'),
        '+251987654321',
      );
    });

    test('already E.164', () {
      expect(
        PhoneE164.normalize('+251911223344'),
        '+251911223344',
      );
    });

    test('E.164 with spaces', () {
      expect(
        PhoneE164.normalize('+251 91 122 3344'),
        '+251911223344',
      );
    });

    test('country code without plus', () {
      expect(
        PhoneE164.normalize('251911223344'),
        '+251911223344',
      );
    });

    test('invalid local number', () {
      expect(PhoneE164.normalize('12345'), isNull);
    });
  });
}
