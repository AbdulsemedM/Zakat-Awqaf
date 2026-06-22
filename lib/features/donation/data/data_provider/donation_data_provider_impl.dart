import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../donation_exception.dart';
import '../models/donation_create_request.dart';
import '../models/donation_response.dart';
import '../payment_error_message.dart';
import 'donation_data_provider.dart';

@LazySingleton(as: DonationDataProvider)
class DonationDataProviderImpl implements DonationDataProvider {
  DonationDataProviderImpl(@Named('paymentsDio') this._dio);

  final Dio _dio;

  static const _donationsPath = 'api/payments/v1/donations';

  @override
  Future<DonationResponse> createDonation(DonationCreateRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _donationsPath,
        data: request.toJson(),
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
      final parsed = parsePaymentErrorMessage(e.response?.data);
      if (parsed != null && parsed.isNotEmpty) {
        throw DonationException(parsed);
      }
      throw DonationException(e.message ?? 'Network error');
    }
  }
}
