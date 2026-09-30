import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/beneficiary_registration/bloc/beneficiary_registration_state.dart';
import 'package:mejlis_digital_hub/features/beneficiary_registration/data/models/asnaf_category.dart';
import 'package:mejlis_digital_hub/features/beneficiary_registration/data/models/beneficiary_create_request.dart';
import 'package:mejlis_digital_hub/features/beneficiary_registration/data/models/registration_code_validation.dart';

FullBeneficiaryCreateRequest _request({
  String email = 'amina@example.com',
  String? maritalStatus,
  String? religion,
  String? kebele,
  String? addressLine,
}) => FullBeneficiaryCreateRequest(
  fullName: 'Amina Hassen',
  phone: '+251911223344',
  email: email,
  gender: 'female',
  registrationCode: ' EZW-7K3M-Q9TP ',
  beneficiaryType: 'individual',
  category: 'poor',
  notes: 'n',
  dateOfBirth: '1986-03-01',
  maritalStatus: maritalStatus,
  religion: religion,
  kebele: kebele,
  addressLine: addressLine,
);

void main() {
  test('trims values and omits empty optional fields', () {
    final json = _request(kebele: '  ').toJson();
    expect(json['registrationCode'], 'EZW-7K3M-Q9TP');
    expect(json['dateOfBirth'], '1986-03-01');
    for (final key in [
      'estimatedAge',
      'primaryLanguage',
      'maritalStatus',
      'kebele',
      'nationalId',
    ]) {
      expect(json.containsKey(key), isFalse, reason: key);
    }
  });

  test('email is optional: omitted when empty, sent when given', () {
    expect(_request(email: '').toJson().containsKey('email'), isFalse);
    expect(_request(email: '  ').toJson().containsKey('email'), isFalse);
    expect(_request().toJson()['email'], 'amina@example.com');
  });

  test('sends the basic details when provided', () {
    final json = _request(
      maritalStatus: 'widowed',
      religion: 'Muslim',
      kebele: 'Kebele 05',
      addressLine: 'House 12',
    ).toJson();
    expect(json['maritalStatus'], 'widowed');
    expect(json['religion'], 'Muslim');
    expect(json['kebele'], 'Kebele 05');
    expect(json['addressLine'], 'House 12');
  });

  test('religion defaults to Muslim', () {
    expect(const BeneficiaryRegistrationInitial().religion, 'Muslim');
  });

  test('kebele and address are each required to finish the identity step', () {
    final complete = const BeneficiaryRegistrationInitial().copyWith(
      registrationCode: 'EZW-7K3M-Q9TP',
      codeValidation: const RegistrationCodeValidation(
        code: 'EZW-7K3M-Q9TP',
        valid: true,
        branchName: 'Bole',
      ),
      firstName: 'A',
      fatherName: 'B',
      grandFatherName: 'C',
      phoneNumber: '0911223344',
      gender: Gender.female,
      birthdate: DateTime(1990),
      notes: 'n',
      selectedCategory: AsnafCategory.values.first,
      kebele: 'Kebele 05',
      address: 'House 12',
    );
    // No email is fine.
    expect(complete.email, isEmpty);
    expect(complete.isIdentityStepComplete, isTrue);
    expect(complete.copyWith(kebele: ' ').isIdentityStepComplete, isFalse);
    expect(complete.copyWith(address: '').isIdentityStepComplete, isFalse);
    expect(
      complete.copyWith(clearBirthdate: true).isIdentityStepComplete,
      isFalse,
    );
  });
}
