import '../models/donation_create_request.dart';
import '../models/donation_response.dart';

abstract class DonationRepository {
  Future<DonationResponse> createDonation(DonationCreateRequest request);
}
