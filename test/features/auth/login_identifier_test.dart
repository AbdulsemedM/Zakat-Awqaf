import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/auth/data/login_identifier.dart';

void main() {
  group('phone numbers become +251 E.164', () {
    const expected = '+251911223344';
    for (final input in [
      '0911223344',
      '911223344',
      '+251911223344',
      '251911223344',
      '+251 911 223 344',
      '0911-223-344',
      '  0911223344  ',
    ]) {
      test('"$input"', () => expect(LoginIdentifier.resolve(input), expected));
    }
  });

  group('emails pass through unchanged (trimmed)', () {
    test('plain', () {
      expect(
        LoginIdentifier.resolve('sendabdu23@gmail.com'),
        'sendabdu23@gmail.com',
      );
    });
    test('trimmed', () {
      expect(
        LoginIdentifier.resolve('  a.b+c@mail.example.org '),
        'a.b+c@mail.example.org',
      );
    });
    test('keeps its case', () {
      expect(LoginIdentifier.resolve('Abdu@Gmail.com'), 'Abdu@Gmail.com');
    });
  });

  group('invalid input resolves to null', () {
    for (final input in [
      '',
      '   ',
      'abc',
      'a@b',
      '@gmail.com',
      'user@',
      'a b@c.com',
      '12345',
      '0811223344', // not an Ethiopian mobile
      '+14155552671', // not Ethiopian
      '09112233445', // too long
    ]) {
      test('"$input"', () => expect(LoginIdentifier.resolve(input), isNull));
    }
  });

  test('looksLikeEmail switches on "@" or letters', () {
    expect(LoginIdentifier.looksLikeEmail('a@b.co'), isTrue);
    expect(LoginIdentifier.looksLikeEmail('abc'), isTrue);
    expect(LoginIdentifier.looksLikeEmail('0911223344'), isFalse);
    expect(LoginIdentifier.looksLikeEmail('+251 911'), isFalse);
    expect(LoginIdentifier.looksLikeEmail(''), isFalse);
  });
}
