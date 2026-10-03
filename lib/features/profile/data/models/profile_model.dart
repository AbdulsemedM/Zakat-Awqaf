import 'package:equatable/equatable.dart';

enum Madhhab { hanafi, shafii, maliki, hanbali }

enum AppLanguage { english, amharic, afaanOromoo, arabic, afanSomali }

enum AppThemePreference { light, dark }

enum BeneficiaryStatus { approved, pending, rejected }

enum FinancialInstitution {
  hijraBank,
  zamzamBank,
  coopBank,
  cbe,
  teleBirr;

  String get label => switch (this) {
    FinancialInstitution.hijraBank => 'Hijra Bank',
    FinancialInstitution.zamzamBank => 'Zamzam Bank',
    FinancialInstitution.coopBank => 'Coop Bank',
    FinancialInstitution.cbe => 'CBE',
    FinancialInstitution.teleBirr => 'TeleBirr',
  };

  bool get isAvailable => this == FinancialInstitution.coopBank;
}

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
    required this.nisabAlerts,
    required this.biometricEnabled,
    required this.language,
    required this.themePreference,
    required this.isBeneficiary,
    required this.beneficiaryStatus,
    required this.lastDisbursement,
    required this.totalAidReceived,
    this.coopBankAccountNumber,
    this.bankName,
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
  final bool nisabAlerts;
  final bool biometricEnabled;
  final AppLanguage language;
  final AppThemePreference themePreference;

  final bool isBeneficiary;
  final BeneficiaryStatus beneficiaryStatus;
  final DateTime? lastDisbursement;
  final double totalAidReceived;

  final String? coopBankAccountNumber;
  final String? bankName;
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
    bool? nisabAlerts,
    bool? biometricEnabled,
    AppLanguage? language,
    AppThemePreference? themePreference,
    bool? isBeneficiary,
    BeneficiaryStatus? beneficiaryStatus,
    DateTime? lastDisbursement,
    double? totalAidReceived,
    String? coopBankAccountNumber,
    bool clearCoopBankAccountNumber = false,
    String? bankName,
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
      nisabAlerts: nisabAlerts ?? this.nisabAlerts,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      language: language ?? this.language,
      themePreference: themePreference ?? this.themePreference,
      isBeneficiary: isBeneficiary ?? this.isBeneficiary,
      beneficiaryStatus: beneficiaryStatus ?? this.beneficiaryStatus,
      lastDisbursement: lastDisbursement ?? this.lastDisbursement,
      totalAidReceived: totalAidReceived ?? this.totalAidReceived,
      coopBankAccountNumber: clearCoopBankAccountNumber
          ? null
          : (coopBankAccountNumber ?? this.coopBankAccountNumber),
      bankName: bankName ?? this.bankName,
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
    nisabAlerts,
    biometricEnabled,
    language,
    themePreference,
    isBeneficiary,
    beneficiaryStatus,
    lastDisbursement,
    totalAidReceived,
    coopBankAccountNumber,
    bankName,
    nationalId,
    region,
    city,
    applicationCaseStatus,
    applicationMessage,
  ];
}
