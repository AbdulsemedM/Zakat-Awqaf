import '../../../core/auth/auth_token_storage.dart';
import '../../beneficiary_registration/data/models/beneficiary_dto.dart';
import 'models/profile_model.dart';

abstract final class ProfileMapper {
  ProfileMapper._();

  static ProfileModel fromBeneficiary(
    BeneficiaryDto dto, {
    required ProfileModel localOverlay,
  }) {
    return localOverlay.copyWith(
      name: dto.fullName?.trim().isNotEmpty == true
          ? dto.fullName!.trim()
          : localOverlay.name,
      email: dto.email?.trim().isNotEmpty == true
          ? dto.email!.trim()
          : localOverlay.email,
      phone: dto.phone?.trim().isNotEmpty == true
          ? dto.phone!.trim()
          : localOverlay.phone,
      roleLabel: 'Beneficiary',
      isFaydaVerified: _isFaydaVerified(dto),
      isBeneficiary: true,
      beneficiaryStatus: _mapVerificationStatus(dto.verificationStatus),
      bankName: dto.bankName,
      coopBankAccountNumber: dto.accountNumber,
      nationalId: dto.nationalId,
      region: dto.region,
      city: dto.city,
    );
  }

  static ProfileModel fromSessionUser(
    StoredAuthUser user, {
    required ProfileModel localOverlay,
  }) {
    final roleLabel = user.isBeneficiary ? 'Beneficiary' : 'Donor';
    return localOverlay.copyWith(
      name: user.name,
      email: user.email,
      phone: user.phone,
      roleLabel: roleLabel,
      isBeneficiary: user.isBeneficiary,
      beneficiaryStatus: user.isBeneficiary
          ? BeneficiaryStatus.pending
          : BeneficiaryStatus.pending,
      isFaydaVerified: user.isBeneficiary,
    );
  }

  static ProfileModel defaultLocalOverlay() => const ProfileModel(
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

  static BeneficiaryStatus _mapVerificationStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
      case 'verified':
        return BeneficiaryStatus.approved;
      case 'rejected':
        return BeneficiaryStatus.rejected;
      default:
        return BeneficiaryStatus.pending;
    }
  }

  static bool _isFaydaVerified(BeneficiaryDto dto) {
    final status = dto.verificationStatus?.toLowerCase();
    if (status == 'approved' || status == 'verified') {
      return true;
    }
    return dto.hasProfilePicture == true ||
        (dto.nationalId?.trim().isNotEmpty ?? false);
  }
}
