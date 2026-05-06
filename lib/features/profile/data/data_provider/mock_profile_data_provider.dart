import 'package:injectable/injectable.dart';

import '../models/profile_model.dart';
import 'profile_data_provider.dart';

@LazySingleton(as: ProfileDataProvider)
class MockProfileDataProvider implements ProfileDataProvider {
  ProfileModel _cached = ProfileModel(
    name: 'Abdullah Ahmed',
    email: 'abdullah.ahmed@steward.com',
    phone: '+251 91 234 5678',
    avatarAsset: null,
    roleLabel: 'Verified Steward',
    isFaydaVerified: true,
    madhhab: Madhhab.hanafi,
    nisabAlerts: true,
    biometricEnabled: true,
    language: AppLanguage.english,
    themePreference: AppThemePreference.light,
    isBeneficiary: true,
    beneficiaryStatus: BeneficiaryStatus.approved,
    lastDisbursement: DateTime(2023, 10, 12),
    totalAidReceived: 15000,
    totalZakatPaid: 124500,
    activeEndowments: 3,
    beneficiariesHelped: 87,
  );

  @override
  Future<ProfileModel> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _cached;
  }

  @override
  Future<void> persistProfile(ProfileModel profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    _cached = profile;
  }
}
