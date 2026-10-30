import '../models/payout_bank.dart';
import '../models/profile_model.dart';
import '../models/support_contact.dart';

abstract class ProfileDataProvider {
  Future<ProfileModel> fetchProfile();

  /// Banks a beneficiary can be paid to (signed in).
  Future<List<PayoutBank>> fetchPayoutBanks();

  Future<ProfileModel> updateBankAccount({
    required String bankCode,
    required String accountNumber,
  });

  /// Public. Fetched each time it is shown: an admin can change it.
  Future<SupportContact> fetchSupportContact();

  Future<void> persistProfile(ProfileModel profile);
}
