import 'dart:typed_data';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/network/api_envelope.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/bloc/payment_flow_bloc.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/models/zakat_payment_models.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/repository/zakat_payment_repository.dart';

/// Start response from the guide (section 7).
Map<String, dynamic> _paymentJson({
  String status = 'pending',
  String? step = 'scan_qr',
  Map<String, dynamic>? extra,
}) => {
  'paymentId': 'zp_k3m9x2q7w4b8n6t1',
  'status': status,
  'step': ?step,
  'zakatType': 'wealth',
  'amountEtb': 2500.00,
  'causeId': 'general',
  'causeTitle': 'General Zakat fund',
  'methodCode': 'ethqr',
  'methodLabel': 'QR payment',
  'qr': {
    'payload': '00020101021226…6304ABCD',
    'expiresAt': '2026-10-12T10:30:00+03:00',
  },
  'expiresAt': '2026-10-12T10:30:00+03:00',
  'createdAt': '2026-10-12T10:00:00+03:00',
  ...?extra,
};

ZakatPayment _payment({
  String status = 'pending',
  String? step = 'scan_qr',
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
  Future<ZakatPayment> cancel(String paymentId) => _next('cancel');

  @override
  Future<ZakatPayment> checkPayment(String paymentId) => _next('check');

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
    test('start response with the QR', () {
      final payment = ZakatPayment.fromJson(
        _paymentJson(
          extra: {
            'guestToken': 'tok',
            'qr': {
              'payload': '00020101021226…6304ABCD',
              'imageBase64': 'iVBORw0KGgo',
              'imageContentType': 'image/png',
              'expiresAt': '2026-10-12T10:30:00+03:00',
            },
          },
        ),
      );
      expect(payment.status, PaymentStatus.pending);
      expect(payment.step, PaymentStep.scanQr);
      expect(payment.isQr, isTrue);
      expect(payment.isFinal, isFalse);
      expect(payment.qrPayload, '00020101021226…6304ABCD');
      expect(payment.qrImageBase64, 'iVBORw0KGgo');
      expect(payment.qrExpiresAt, DateTime.parse('2026-10-12T07:30:00Z'));
      expect(payment.guestToken, 'tok');
    });

    test('later reads have the payload only', () {
      final payment = _payment();
      expect(payment.qrPayload, isNotNull);
      expect(payment.qrImageBase64, isNull);
    });

    test('final states have no step', () {
      final paid = _payment(
        status: 'succeeded',
        step: null,
        extra: {
          'providerReference': 'FT2627',
          'paidAt': '2026-10-12T10:33:12+03:00',
          'certificateId': 'ZC-2026-000451',
        },
      );
      expect(paid.step, isNull);
      expect(paid.isFinal, isTrue);
      expect(paid.certificateId, 'ZC-2026-000451');
    });

    test('request: payer, no account number, no missing calculation', () {
      const request = ZakatPaymentRequest(
        zakatType: ZakatType.wealth,
        amountEtb: 1234.567,
        methodCode: 'ethqr',
        causeId: 'general',
        payer: PaymentPayer(fullName: 'Amina Hassen', phone: '+251911223344'),
        idempotencyKey: 'key',
      );
      final json = request.toJson();
      expect(json['amountEtb'], 1234.57);
      expect(json['methodCode'], 'ethqr');
      expect(json.containsKey('accountNumber'), isFalse);
      expect(json.containsKey('calculation'), isFalse);
      expect(json['payer'], {
        'fullName': 'Amina Hassen',
        'phone': '+251911223344',
        'anonymous': false,
      });
    });

    test('paid a different amount', () {
      final paid = _payment(
        status: 'succeeded',
        step: null,
        extra: {'amountEtb': 2501.00, 'issuedAmountEtb': 2500.00},
      );
      expect(paid.paidDifferentAmount, isTrue);
      expect(_payment().paidDifferentAmount, isFalse);
    });

    test('check-payment applies to pending and expired QRs', () {
      expect(_payment().canCheckPayment, isTrue);
      expect(_payment(status: 'expired', step: null).canCheckPayment, isTrue);
      expect(
        _payment(status: 'succeeded', step: null).canCheckPayment,
        isFalse,
      );
      final now = DateTime.utc(2026, 10, 13, 8);
      PaymentHistoryItem row(String status, String createdAt) =>
          PaymentHistoryItem.fromJson({
            'paymentId': 'zp_1',
            'amountEtb': 100,
            'status': status,
            'createdAt': createdAt,
          });
      expect(
        row('pending', '2026-10-01T00:00:00Z').canCheckPayment(now),
        isTrue,
      );
      expect(
        row('expired', '2026-10-12T12:00:00Z').canCheckPayment(now),
        isTrue,
      );
      expect(
        row('expired', '2026-10-11T00:00:00Z').canCheckPayment(now),
        isFalse,
      );
      expect(
        row('cancelled', '2026-10-13T07:00:00Z').canCheckPayment(now),
        isFalse,
      );
    });

    test('a signed-in donor sends no payer', () {
      const request = ZakatPaymentRequest(
        zakatType: ZakatType.general,
        amountEtb: 100,
        methodCode: 'ethqr',
        causeId: 'general',
        idempotencyKey: 'key',
      );
      expect(request.toJson().containsKey('payer'), isFalse);
    });

    test('method and history', () {
      final method = PaymentMethod.fromJson({
        'code': 'ethqr',
        'label': 'QR payment',
        'subtitle': 'Scan with any Ethiopian bank app',
        'type': 'qr',
        'available': false,
        'unavailableReason': 'Not set up yet',
        'minAmountEtb': 10,
        'maxAmountEtb': 1000000,
        'flow': 'qr',
      });
      expect(method.available, isFalse);
      expect(method.isQr, isTrue);
      expect(method.maxAmountEtb, 1000000);

      final page = PaymentHistoryPage.fromJson({
        'items': [
          {
            'paymentId': 'zp_1',
            'type': 'zakat',
            'zakatType': 'wealth',
            'amountEtb': 2500.00,
            'methodLabel': 'QR payment',
            'status': 'succeeded',
            'certificateId': 'ZC-2026-000451',
            'createdAt': '2026-10-12T10:00:00+03:00',
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
      expect(page.items.single.methodLabel, 'QR payment');
      expect(page.hasMore, isFalse);
    });
  });

  group('PaymentFlowBloc', () {
    test('"I have paid": received at once', () async {
      final repository = _FakeRepository()
        ..responses.add(
          _payment(
            status: 'succeeded',
            step: null,
            extra: {'certificateId': 'ZC-2026-000451'},
          ),
        );
      final bloc = PaymentFlowBloc(repository, _payment());
      addTearDown(bloc.close);
      bloc.add(const PaymentCheckRequested());
      await _settle();
      expect(repository.calls, ['check']);
      expect(bloc.state.payment.certificateId, 'ZC-2026-000451');
      expect(bloc.state.notReceived, isFalse);
      expect(bloc.state.checking, isFalse);
    });

    test('"I have paid": not there yet, one retry after 5 s', () {
      fakeAsync((async) {
        final repository = _FakeRepository()
          ..responses.addAll([_payment(), _payment()]);
        final bloc = PaymentFlowBloc(repository, _payment());
        bloc.add(const PaymentCheckRequested());
        async.flushMicrotasks();
        expect(bloc.state.checking, isTrue);
        expect(repository.calls, ['check']);

        async.elapse(PaymentFlowBloc.checkRetryDelay);
        async.flushMicrotasks();
        expect(repository.calls, ['check', 'check']);
        expect(bloc.state.checking, isFalse);
        expect(bloc.state.notReceived, isTrue);
        expect(bloc.state.payment.step, PaymentStep.scanQr);
        bloc.close();
        async.flushMicrotasks();
      });
    });

    test('the retry finds it', () {
      fakeAsync((async) {
        final repository = _FakeRepository()
          ..responses.addAll([
            _payment(),
            _payment(status: 'succeeded', step: null),
          ]);
        final bloc = PaymentFlowBloc(repository, _payment());
        bloc.add(const PaymentCheckRequested());
        async.elapse(PaymentFlowBloc.checkRetryDelay);
        async.flushMicrotasks();
        expect(bloc.state.payment.status, PaymentStatus.succeeded);
        expect(bloc.state.notReceived, isFalse);
        bloc.close();
        async.flushMicrotasks();
      });
    });

    test('a quiet check (back from the bank app) shows no message', () {
      fakeAsync((async) {
        final repository = _FakeRepository()
          ..responses.addAll([_payment(), _payment()]);
        final bloc = PaymentFlowBloc(repository, _payment());
        bloc.add(const PaymentCheckRequested(quiet: true));
        async.elapse(PaymentFlowBloc.checkRetryDelay);
        async.flushMicrotasks();
        expect(bloc.state.notReceived, isFalse);
        bloc.close();
        async.flushMicrotasks();
      });
    });

    test('an expired QR can still be confirmed', () async {
      final repository = _FakeRepository()
        ..responses.add(_payment(status: 'succeeded', step: null));
      final bloc = PaymentFlowBloc(
        repository,
        _payment(status: 'expired', step: null),
      );
      addTearDown(bloc.close);
      bloc.add(const PaymentCheckRequested());
      await _settle();
      expect(bloc.state.payment.status, PaymentStatus.succeeded);
    });

    test('409 on an older QR shows the server state', () async {
      final repository = _FakeRepository()
        ..responses.addAll([
          const ApiException(
            'Confirmed by the commission',
            statusCode: 409,
            code: 'INVALID_STATE',
          ),
          _payment(),
        ]);
      final bloc = PaymentFlowBloc(repository, _payment());
      addTearDown(bloc.close);
      bloc.add(const PaymentCheckRequested());
      await _settle();
      expect(repository.calls, ['check', 'status']);
      expect(bloc.state.checking, isFalse);
      expect(bloc.state.busy, isFalse);
      expect(bloc.state.errorMessage, 'Confirmed by the commission');
    });

    test('cancel ends the payment', () async {
      final repository = _FakeRepository()
        ..responses.add(_payment(status: 'cancelled', step: null));
      final bloc = PaymentFlowBloc(repository, _payment());
      addTearDown(bloc.close);

      bloc.add(const PaymentCancelRequested());
      await _settle();
      expect(bloc.state.payment.status, PaymentStatus.cancelled);
      expect(repository.calls, ['cancel']);
    });

    test('cancel after it was confirmed shows the server state', () async {
      final repository = _FakeRepository()
        ..responses.addAll([
          const ApiException(
            'Payment is not pending',
            statusCode: 409,
            code: 'INVALID_STATE',
          ),
          _payment(
            status: 'succeeded',
            step: null,
            extra: {'certificateId': 'ZC-2026-000451'},
          ),
        ]);
      final bloc = PaymentFlowBloc(repository, _payment());
      addTearDown(bloc.close);

      bloc.add(const PaymentCancelRequested());
      await _settle();
      expect(repository.calls, ['cancel', 'status']);
      expect(bloc.state.payment.status, PaymentStatus.succeeded);
      expect(bloc.state.errorMessage, isNull);
    });

    test('no response: checks the status instead', () async {
      final repository = _FakeRepository()
        ..responses.addAll([
          const ApiException('timeout', noResponse: true),
          _payment(status: 'expired', step: null),
        ]);
      final bloc = PaymentFlowBloc(repository, _payment());
      addTearDown(bloc.close);

      bloc.add(const PaymentCancelRequested());
      await _settle();
      expect(bloc.state.payment.status, PaymentStatus.expired);
      expect(bloc.state.busy, isFalse);
    });

    test('other errors keep the QR and show the message', () async {
      final repository = _FakeRepository()
        ..responses.add(
          const ApiException(
            'Payments are unavailable',
            statusCode: 503,
            code: 'PAYMENTS_UNAVAILABLE',
          ),
        );
      final bloc = PaymentFlowBloc(repository, _payment());
      addTearDown(bloc.close);

      bloc.add(const PaymentStatusRefreshRequested());
      await _settle();
      expect(bloc.state.payment.step, PaymentStep.scanQr);
      expect(bloc.state.errorMessage, 'Payments are unavailable');
    });
  });
}
