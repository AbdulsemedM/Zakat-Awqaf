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

extension BeneficiaryStatusX on BeneficiaryStatus {
  String get label {
    switch (this) {
      case BeneficiaryStatus.approved:
        return 'Approved';
      case BeneficiaryStatus.pending:
        return 'Pending';
      case BeneficiaryStatus.rejected:
        return 'Rejected';
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
    required this.isFaydaVerified,
    required this.madhhab,
    required this.nisabAlerts,
    required this.biometricEnabled,
    required this.language,
    required this.themePreference,
    required this.isBeneficiary,
    required this.beneficiaryStatus,
    required this.lastDisbursement,
    required this.totalAidReceived,
    required this.totalZakatPaid,
    required this.activeEndowments,
    required this.beneficiariesHelped,
  });

  final String name;
  final String email;
  final String phone;

  /// Optional asset path for the avatar image. When null, initials are shown.
  final String? avatarAsset;

  final String roleLabel;
  final bool isFaydaVerified;

  final Madhhab madhhab;
  final bool nisabAlerts;
  final bool biometricEnabled;
  final AppLanguage language;
  final AppThemePreference themePreference;

  final bool isBeneficiary;
  final BeneficiaryStatus beneficiaryStatus;
  final DateTime? lastDisbursement;
  final double totalAidReceived;

  final double totalZakatPaid;
  final int activeEndowments;
  final int beneficiariesHelped;

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarAsset,
    String? roleLabel,
    bool? isFaydaVerified,
    Madhhab? madhhab,
    bool? nisabAlerts,
    bool? biometricEnabled,
    AppLanguage? language,
    AppThemePreference? themePreference,
    bool? isBeneficiary,
    BeneficiaryStatus? beneficiaryStatus,
    DateTime? lastDisbursement,
    double? totalAidReceived,
    double? totalZakatPaid,
    int? activeEndowments,
    int? beneficiariesHelped,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      roleLabel: roleLabel ?? this.roleLabel,
      isFaydaVerified: isFaydaVerified ?? this.isFaydaVerified,
      madhhab: madhhab ?? this.madhhab,
      nisabAlerts: nisabAlerts ?? this.nisabAlerts,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      language: language ?? this.language,
      themePreference: themePreference ?? this.themePreference,
      isBeneficiary: isBeneficiary ?? this.isBeneficiary,
      beneficiaryStatus: beneficiaryStatus ?? this.beneficiaryStatus,
      lastDisbursement: lastDisbursement ?? this.lastDisbursement,
      totalAidReceived: totalAidReceived ?? this.totalAidReceived,
      totalZakatPaid: totalZakatPaid ?? this.totalZakatPaid,
      activeEndowments: activeEndowments ?? this.activeEndowments,
      beneficiariesHelped: beneficiariesHelped ?? this.beneficiariesHelped,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        avatarAsset,
        roleLabel,
        isFaydaVerified,
        madhhab,
        nisabAlerts,
        biometricEnabled,
        language,
        themePreference,
        isBeneficiary,
        beneficiaryStatus,
        lastDisbursement,
        totalAidReceived,
        totalZakatPaid,
        activeEndowments,
        beneficiariesHelped,
      ];
}
