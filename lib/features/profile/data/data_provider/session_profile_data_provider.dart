import '../../../../core/auth/auth_token_storage.dart';
import '../models/profile_model.dart';
import 'profile_data_provider.dart';

class SessionProfileDataProvider implements ProfileDataProvider {
  SessionProfileDataProvider(this._tokenStorage);

  final AuthTokenStorage _tokenStorage;

  ProfileModel _cached = const ProfileModel(
    name: 'Guest',
    email: '',
    phone: '',
    avatarAsset: null,
    roleLabel: 'Member',
    isFaydaVerified: false,
    madhhab: Madhhab.hanafi,
    nisabAlerts: true,
    biometricEnabled: false,
    language: AppLanguage.english,
    themePreference: AppThemePreference.light,
    isBeneficiary: false,
    beneficiaryStatus: BeneficiaryStatus.pending,
    lastDisbursement: null,
    totalAidReceived: 0,
    totalZakatPaid: 0,
    activeEndowments: 0,
    beneficiariesHelped: 0,
  );

  @override
  Future<ProfileModel> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final user = await _tokenStorage.readUser();
    if (user == null) {
      return _cached;
    }
    final roleLabel = user.isBeneficiary ? 'Beneficiary' : 'Donor';
    _cached = _cached.copyWith(
      name: user.name,
      email: user.email,
      phone: user.phone,
      roleLabel: roleLabel,
      isFaydaVerified: true,
      isBeneficiary: user.isBeneficiary,
      beneficiaryStatus: user.isBeneficiary
          ? BeneficiaryStatus.approved
          : BeneficiaryStatus.pending,
    );
    return _cached;
  }

  @override
  Future<ProfileModel> updateBankAccount({
    required String bankName,
    required String accountNumber,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    _cached = _cached.copyWith(
      bankName: bankName,
      coopBankAccountNumber: accountNumber,
    );
    return _cached;
  }

  @override
  Future<void> persistProfile(ProfileModel profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    _cached = profile;
  }
}
