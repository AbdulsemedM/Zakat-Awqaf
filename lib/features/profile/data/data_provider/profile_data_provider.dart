import '../models/profile_model.dart';

abstract class ProfileDataProvider {
  Future<ProfileModel> fetchProfile();

  Future<void> persistProfile(ProfileModel profile);
}
