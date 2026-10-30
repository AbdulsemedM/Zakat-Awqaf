import '../models/payout_bank.dart';
import '../models/profile_model.dart';
import '../models/support_contact.dart';

abstract class ProfileRepository {
  Future<ProfileModel> loadProfile();

  Future<List<PayoutBank>> fetchPayoutBanks();

  Future<ProfileModel> updateBankAccount({
    required String bankCode,
    required String accountNumber,
  });

  Future<SupportContact> fetchSupportContact();

  Future<void> updateProfile(ProfileModel profile);
}
