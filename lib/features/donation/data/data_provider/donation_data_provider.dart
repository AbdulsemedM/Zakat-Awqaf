import '../models/donation_create_request.dart';
import '../models/donation_response.dart';

abstract class DonationDataProvider {
  Future<DonationResponse> createDonation(DonationCreateRequest request);
}
