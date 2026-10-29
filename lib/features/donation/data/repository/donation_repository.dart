import '../models/donation_create_request.dart';
import '../models/donation_details.dart';
import '../models/donation_response.dart';

abstract class DonationRepository {
  /// Creates the donation and keeps its token in secure storage.
  Future<DonationResponse> createDonation(DonationCreateRequest request);

  /// Throws [DonationException] with status 404 when this device has no
  /// token for [donationId] (the server answers the same way).
  Future<DonationDetails> fetchDonation(String donationId);
}
