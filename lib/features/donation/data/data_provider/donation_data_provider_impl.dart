import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/auth/auth_interceptor.dart';
import '../donation_exception.dart';
import '../models/donation_create_request.dart';
import '../models/donation_details.dart';
import '../models/donation_response.dart';
import '../payment_error_message.dart';
import 'donation_data_provider.dart';

@LazySingleton(as: DonationDataProvider)
class DonationDataProviderImpl implements DonationDataProvider {
  DonationDataProviderImpl(@Named('paymentsDio') this._dio);

  final Dio _dio;

  static const _donationsPath = 'api/payments/v1/donations';

  /// No bearer token: an anonymous donation must not be tied to the
  /// signed-in user, and the donation token alone opens a donation.
  static final _withoutAuth = Options(
    extra: {AuthInterceptor.skipAuthKey: true},
  );

  @override
  Future<DonationResponse> createDonation(DonationCreateRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _donationsPath,
        data: request.toJson(),
        // REGISTERED needs the donor's bearer token, which the interceptor
        // adds.
        options: request.donorMode == DonorMode.registered.apiValue
            ? null
            : _withoutAuth,
      );
      final status = response.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        throw DonationException('Unexpected status: $status');
      }
      final body = response.data;
      if (body == null) {
        throw DonationException('Empty response body');
      }
      final parsed = DonationResponse.fromJson(body);
      if (!parsed.success) {
        throw DonationException(
          parsed.message ?? 'Donation request was not successful',
        );
      }
      return parsed;
    } on DonationException {
      rethrow;
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  @override
  Future<DonationDetails> fetchDonation(String donationId, String token) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_donationsPath/${Uri.encodeComponent(donationId)}',
        options: _withoutAuth.copyWith(headers: {'X-Donation-Token': token}),
      );
      final data = response.data?['data'];
      if (data is! Map) {
        throw DonationException('Empty response body');
      }
      return DonationDetails.fromJson(Map<String, dynamic>.from(data));
    } on DonationException {
      rethrow;
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  DonationException _fromDio(DioException e) {
    final statusCode = e.response?.statusCode;
    final parsed = parsePaymentErrorMessage(e.response?.data);
    return DonationException(
      parsed != null && parsed.isNotEmpty
          ? parsed
          : e.message ?? 'Network error',
      statusCode: statusCode,
    );
  }
}
