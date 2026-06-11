import '../models/profile_model.dart';

abstract class ProfileDataProvider {
  Future<ProfileModel> fetchProfile();

  Future<ProfileModel> updateBankAccount({
    required String bankName,
    required String accountNumber,
  });

  Future<void> persistProfile(ProfileModel profile);
}
