import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_envelope.dart';
import '../models/zakat_payment_models.dart';

/// `/api/payments/v1` zakat endpoints. Calls for one payment or certificate
/// take the guest's `X-Payment-Token` when there is one; a signed-in donor's
/// bearer token is added by the auth interceptor.
abstract class ZakatPaymentRemoteDataProvider {
  Future<List<PaymentMethod>> fetchMethods();

  Future<ZakatPayment> startPayment(ZakatPaymentRequest request);

  Future<ZakatPayment> confirmAccount(String paymentId, {String? guestToken});

  Future<ZakatPayment> resendOtp(String paymentId, {String? guestToken});

  Future<ZakatPayment> cancel(String paymentId, {String? guestToken});

  Future<ZakatPayment> verifyOtp(
    String paymentId,
    String otp, {
    String? guestToken,
  });

  Future<ZakatPayment> fetchPayment(String paymentId, {String? guestToken});

  Future<ZakatCertificate> fetchCertificate(
    String certificateId, {
    String? guestToken,
  });

  Future<Uint8List> downloadCertificatePdf(
    String certificateId, {
    String? guestToken,
  });

  Future<PaymentHistoryPage> fetchHistory({required int page, int limit});

  Future<GivingSummary> fetchGivingSummary();
}

@LazySingleton(as: ZakatPaymentRemoteDataProvider)
class ZakatPaymentRemoteDataProviderImpl
    implements ZakatPaymentRemoteDataProvider {
  ZakatPaymentRemoteDataProviderImpl(@Named('paymentsDio') this._dio);

  final Dio _dio;

  static const _base = 'api/payments/v1';
  static const _payments = '$_base/zakat-payments';
  static const _certificates = '$_base/certificates';

  static Options? _guest(String? token) =>
      token == null ? null : Options(headers: {'X-Payment-Token': token});

  static String _id(String id) => Uri.encodeComponent(id);

  @override
  Future<List<PaymentMethod>> fetchMethods() => guardApi(() async {
    final response = await _dio.get<dynamic>(
      '$_base/methods',
      queryParameters: const {'purpose': 'zakat'},
    );
    final data = unwrapApiData(response);
    return [
      if (data is List)
        for (final row in data)
          if (row is Map)
            PaymentMethod.fromJson(Map<String, dynamic>.from(row)),
    ];
  });

  @override
  Future<ZakatPayment> startPayment(ZakatPaymentRequest request) =>
      guardApi(() async {
        final response = await _dio.post<dynamic>(
          _payments,
          data: request.toJson(),
        );
        return ZakatPayment.fromJson(unwrapApiObject(response));
      });

  Future<ZakatPayment> _action(
    String paymentId,
    String action, {
    String? guestToken,
    Object? body,
  }) => guardApi(() async {
    final response = await _dio.post<dynamic>(
      '$_payments/${_id(paymentId)}/$action',
      data: body,
      options: _guest(guestToken),
    );
    return ZakatPayment.fromJson(unwrapApiObject(response));
  });

  @override
  Future<ZakatPayment> confirmAccount(String paymentId, {String? guestToken}) =>
      _action(paymentId, 'confirm', guestToken: guestToken);

  @override
  Future<ZakatPayment> resendOtp(String paymentId, {String? guestToken}) =>
      _action(paymentId, 'resend-otp', guestToken: guestToken);

  @override
  Future<ZakatPayment> cancel(String paymentId, {String? guestToken}) =>
      _action(paymentId, 'cancel', guestToken: guestToken);

  @override
  Future<ZakatPayment> verifyOtp(
    String paymentId,
    String otp, {
    String? guestToken,
  }) => _action(
    paymentId,
    'verify-otp',
    guestToken: guestToken,
    body: {'otp': otp},
  );

  @override
  Future<ZakatPayment> fetchPayment(String paymentId, {String? guestToken}) =>
      guardApi(() async {
        final response = await _dio.get<dynamic>(
          '$_payments/${_id(paymentId)}',
          options: _guest(guestToken),
        );
        return ZakatPayment.fromJson(unwrapApiObject(response));
      });

  @override
  Future<ZakatCertificate> fetchCertificate(
    String certificateId, {
    String? guestToken,
  }) => guardApi(() async {
    final response = await _dio.get<dynamic>(
      '$_certificates/${_id(certificateId)}',
      options: _guest(guestToken),
    );
    return ZakatCertificate.fromJson(unwrapApiObject(response));
  });

  @override
  Future<Uint8List> downloadCertificatePdf(
    String certificateId, {
    String? guestToken,
  }) => guardApi(() async {
    final response = await _dio.get<List<int>>(
      '$_certificates/${_id(certificateId)}/pdf',
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'X-Payment-Token': ?guestToken, 'Accept': 'application/pdf'},
      ),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw const ApiException('Empty certificate PDF');
    }
    return Uint8List.fromList(bytes);
  });

  @override
  Future<GivingSummary> fetchGivingSummary() => guardApi(() async {
    final response = await _dio.get<dynamic>('$_base/me/giving-summary');
    return GivingSummary.fromJson(unwrapApiObject(response));
  });

  @override
  Future<PaymentHistoryPage> fetchHistory({
    required int page,
    int limit = 20,
  }) => guardApi(() async {
    final response = await _dio.get<dynamic>(
      '$_base/me/payments',
      queryParameters: {'type': 'zakat', 'page': page, 'limit': limit},
    );
    return PaymentHistoryPage.fromJson(unwrapApiObject(response));
  });
}
