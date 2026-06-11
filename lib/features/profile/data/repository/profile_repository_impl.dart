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
  Future<ProfileModel> updateBankAccount({
    required String bankName,
    required String accountNumber,
  }) =>
      _dataProvider.updateBankAccount(
        bankName: bankName,
        accountNumber: accountNumber,
      );

  @override
  Future<void> updateProfile(ProfileModel profile) =>
      _dataProvider.persistProfile(profile);
}
