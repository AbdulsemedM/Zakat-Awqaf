import '../models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> loadProfile();

  Future<void> updateProfile(ProfileModel profile);
}
