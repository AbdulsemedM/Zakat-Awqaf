import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/beneficiary_registration/data/models/beneficiary_create_request.dart';

FullBeneficiaryCreateRequest _request({
  String? dateOfBirth,
  int? estimatedAge,
  String? primaryLanguage,
  String? primaryLanguageOther,
  String? kebele,
}) =>
    FullBeneficiaryCreateRequest(
      fullName: 'Amina Hassen',
      phone: '+251911223344',
      email: 'amina@example.com',
      gender: 'female',
      registrationCode: ' EZW-7K3M-Q9TP ',
      beneficiaryType: 'individual',
      category: 'poor',
      notes: 'n',
      dateOfBirth: dateOfBirth,
      estimatedAge: estimatedAge,
      primaryLanguage: primaryLanguage,
      primaryLanguageOther: primaryLanguageOther,
      kebele: kebele,
    );

void main() {
  test('omits optional fields that are not set', () {
    final json = _request(dateOfBirth: '1986-03-01', kebele: '  ').toJson();
    expect(json['registrationCode'], 'EZW-7K3M-Q9TP');
    expect(json['dateOfBirth'], '1986-03-01');
    for (final key in [
      'estimatedAge',
      'maritalStatus',
      'primaryLanguage',
      'kebele',
      'nationalId',
    ]) {
      expect(json.containsKey(key), isFalse, reason: key);
    }
  });

  test('sends estimated age and other-language text when applicable', () {
    final json = _request(
      estimatedAge: 40,
      primaryLanguage: 'other',
      primaryLanguageOther: 'Harari',
    ).toJson();
    expect(json.containsKey('dateOfBirth'), isFalse);
    expect(json['estimatedAge'], 40);
    expect(json['primaryLanguageOther'], 'Harari');
  });

  test('drops other-language text for a listed language', () {
    final json = _request(
      primaryLanguage: 'amharic',
      primaryLanguageOther: 'stale',
    ).toJson();
    expect(json['primaryLanguage'], 'amharic');
    expect(json.containsKey('primaryLanguageOther'), isFalse);
  });
}
