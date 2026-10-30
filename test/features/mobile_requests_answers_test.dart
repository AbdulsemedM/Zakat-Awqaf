import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/auth/data/login_identifier.dart';
import 'package:mejlis_digital_hub/features/auth/data/models/otp_challenge.dart';
import 'package:mejlis_digital_hub/features/auth/data/password_rules.dart';
import 'package:mejlis_digital_hub/features/beneficiary_registration/data/models/beneficiary_dto.dart';
import 'package:mejlis_digital_hub/features/profile/data/models/application_status_dto.dart';
import 'package:mejlis_digital_hub/features/profile/data/models/bank_account_update_request.dart';
import 'package:mejlis_digital_hub/features/profile/data/models/payout_bank.dart';
import 'package:mejlis_digital_hub/features/profile/data/models/support_contact.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/models/zakat_payment_models.dart';

/// Shapes from `MOBILE_REQUESTS_ANSWERS.md` (2026-10-30).
void main() {
  group('#2, #3, #9 code flows', () {
    test('a challenge reads its id key, mask and limits', () {
      final challenge = OtpChallenge.fromJson({
        'resetId': 'pr_k3m9x2q7w4b8n6t1',
        'phone': '+251*****344',
        'expiresAt': '2026-10-30T10:30:00+03:00',
        'otp': {
          'expiresAt': '2026-10-30T10:10:00+03:00',
          'attemptsLeft': 5,
          'resendsLeft': 2,
        },
      }, idKey: 'resetId');
      expect(challenge.id, 'pr_k3m9x2q7w4b8n6t1');
      expect(challenge.maskedPhone, '+251*****344');
      expect(challenge.attemptsLeft, 5);
      expect(challenge.canResend, isTrue);

      final spent = challenge.withLimitsFrom({
        'attemptsLeft': 3,
        'resendsLeft': 0,
      });
      expect(spent.attemptsLeft, 3);
      expect(spent.canResend, isFalse);
      expect(spent.id, challenge.id);
    });

    test('a challenge without its id is rejected', () {
      expect(
        () => OtpChallenge.fromJson({'signupId': 'ds_1'}, idKey: 'changeId'),
        throwsFormatException,
      );
    });

    test('password rules match the server', () {
      expect(PasswordRules.isStrong('New@Pass2026'), isTrue);
      expect(PasswordRules.isStrong('New@Pass1'), isFalse); // 9 characters
      expect(PasswordRules.isStrong('new@pass2026'), isFalse);
      expect(PasswordRules.isStrong('NEW@PASS2026'), isFalse);
      expect(PasswordRules.isStrong('New@Password'), isFalse);
      expect(PasswordRules.isStrong('NewPass20266'), isFalse);
    });

    test('only Ethiopian mobiles are accepted as the phone', () {
      expect(LoginIdentifier.resolvePhone('0911223344'), '+251911223344');
      expect(LoginIdentifier.resolvePhone('a@b.co'), isNull);
      expect(LoginIdentifier.resolvePhone('12345'), isNull);
    });
  });

  group('#4 Sadaqah', () {
    test('the request sends purpose and no zakat kind', () {
      const request = ZakatPaymentRequest(
        purpose: PaymentPurpose.sadaqah,
        zakatType: ZakatType.general,
        amountEtb: 500,
        methodCode: 'ethqr',
        causeId: 'general',
        idempotencyKey: 'key',
      );
      final json = request.toJson();
      expect(json['purpose'], 'sadaqah');
      expect(json.containsKey('zakatType'), isFalse);
    });

    test('zakat stays as before, with purpose zakat', () {
      const request = ZakatPaymentRequest(
        zakatType: ZakatType.wealth,
        amountEtb: 500,
        methodCode: 'ethqr',
        causeId: 'general',
        idempotencyKey: 'key',
      );
      expect(request.toJson()['purpose'], 'zakat');
      expect(request.toJson()['zakatType'], 'wealth');
    });

    test('payments and certificates carry purpose', () {
      final payment = ZakatPayment.fromJson({
        'paymentId': 'zp_1',
        'purpose': 'sadaqah',
        'zakatType': 'general',
        'status': 'succeeded',
        'amountEtb': 500,
      });
      expect(payment.isSadaqah, isTrue);
      expect(
        ZakatPayment.fromJson({
          'paymentId': 'zp_2',
          'status': 'pending',
        }).isSadaqah,
        isFalse,
      );
      final certificate = ZakatCertificate.fromJson({
        'certificateId': 'ZC-2026-000500',
        'purpose': 'sadaqah',
        'amountEtb': 500,
      });
      expect(certificate.isSadaqah, isTrue);
    });
  });

  group('#5 donation history and summary', () {
    test('a card donation is never checked as a QR', () {
      final card = PaymentHistoryItem.fromJson({
        'paymentId': 'MR-2026-0001',
        'type': 'card',
        'amountEtb': 3750,
        'amountUsd': 25,
        'cardPurpose': 'waqf',
        'methodLabel': 'International card',
        'status': 'pending',
        'reference': 'TXN123',
        'createdAt': '2026-10-30T08:00:00Z',
      });
      expect(card.isCard, isTrue);
      expect(card.amountUsd, 25);
      expect(card.cardPurpose, 'waqf');
      expect(card.reference, 'TXN123');
      expect(card.canCheckPayment(DateTime.utc(2026, 10, 30, 9)), isFalse);
    });

    test('a Sadaqah row and a zakat row', () {
      final sadaqah = PaymentHistoryItem.fromJson({
        'paymentId': 'zp_1',
        'type': 'sadaqah',
        'amountEtb': 500,
        'status': 'pending',
        'createdAt': '2026-10-30T08:00:00Z',
      });
      expect(sadaqah.isSadaqah, isTrue);
      expect(sadaqah.zakatType, isNull);
      expect(sadaqah.canCheckPayment(DateTime.utc(2026, 10, 30, 9)), isTrue);

      final paid = sadaqah.withPayment(
        ZakatPayment.fromJson({
          'paymentId': 'zp_1',
          'purpose': 'sadaqah',
          'status': 'succeeded',
          'amountEtb': 500,
          'certificateId': 'ZC-2026-000500',
        }),
      );
      expect(paid.status, PaymentStatus.succeeded);
      expect(paid.type, 'sadaqah');
      expect(paid.certificateId, 'ZC-2026-000500');
      expect(paid.createdAt, sadaqah.createdAt);

      final zakat = PaymentHistoryItem.fromJson({
        'paymentId': 'zp_2',
        'type': 'zakat',
        'zakatType': 'wealth',
        'amountEtb': 100,
        'status': 'succeeded',
      });
      expect(zakat.isSadaqah, isFalse);
      expect(zakat.isCard, isFalse);
    });

    test('the summary totals zakat and Sadaqah apart', () {
      final summary = GivingSummary.fromJson({
        'totalZakatPaidEtb': 1000,
        'totalSadaqahEtb': 250,
        'paymentsCount': 3,
        'allTime': {'totalZakatPaidEtb': 5000, 'totalSadaqahEtb': 750},
      });
      expect(summary.totalZakatPaidEtb, 1000);
      expect(summary.totalSadaqahEtb, 250);
      expect(summary.allTimeSadaqahEtb, 750);
    });
  });

  group('#6 disbursements', () {
    test('read from /me and /me/application', () {
      final me = BeneficiaryDto.fromJson({
        'id': 'b1',
        'lastDisbursement': {
          'amountEtb': 1500.00,
          'paidAt': '2026-10-01T10:00:00+03:00',
        },
        'totalAidReceivedEtb': 4500.00,
      });
      expect(me.lastDisbursementAmountEtb, 1500);
      expect(me.lastDisbursementPaidAt, DateTime.utc(2026, 10, 1, 7));
      expect(me.totalAidReceivedEtb, 4500);

      final application = ApplicationStatusDto.fromJson({
        'lastDisbursement': {'amountEtb': 1500, 'paidAt': '2026-10-01'},
        'totalAidReceivedEtb': 4500,
      });
      expect(application.lastDisbursementAmountEtb, 1500);
      expect(application.totalAidReceivedEtb, 4500);
    });

    test('before the first payout: total 0, no last disbursement', () {
      final application = ApplicationStatusDto.fromJson({
        'totalAidReceivedEtb': 0,
      });
      expect(application.totalAidReceivedEtb, 0);
      expect(application.lastDisbursementAmountEtb, isNull);
      expect(application.lastDisbursementPaidAt, isNull);
    });
  });

  group('#7 payout banks', () {
    final coop = PayoutBank.fromJson({
      'code': 'coop_bank_of_oromia',
      'name': 'Cooperative Bank of Oromia',
      'available': true,
      'accountNumberPattern': r'^\d{6,30}$',
    });

    test('account numbers are checked against the pattern', () {
      final number = PayoutBank.normalizeAccountNumber('1000 1234-56789');
      expect(number, '1000123456789');
      expect(coop.acceptsAccountNumber(number), isTrue);
      expect(coop.acceptsAccountNumber('12345'), isFalse);
      expect(coop.acceptsAccountNumber(''), isFalse);
    });

    test('an unavailable bank and a bad pattern', () {
      final cbe = PayoutBank.fromJson({
        'code': 'cbe',
        'name': 'Commercial Bank of Ethiopia',
        'available': false,
        'accountNumberPattern': '([',
      });
      expect(cbe.available, isFalse);
      // A pattern the app can't read is left to the server.
      expect(cbe.acceptsAccountNumber('1000123456789'), isTrue);
    });

    test('the account is saved with bankCode, not bankName', () {
      expect(
        const BankAccountUpdateRequest(
          bankCode: 'coop_bank_of_oromia',
          accountNumber: '1000123456789',
        ).toJson(),
        {'bankCode': 'coop_bank_of_oromia', 'accountNumber': '1000123456789'},
      );
      expect(
        BeneficiaryDto.fromJson({
          'id': 'b1',
          'bankCode': 'coop_bank_of_oromia',
        }).bankCode,
        'coop_bank_of_oromia',
      );
    });
  });

  group('#10 support', () {
    test('only fields with a value; all null hides it', () {
      final contact = SupportContact.fromJson({
        'phone': '+251111234567',
        'email': null,
        'webUrl': ' ',
        'hours': 'Monday to Friday, 8:30 to 17:30',
      });
      expect(contact.phone, '+251111234567');
      expect(contact.email, isNull);
      expect(contact.webUrl, isNull);
      expect(contact.isEmpty, isFalse);
      expect(
        SupportContact.fromJson({
          'phone': null,
          'email': null,
          'webUrl': null,
          'hours': null,
        }).isEmpty,
        isTrue,
      );
    });
  });
}
