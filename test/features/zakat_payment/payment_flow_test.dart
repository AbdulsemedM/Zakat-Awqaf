import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/network/api_envelope.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/bloc/payment_flow_bloc.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/models/zakat_payment_models.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/repository/zakat_payment_repository.dart';

/// Step 1 response from the guide (section 7).
Map<String, dynamic> _paymentJson({
  String status = 'pending',
  String? step = 'confirm_account',
  Map<String, dynamic>? extra,
}) => {
  'paymentId': 'zp_k3m9x2q7w4b8n6t1',
  'status': status,
  'step': ?step,
  'zakatType': 'wealth',
  'amountEtb': 12500.00,
  'causeId': 'general',
  'causeTitle': 'General Zakat fund',
  'methodCode': 'coopbank',
  'methodLabel': 'Coop Bank',
  'account': {
    'accountNumber': '*********6789',
    'accountHolderName': 'Yitbarek W*******',
  },
  'expiresAt': '2026-10-02T10:45:00+03:00',
  'createdAt': '2026-10-02T10:30:00+03:00',
  ...?extra,
};

ZakatPayment _payment({
  String status = 'pending',
  String? step = 'confirm_account',
  Map<String, dynamic>? extra,
}) => ZakatPayment.fromJson(
  _paymentJson(status: status, step: step, extra: extra),
);

class _FakeRepository implements ZakatPaymentRepository {
  /// What the next action returns or throws, in order.
  final responses = <Object>[];
  final calls = <String>[];

  Future<ZakatPayment> _next(String call) async {
    calls.add(call);
    final next = responses.removeAt(0);
    if (next is ApiException) throw next;
    return next as ZakatPayment;
  }

  @override
  Future<ZakatPayment> confirmAccount(String paymentId) => _next('confirm');

  @override
  Future<ZakatPayment> resendOtp(String paymentId) => _next('resend');

  @override
  Future<ZakatPayment> cancel(String paymentId) => _next('cancel');

  @override
  Future<ZakatPayment> verifyOtp(String paymentId, String otp) =>
      _next('verify:$otp');

  @override
  Future<ZakatPayment> fetchPayment(String paymentId) => _next('status');

  @override
  Future<List<PaymentMethod>> fetchMethods() => throw UnimplementedError();

  @override
  Future<ZakatPayment> startPayment(ZakatPaymentRequest request) =>
      throw UnimplementedError();

  @override
  Future<ZakatCertificate> fetchCertificate(String certificateId) =>
      throw UnimplementedError();

  @override
  Future<Uint8List> downloadCertificatePdf(String certificateId) =>
      throw UnimplementedError();

  @override
  Future<PaymentHistoryPage> fetchHistory({required int page}) =>
      throw UnimplementedError();

  @override
  Future<GivingSummary> fetchGivingSummary() => throw UnimplementedError();
}

Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 1));

