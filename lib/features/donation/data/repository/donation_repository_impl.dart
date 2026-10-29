import 'package:injectable/injectable.dart';

import '../data_provider/donation_data_provider.dart';
import '../data_provider/donation_token_store.dart';
import '../donation_exception.dart';
import '../models/donation_create_request.dart';
import '../models/donation_details.dart';
import '../models/donation_response.dart';
import 'donation_repository.dart';

@LazySingleton(as: DonationRepository)
class DonationRepositoryImpl implements DonationRepository {
  DonationRepositoryImpl(this._dataProvider, this._tokens);

  final DonationDataProvider _dataProvider;
  final DonationTokenStore _tokens;

  @override
  Future<DonationResponse> createDonation(DonationCreateRequest request) async {
    final response = await _dataProvider.createDonation(request);
    final id = response.donationId;
    final token = response.donationToken;
    if (id != null && token != null) {
      await _tokens.saveToken(id, token);
    }
    return response;
  }

  @override
  Future<DonationDetails> fetchDonation(String donationId) async {
    final token = await _tokens.tokenForDonation(donationId);
    if (token == null) {
      throw DonationException('Donation not found', statusCode: 404);
    }
    return _dataProvider.fetchDonation(donationId, token);
  }
}
