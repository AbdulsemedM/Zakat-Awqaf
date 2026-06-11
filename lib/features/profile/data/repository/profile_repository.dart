import '../models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> loadProfile();

  Future<ProfileModel> updateBankAccount({
    required String bankName,
    required String accountNumber,
  });

  Future<void> updateProfile(ProfileModel profile);
}
