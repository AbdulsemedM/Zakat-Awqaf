import 'package:injectable/injectable.dart';

import '../data_provider/profile_data_provider.dart';
import '../models/payout_bank.dart';
import '../models/profile_model.dart';
import '../models/support_contact.dart';
import 'profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._dataProvider);

  final ProfileDataProvider _dataProvider;

  @override
  Future<ProfileModel> loadProfile() => _dataProvider.fetchProfile();

  @override
  Future<List<PayoutBank>> fetchPayoutBanks() =>
      _dataProvider.fetchPayoutBanks();

  @override
  Future<ProfileModel> updateBankAccount({
    required String bankCode,
    required String accountNumber,
  }) => _dataProvider.updateBankAccount(
    bankCode: bankCode,
    accountNumber: accountNumber,
  );

  @override
  Future<SupportContact> fetchSupportContact() =>
      _dataProvider.fetchSupportContact();

  @override
  Future<void> updateProfile(ProfileModel profile) =>
      _dataProvider.persistProfile(profile);
}
