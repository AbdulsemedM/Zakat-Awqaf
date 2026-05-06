import 'package:injectable/injectable.dart';

import '../data_provider/profile_data_provider.dart';
import '../models/profile_model.dart';
import 'profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._dataProvider);

  final ProfileDataProvider _dataProvider;

  @override
  Future<ProfileModel> loadProfile() => _dataProvider.fetchProfile();

  @override
  Future<void> updateProfile(ProfileModel profile) =>
      _dataProvider.persistProfile(profile);
}
