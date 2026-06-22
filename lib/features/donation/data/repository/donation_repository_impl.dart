import 'package:injectable/injectable.dart';

import '../data_provider/donation_data_provider.dart';
import '../models/donation_create_request.dart';
import '../models/donation_response.dart';
import 'donation_repository.dart';

@LazySingleton(as: DonationRepository)
class DonationRepositoryImpl implements DonationRepository {
  DonationRepositoryImpl(this._dataProvider);

  final DonationDataProvider _dataProvider;

  @override
  Future<DonationResponse> createDonation(DonationCreateRequest request) {
    return _dataProvider.createDonation(request);
  }
}
