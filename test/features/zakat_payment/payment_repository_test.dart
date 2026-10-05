import 'dart:typed_data';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/bloc/payment_flow_bloc.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/data_provider/device_payments_store.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/data_provider/guest_payment_token_store.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/data_provider/zakat_payment_remote_data_provider.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/models/zakat_payment_models.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/repository/zakat_payment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

ZakatPayment _payment({
  String id = 'zp_1',
  String status = 'pending',
  String? step = 'confirm_account',
  String? guestToken,
  String? certificateId,
  String expiresAt = '2099-01-01T00:00:00Z',
}) => ZakatPayment.fromJson({
  'paymentId': id,
  'status': status,
  'step': ?step,
  'amountEtb': 500,
  'causeTitle': 'General Zakat fund',
  'zakatType': 'general',
  'expiresAt': expiresAt,
  'createdAt': '2026-10-03T10:00:00+03:00',
  'guestToken': ?guestToken,
  'certificateId': ?certificateId,
});

class _MemoryTokenStore implements GuestPaymentTokenStore {
  final payments = <String, String>{};
  final certificates = <String, String>{};

  @override
  Future<String?> tokenForPayment(String paymentId) async =>
      payments[paymentId];

  @override
  Future<String?> tokenForCertificate(String certificateId) async {
    final paymentId = certificates[certificateId];
    return paymentId == null ? null : payments[paymentId];
  }

  @override
  Future<void> savePaymentToken(String paymentId, String token) async =>
      payments[paymentId] = token;

  @override
  Future<void> linkCertificate(String certificateId, String paymentId) async =>
      certificates[certificateId] = paymentId;
}

/// Records the guest token each call was given; returns queued payments.
class _FakeRemote implements ZakatPaymentRemoteDataProvider {
  final responses = <ZakatPayment>[];
  final tokens = <String, String?>{};

  ZakatPayment _next(String call, String? token) {
    tokens[call] = token;
    return responses.removeAt(0);
  }

  @override
  Future<ZakatPayment> startPayment(ZakatPaymentRequest request) async =>
      _next('start', null);

  @override
  Future<ZakatPayment> confirmAccount(
    String paymentId, {
    String? guestToken,
  }) async => _next('confirm', guestToken);

  @override
  Future<ZakatPayment> verifyOtp(
    String paymentId,
    String otp, {
    String? guestToken,
  }) async => _next('verify', guestToken);

  @override
  Future<ZakatPayment> fetchPayment(
    String paymentId, {
    String? guestToken,
  }) async => _next('status', guestToken);

  @override
  Future<ZakatCertificate> fetchCertificate(
    String certificateId, {
    String? guestToken,
  }) async {
    tokens['certificate'] = guestToken;
    return ZakatCertificate(certificateId: certificateId, amountEtb: 500);
  }

  @override
  Future<ZakatPayment> resendOtp(String paymentId, {String? guestToken}) =>
      throw UnimplementedError();

  @override
  Future<ZakatPayment> cancel(String paymentId, {String? guestToken}) =>
      throw UnimplementedError();

  @override
  Future<List<PaymentMethod>> fetchMethods() => throw UnimplementedError();

  @override
  Future<Uint8List> downloadCertificatePdf(
    String certificateId, {
    String? guestToken,
  }) => throw UnimplementedError();

  @override
  Future<PaymentHistoryPage> fetchHistory({
    required int page,
    int limit = 20,
  }) => throw UnimplementedError();

  @override
  Future<GivingSummary> fetchGivingSummary() => throw UnimplementedError();
}