void main() {
  group('Payment models', () {
    test('step 1 response', () {
      final payment = ZakatPayment.fromJson(
        _paymentJson(extra: {'guestToken': 'Xb3'}),
      );
      expect(payment.status, PaymentStatus.pending);
      expect(payment.step, PaymentStep.confirmAccount);
      expect(payment.accountHolderName, 'Yitbarek W*******');
      expect(payment.guestToken, 'Xb3');
      expect(payment.isFinal, isFalse);
    });

    test('final states have no step', () {
      final paid = _payment(
        status: 'succeeded',
        step: null,
        extra: {
          'providerReference': 'FT2627',
          'paidAt': '2026-10-02T10:33:12+03:00',
          'certificateId': 'ZC-2026-000451',
        },
      );
      expect(paid.step, isNull);
      expect(paid.isFinal, isTrue);
      expect(paid.certificateId, 'ZC-2026-000451');
    });

    test('OTP block', () {
      final payment = _payment(
        step: 'enter_otp',
        extra: {
          'otp': {
            'expiresAt': '2026-10-02T10:35:00+03:00',
            'attemptsLeft': 5,
            'resendsLeft': 2,
          },
        },
      );
      expect(payment.step, PaymentStep.enterOtp);
      expect(payment.otpAttemptsLeft, 5);
      expect(payment.otpResendsLeft, 2);
    });

    test('request body leaves out missing calculation', () {
      const request = ZakatPaymentRequest(
        zakatType: ZakatType.general,
        amountEtb: 1234.567,
        methodCode: 'coopbank',
        causeId: 'general',
        accountNumber: '1000123456789',
        idempotencyKey: 'key',
      );
      final json = request.toJson();
      expect(json['zakatType'], 'general');
      expect(json['amountEtb'], 1234.57);
      expect(json.containsKey('calculation'), isFalse);
      expect(json.containsKey('payer'), isFalse);
    });

    test('method and history', () {
      final method = PaymentMethod.fromJson({
        'code': 'coopbank',
        'label': 'Coop Bank',
        'available': false,
        'unavailableReason': 'Not available yet',
        'minAmountEtb': 10.00,
        'maxAmountEtb': 1000000.00,
        'flow': 'account_otp',
      });
      expect(method.available, isFalse);
      expect(method.isAccountOtp, isTrue);
      expect(method.maxAmountEtb, 1000000);

      final page = PaymentHistoryPage.fromJson({
        'items': [
          {
            'paymentId': 'zp_1',
            'type': 'zakat',
            'zakatType': 'wealth',
            'amountEtb': 12500.00,
            'status': 'succeeded',
            'certificateId': 'ZC-2026-000451',
            'createdAt': '2026-10-02T10:30:00+03:00',
          },
        ],
        'pagination': {
          'page': 1,
          'limit': 20,
          'totalItems': 1,
          'totalPages': 1,
        },
      });
      expect(page.items.single.status, PaymentStatus.succeeded);
      expect(page.hasMore, isFalse);
    });
  });

  group('PaymentFlowBloc', () {
    test('confirm, wrong code, then paid', () async {
      final repository = _FakeRepository()
        ..responses.addAll([
          _payment(
            step: 'enter_otp',
            extra: {
              'otp': {'attemptsLeft': 5},
            },
          ),
          const ApiException(
            'Wrong code; 3 attempts left',
            statusCode: 400,
            code: 'OTP_WRONG',
            data: {'attemptsLeft': 3, 'resendsLeft': 2},
          ),
          _payment(
            status: 'succeeded',
            step: null,
            extra: {'certificateId': 'ZC-2026-000451'},
          ),
        ]);
      final bloc = PaymentFlowBloc(repository, _payment());
      addTearDown(bloc.close);

      bloc.add(const PaymentAccountConfirmed());
      await _settle();
      expect(bloc.state.payment.step, PaymentStep.enterOtp);

      bloc.add(const PaymentOtpSubmitted('111111'));
      await _settle();
      expect(bloc.state.errorCode, 'OTP_WRONG');
      expect(bloc.state.errorMessage, 'Wrong code; 3 attempts left');
      expect(bloc.state.payment.otpAttemptsLeft, 3);

      bloc.add(const PaymentOtpSubmitted('123456'));
      await _settle();
      expect(bloc.state.payment.status, PaymentStatus.succeeded);
      expect(bloc.state.errorMessage, isNull);
      expect(repository.calls, ['confirm', 'verify:111111', 'verify:123456']);
    });

    test(
      'lost verify-otp response: checks status, never re-verifies',
      () async {
        final repository = _FakeRepository()
          ..responses.addAll([
            const ApiException('timeout', noResponse: true),
            _payment(status: 'pending', step: 'processing'),
          ]);
        final bloc = PaymentFlowBloc(repository, _payment(step: 'enter_otp'));
        addTearDown(bloc.close);

        bloc.add(const PaymentOtpSubmitted('123456'));
        await _settle();
        expect(repository.calls, ['verify:123456', 'status']);
        expect(bloc.state.payment.step, PaymentStep.processing);
        expect(bloc.state.busy, isFalse);
      },
    );

    test('expired code keeps the OTP step and offers resend', () async {
      final repository = _FakeRepository()
        ..responses.add(
          const ApiException(
            'Code expired',
            statusCode: 400,
            code: 'OTP_EXPIRED',
            data: {'attemptsLeft': 4, 'resendsLeft': 2},
          ),
        );
      final bloc = PaymentFlowBloc(repository, _payment(step: 'enter_otp'));
      addTearDown(bloc.close);

      bloc.add(const PaymentOtpSubmitted('123456'));
      await _settle();
      expect(bloc.state.otpExpired, isTrue);
      expect(bloc.state.canResend, isTrue);
      expect(bloc.state.payment.step, PaymentStep.enterOtp);
    });

    test('locked or expired payment shows the server state', () async {
      final repository = _FakeRepository()
        ..responses.addAll([
          const ApiException(
            'Too many wrong codes',
            statusCode: 400,
            code: 'OTP_LOCKED',
          ),
          _payment(
            status: 'failed',
            step: null,
            extra: {'failureReason': 'Too many wrong codes'},
          ),
        ]);
      final bloc = PaymentFlowBloc(repository, _payment(step: 'enter_otp'));
      addTearDown(bloc.close);

      bloc.add(const PaymentOtpSubmitted('000000'));
      await _settle();
      expect(bloc.state.payment.status, PaymentStatus.failed);
      expect(bloc.state.errorMessage, isNull);
    });

    test('resend limit disables resend', () async {
      final repository = _FakeRepository()
        ..responses.add(
          const ApiException(
            'No more codes',
            statusCode: 429,
            code: 'OTP_RESEND_LIMIT',
            data: {'attemptsLeft': 5, 'resendsLeft': 0},
          ),
        );
      final bloc = PaymentFlowBloc(repository, _payment(step: 'enter_otp'));
      addTearDown(bloc.close);

      bloc.add(const PaymentOtpResendRequested());
      await _settle();
      expect(bloc.state.canResend, isFalse);
    });

    test('not my account cancels', () async {
      final repository = _FakeRepository()
        ..responses.add(_payment(status: 'cancelled', step: null));
      final bloc = PaymentFlowBloc(repository, _payment());
      addTearDown(bloc.close);

      bloc.add(const PaymentCancelRequested());
      await _settle();
      expect(bloc.state.payment.status, PaymentStatus.cancelled);
    });
  });
}
