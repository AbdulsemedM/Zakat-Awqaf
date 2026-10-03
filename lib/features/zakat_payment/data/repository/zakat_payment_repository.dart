import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import '../data_provider/device_payments_store.dart';
import '../data_provider/guest_payment_token_store.dart';
import '../data_provider/zakat_payment_remote_data_provider.dart';
import '../models/zakat_payment_models.dart';

/// Zakat payments, certificates and history. Saves a guest's token from
/// step 1 and sends it on every later call for that payment or certificate,
/// and records every payment on this device ([DevicePaymentsStore]).
abstract class ZakatPaymentRepository {
  Future<List<PaymentMethod>> fetchMethods();

  Future<ZakatPayment> startPayment(ZakatPaymentRequest request);

  Future<ZakatPayment> confirmAccount(String paymentId);

  Future<ZakatPayment> resendOtp(String paymentId);

  Future<ZakatPayment> cancel(String paymentId);

  Future<ZakatPayment> verifyOtp(String paymentId, String otp);

  Future<ZakatPayment> fetchPayment(String paymentId);

  Future<ZakatCertificate> fetchCertificate(String certificateId);

  Future<Uint8List> downloadCertificatePdf(String certificateId);

  Future<PaymentHistoryPage> fetchHistory({required int page});
}

@LazySingleton(as: ZakatPaymentRepository)
class ZakatPaymentRepositoryImpl implements ZakatPaymentRepository {
  ZakatPaymentRepositoryImpl(this._remote, this._tokens, this._devicePayments);

  final ZakatPaymentRemoteDataProvider _remote;
  final GuestPaymentTokenStore _tokens;
  final DevicePaymentsStore _devicePayments;

  Future<ZakatPayment> _remember(ZakatPayment payment) async {
    final token = payment.guestToken;
    if (token != null) {
      await _tokens.savePaymentToken(payment.paymentId, token);
    }
    final certificateId = payment.certificateId;
    if (certificateId != null) {
      await _tokens.linkCertificate(certificateId, payment.paymentId);
    }
    await _devicePayments.record(payment);
    return payment;
  }

  Future<ZakatPayment> _withToken(
    String paymentId,
    Future<ZakatPayment> Function(String? token) call,
  ) async {
    final token = await _tokens.tokenForPayment(paymentId);
    return _remember(await call(token));
  }

  @override
  Future<List<PaymentMethod>> fetchMethods() => _remote.fetchMethods();

  @override
  Future<ZakatPayment> startPayment(ZakatPaymentRequest request) async =>
      _remember(await _remote.startPayment(request));

  @override
  Future<ZakatPayment> confirmAccount(String paymentId) => _withToken(
    paymentId,
    (token) => _remote.confirmAccount(paymentId, guestToken: token),
  );

  @override
  Future<ZakatPayment> resendOtp(String paymentId) => _withToken(
    paymentId,
    (token) => _remote.resendOtp(paymentId, guestToken: token),
  );

  @override
  Future<ZakatPayment> cancel(String paymentId) => _withToken(
    paymentId,
    (token) => _remote.cancel(paymentId, guestToken: token),
  );

  @override
  Future<ZakatPayment> verifyOtp(String paymentId, String otp) => _withToken(
    paymentId,
    (token) => _remote.verifyOtp(paymentId, otp, guestToken: token),
  );

  @override
  Future<ZakatPayment> fetchPayment(String paymentId) => _withToken(
    paymentId,
    (token) => _remote.fetchPayment(paymentId, guestToken: token),
  );

  @override
  Future<ZakatCertificate> fetchCertificate(String certificateId) async =>
      _remote.fetchCertificate(
        certificateId,
        guestToken: await _tokens.tokenForCertificate(certificateId),
      );

  @override
  Future<Uint8List> downloadCertificatePdf(String certificateId) async =>
      _remote.downloadCertificatePdf(
        certificateId,
        guestToken: await _tokens.tokenForCertificate(certificateId),
      );

  @override
  Future<PaymentHistoryPage> fetchHistory({required int page}) =>
      _remote.fetchHistory(page: page);
}