const _request = ZakatPaymentRequest(
  zakatType: ZakatType.general,
  amountEtb: 500,
  methodCode: 'coopbank',
  causeId: 'general',
  accountNumber: '1000123456789',
  idempotencyKey: 'key-1',
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('ZakatPaymentRepository guest tokens', () {
    test('saves the step 1 token and sends it on later calls', () async {
      final remote = _FakeRemote();
      final tokens = _MemoryTokenStore();
      final repository = ZakatPaymentRepositoryImpl(
        remote,
        tokens,
        DevicePaymentsStore(),
      );

      remote.responses.addAll([
        _payment(guestToken: 'token-1'),
        _payment(step: 'enter_otp'),
        _payment(status: 'succeeded', step: null, certificateId: 'ZC-1'),
      ]);
      await repository.startPayment(_request);
      await repository.confirmAccount('zp_1');
      await repository.verifyOtp('zp_1', '123456');
      await repository.fetchCertificate('ZC-1');

      expect(tokens.payments['zp_1'], 'token-1');
      expect(remote.tokens['confirm'], 'token-1');
      expect(remote.tokens['verify'], 'token-1');
      expect(tokens.certificates['ZC-1'], 'zp_1');
      expect(remote.tokens['certificate'], 'token-1');
    });

    test('a step 1 retry replaces the token', () async {
      final remote = _FakeRemote();
      final tokens = _MemoryTokenStore();
      final repository = ZakatPaymentRepositoryImpl(
        remote,
        tokens,
        DevicePaymentsStore(),
      );

      remote.responses.addAll([
        _payment(guestToken: 'old'),
        _payment(guestToken: 'new'),
        _payment(step: 'enter_otp'),
      ]);
      await repository.startPayment(_request);
      await repository.startPayment(_request);
      await repository.confirmAccount('zp_1');
      expect(remote.tokens['confirm'], 'new');
    });

    test('signed-in payments have no token', () async {
      final remote = _FakeRemote();
      final repository = ZakatPaymentRepositoryImpl(
        remote,
        _MemoryTokenStore(),
        DevicePaymentsStore(),
      );
      remote.responses.addAll([_payment(), _payment(step: 'enter_otp')]);
      await repository.startPayment(_request);
      await repository.confirmAccount('zp_1');
      expect(remote.tokens['confirm'], isNull);
    });

    test('every response updates the device list', () async {
      final remote = _FakeRemote();
      final store = DevicePaymentsStore();
      final repository = ZakatPaymentRepositoryImpl(
        remote,
        _MemoryTokenStore(),
        store,
      );
      remote.responses.addAll([
        _payment(guestToken: 't'),
        _payment(status: 'succeeded', step: null, certificateId: 'ZC-1'),
      ]);
      await repository.startPayment(_request);
      expect(store.payments.single.status, PaymentStatus.pending);
      await repository.fetchPayment('zp_1');
      expect(store.payments.single.status, PaymentStatus.succeeded);
      expect(store.payments.single.certificateId, 'ZC-1');
    });
  });

  group('DevicePaymentsStore', () {
    test('newest first, updates in place, survives a restart', () async {
      final store = DevicePaymentsStore();
      await store.record(_payment(id: 'a'));
      await store.record(_payment(id: 'b'));
      await store.record(_payment(id: 'a', step: 'enter_otp'));
      expect(store.payments.map((p) => p.paymentId), ['b', 'a']);
      expect(store.payments.last.step, PaymentStep.enterOtp);

      final reloaded = DevicePaymentsStore();
      await reloaded.record(_payment(id: 'c'));
      expect(reloaded.payments.map((p) => p.paymentId), ['c', 'b', 'a']);
    });

    test('keeps the latest ${DevicePaymentsStore.maxEntries}', () async {
      final store = DevicePaymentsStore();
      for (var i = 0; i < DevicePaymentsStore.maxEntries + 5; i++) {
        await store.record(_payment(id: 'p$i'));
      }
      expect(store.payments, hasLength(DevicePaymentsStore.maxEntries));
      expect(store.payments.first.paymentId, 'p24');
    });

    test('unfinished: open or processing, not expired or final', () async {
      final store = DevicePaymentsStore();
      final now = DateTime.utc(2026, 10, 3, 8);
      await store.record(
        _payment(id: 'expired', expiresAt: '2026-10-03T07:00:00Z'),
      );
      expect(store.unfinished(now), isNull);

      await store.record(_payment(id: 'paid', status: 'succeeded', step: null));
      expect(store.unfinished(now), isNull);

      await store.record(
        _payment(
          id: 'open',
          step: 'enter_otp',
          expiresAt: '2026-10-03T08:10:00Z',
        ),
      );
      expect(store.unfinished(now)?.paymentId, 'open');

      await store.record(_payment(id: 'open', status: 'cancelled', step: null));
      await store.record(
        _payment(
          id: 'bank',
          step: 'processing',
          expiresAt: '2026-10-03T07:00:00Z',
        ),
      );
      expect(store.unfinished(now)?.paymentId, 'bank');
      expect(store.unfinished(now)?.isProcessing, isTrue);
    });
  });

  test('polling runs while processing and stops when final', () {
    fakeAsync((async) {
      var calls = 0;
      final repository = _PollingRepository(() {
        calls++;
        return calls < 2
            ? _payment(step: 'processing')
            : _payment(status: 'succeeded', step: null);
      });
      final bloc = PaymentFlowBloc(repository, _payment(step: 'processing'));

      async.elapse(PaymentFlowBloc.pollInterval);
      async.flushMicrotasks();
      expect(calls, 1);
      expect(bloc.state.payment.step, PaymentStep.processing);

      async.elapse(PaymentFlowBloc.pollInterval);
      async.flushMicrotasks();
      expect(calls, 2);
      expect(bloc.state.payment.status, PaymentStatus.succeeded);

      async.elapse(PaymentFlowBloc.pollInterval * 3);
      async.flushMicrotasks();
      expect(calls, 2);

      bloc.close();
      async.flushMicrotasks();
    });
  });

  test('closing the screen stops polling', () {
    fakeAsync((async) {
      var calls = 0;
      final bloc = PaymentFlowBloc(
        _PollingRepository(() {
          calls++;
          return _payment(step: 'processing');
        }),
        _payment(step: 'processing'),
      );
      bloc.close();
      async.flushMicrotasks();
      async.elapse(PaymentFlowBloc.pollInterval * 3);
      async.flushMicrotasks();
      expect(calls, 0);
    });
  });
}

class _PollingRepository implements ZakatPaymentRepository {
  _PollingRepository(this._status);

  final ZakatPayment Function() _status;

  @override
  Future<ZakatPayment> fetchPayment(String paymentId) async => _status();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
