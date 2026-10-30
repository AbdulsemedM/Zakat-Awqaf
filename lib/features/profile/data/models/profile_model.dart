import 'package:equatable/equatable.dart';

enum Madhhab { hanafi, shafii, maliki, hanbali }

enum AppLanguage { english, amharic, afaanOromoo, arabic, afanSomali }

enum AppThemePreference { light, dark }

enum BeneficiaryStatus { approved, pending, rejected }

extension MadhhabX on Madhhab {
  String get label {
    switch (this) {
      case Madhhab.hanafi:
        return 'Hanafi';
      case Madhhab.shafii:
        return "Shafi'i";
      case Madhhab.maliki:
        return 'Maliki';
      case Madhhab.hanbali:
        return 'Hanbali';
    }
  }
}

extension AppLanguageX on AppLanguage {
  String get label {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.amharic:
        return 'Amharic';
      case AppLanguage.afaanOromoo:
        return 'Afaan Oromoo';
      case AppLanguage.arabic:
        return 'Arabic';
      case AppLanguage.afanSomali:
        return 'Afan Somali';
    }
  }
}

extension AppThemePreferenceX on AppThemePreference {
  String get label {
    switch (this) {
      case AppThemePreference.light:
        return 'Light';
      case AppThemePreference.dark:
        return 'Dark';
    }
  }
}

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarAsset,
    required this.roleLabel,
    required this.madhhab,
    required this.language,
    required this.themePreference,
    required this.isBeneficiary,
    this.isDonor = false,
    required this.beneficiaryStatus,
    this.coopBankAccountNumber,
    this.bankName,
    this.bankCode,
    this.lastDisbursementAmountEtb,
    this.lastDisbursementPaidAt,
    this.totalAidReceivedEtb,
    this.nationalId,
    this.region,
    this.city,
    this.applicationCaseStatus,
    this.applicationMessage,
  });

  final String name;
  final String email;
  final String phone;

  /// Optional asset path for the avatar image. When null, initials are shown.
  final String? avatarAsset;

  final String roleLabel;

  final Madhhab madhhab;
  final AppLanguage language;
  final AppThemePreference themePreference;

  final bool isBeneficiary;

  /// A donor account (`DONOR` and no beneficiary or staff role): pays zakat,
  /// has payment history and giving figures.
  final bool isDonor;
  final BeneficiaryStatus beneficiaryStatus;

  /// The payout account number (any payout bank, despite the name).
  final String? coopBankAccountNumber;
  final String? bankName;

  /// The payout bank's code (`GET /payout-banks`).
  final String? bankCode;

  /// The beneficiary's last payout; `null` until there is one.
  final double? lastDisbursementAmountEtb;
  final DateTime? lastDisbursementPaidAt;

  /// All payouts so far; `0` before the first one, `null` when the server
  /// did not say.
  final double? totalAidReceivedEtb;
  final String? nationalId;
  final String? region;
  final String? city;

  // From `GET /me/application` (beneficiary-safe fields only).
  /// `SUBMITTED`, `VERIFIED`, `APPROVED`, `ACTIVE` or `CLOSED`.
  final String? applicationCaseStatus;

  /// `verificationReason`: staff's reason, e.g. on rejection.
  final String? applicationMessage;

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarAsset,
    String? roleLabel,
    Madhhab? madhhab,
    AppLanguage? language,
    AppThemePreference? themePreference,
    bool? isBeneficiary,
    bool? isDonor,
    BeneficiaryStatus? beneficiaryStatus,
    String? coopBankAccountNumber,
    bool clearCoopBankAccountNumber = false,
    String? bankName,
    String? bankCode,
    double? lastDisbursementAmountEtb,
    DateTime? lastDisbursementPaidAt,
    double? totalAidReceivedEtb,
    String? nationalId,
    String? region,
    String? city,
    String? applicationCaseStatus,
    String? applicationMessage,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      roleLabel: roleLabel ?? this.roleLabel,
      madhhab: madhhab ?? this.madhhab,
      language: language ?? this.language,
      themePreference: themePreference ?? this.themePreference,
      isBeneficiary: isBeneficiary ?? this.isBeneficiary,
      isDonor: isDonor ?? this.isDonor,
      beneficiaryStatus: beneficiaryStatus ?? this.beneficiaryStatus,
      coopBankAccountNumber: clearCoopBankAccountNumber
          ? null
          : (coopBankAccountNumber ?? this.coopBankAccountNumber),
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      lastDisbursementAmountEtb:
          lastDisbursementAmountEtb ?? this.lastDisbursementAmountEtb,
      lastDisbursementPaidAt:
          lastDisbursementPaidAt ?? this.lastDisbursementPaidAt,
      totalAidReceivedEtb: totalAidReceivedEtb ?? this.totalAidReceivedEtb,
      nationalId: nationalId ?? this.nationalId,
      region: region ?? this.region,
      city: city ?? this.city,
      applicationCaseStatus:
          applicationCaseStatus ?? this.applicationCaseStatus,
      applicationMessage: applicationMessage ?? this.applicationMessage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    avatarAsset,
    roleLabel,
    madhhab,
    language,
    themePreference,
    isBeneficiary,
    isDonor,
    beneficiaryStatus,
    coopBankAccountNumber,
    bankName,
    bankCode,
    lastDisbursementAmountEtb,
    lastDisbursementPaidAt,
    totalAidReceivedEtb,
    nationalId,
    region,
    city,
    applicationCaseStatus,
    applicationMessage,
  ];
}
