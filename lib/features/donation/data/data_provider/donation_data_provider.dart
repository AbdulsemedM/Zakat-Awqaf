import '../models/donation_create_request.dart';
import '../models/donation_details.dart';
import '../models/donation_response.dart';

abstract class DonationDataProvider {
  Future<DonationResponse> createDonation(DonationCreateRequest request);

  /// `GET /donations/{id}` with the donation's `X-Donation-Token`.
  Future<DonationDetails> fetchDonation(String donationId, String token);
}
