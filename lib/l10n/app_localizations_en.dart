// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Zakat & Awqaf Commission';

  @override
  String get navHome => 'Home';

  @override
  String get navCalculator => 'Calculator';

  @override
  String get navImpact => 'Impact';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeCommissionTitle => 'Zakat and Awqaf Commission';

  @override
  String get homeGreeting => 'Assalamu\'alaikum';

  @override
  String get registerAcceptZakat => 'Register to Accept Zakat';

  @override
  String get urgentBeneficiaryNeeds => 'Urgent Beneficiary Needs';

  @override
  String get viewAll => 'View All';

  @override
  String get totalZakatCollected => 'TOTAL ZAKAT COLLECTED';

  @override
  String get thisMonth => 'This month';

  @override
  String get totalBeneficiariesSupported => 'Total beneficiaries supported';

  @override
  String get transparencyQuote =>
      'Transparent, accountable, and impactful: your giving powers nationwide relief and empowerment.';

  @override
  String get payZakatCause => 'Pay Zakat to this cause';

  @override
  String get zakatAlFitr => 'Zakat Al-Fitr';

  @override
  String get zakatDueDays => 'Due in approximately 22 days.';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get needQuickWayGive => 'Need a quick way to give?';

  @override
  String get supportCommunityNeeds =>
      'Support ongoing community needs instantly with Sadaqah.';

  @override
  String get donateSadaqah => 'Donate Sadaqah';

  @override
  String get aboutCommission => 'About Ethiopian Zakat and Awqaf Commission';

  @override
  String get aboutCommissionBody =>
      'The Ethiopian Zakat and Awqaf Commission coordinates zakat collection and awqaf development to uplift vulnerable communities through transparent, Shariah-aligned programs.';

  @override
  String get chipTransparencyFirst => 'Transparency-first';

  @override
  String get chipNationwideImpact => 'Nationwide impact';

  @override
  String get chipShariahAligned => 'Shariah aligned';

  @override
  String get profileLanguagePreferences => 'Language Preferences';

  @override
  String get profileThemeMode => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get profileBiometricLogin => 'Biometric Login';

  @override
  String get profileBiometricSubtitle => 'Use fingerprint or face ID';

  @override
  String get missingPaymentDetails => 'Missing payment details.';

  @override
  String get missingCertificateDetails => 'Missing certificate details.';

  @override
  String get calcAppBarTitle => 'Zakat Calculator';

  @override
  String get calcPayYourZakat => 'Pay Your Zakat';

  @override
  String get calcTabWealth => 'Wealth';

  @override
  String get calcTabLivestock => 'Livestock';

  @override
  String get calcTabCrops => 'Crops';

  @override
  String get calcStep1NisabTitle => 'Step 1: Nisab threshold';

  @override
  String get calcStep1NisabBody =>
      'Zakat is due if your net wealth exceeds the threshold. Nisab is based on 85g of platform 24k gold price.';

  @override
  String calcNisabGoldFormula(String grams, String price, String total) {
    return '$grams × $price = $total';
  }

  @override
  String calcNisabThresholdBanner(String amount) {
    return 'Nisab threshold (platform rate, 85g gold equivalent): $amount';
  }

  @override
  String get calcUsdEtb => 'USD/ETB';

  @override
  String get calcFxLive => 'Using live exchange rate';

  @override
  String get calcFxCache => 'Using cached exchange rate';

  @override
  String get calcFxFallback => 'Using fallback exchange rate';

  @override
  String get calcTimestampUnavailable => 'timestamp unavailable';

  @override
  String get calcStep1LivestockTitle => 'Step 1: Livestock scale method';

  @override
  String get calcStep1LivestockBody =>
      'Livestock Zakat is calculated by physical head-count scales (not % of value).';

  @override
  String get calcStep1LivestockNisabNote =>
      'Nisab thresholds: Sheep/Goats 40, Cattle 30, Camels 5. Cattle uses 30/40 combinations; camels follow tier ranges.';

  @override
  String calcAdvisoryPrefix(String text) {
    return 'Advisory: $text';
  }

  @override
  String get calcArabicTermDefinitionsTitle => 'Arabic Term Definitions';

  @override
  String get calcArabicDefTabi => 'one-year-old calf';

  @override
  String get calcArabicDefMusinnah => 'two-year-old cow';

  @override
  String get calcArabicDefBintMakhad => 'one-year-old she-camel';

  @override
  String get calcArabicDefBintLabun => 'two-year-old she-camel';

  @override
  String get calcArabicDefHiqqah => 'three-year-old she-camel';

  @override
  String get calcArabicDefJadhah => 'four-year-old she-camel';

  @override
  String get calcStep1CropTitle => 'Step 1: Crop (Ushr) calculation';

  @override
  String get calcStep1CropBody =>
      'Crop Zakat is due at harvest. Nisab is 653kg. Rate is 10% (rain-fed), 5% (irrigated), or weighted for mixed.';

  @override
  String calcCropLineThreshold(String kg, String relation) {
    return '$kg kg $relation 653 kg';
  }

  @override
  String calcCropLineIrrigation(String mode) {
    return 'Irrigation mode: $mode';
  }

  @override
  String calcCropLineEffectiveRate(String rate) {
    return 'Effective rate: $rate%';
  }

  @override
  String calcCropLineFormula(String line) {
    return 'Formula: $line';
  }

  @override
  String get calcRelationGte => '≥';

  @override
  String get calcRelationLt => '<';

  @override
  String get calcOverviewNetWorthTitle => 'Net Worth Overview';

  @override
  String get calcOverviewLivestockTitle => 'Livestock Overview';

  @override
  String get calcOverviewCropTitle => 'Crop Overview';

  @override
  String get calcBadgeAboveNisab => 'Above Nisab';

  @override
  String get calcBadgeBelowNisab => 'Below Nisab';

  @override
  String get calcBadgeZakatDue => 'Zakat Due';

  @override
  String get calcBadgeNoDue => 'No Due';

  @override
  String get calcZakatDueLabel => 'Zakat Due';

  @override
  String get calcLivestockDueLabel => 'Livestock Due';

  @override
  String get calcCropZakatDueLabel => 'Crop Zakat Due';

  @override
  String calcAnimalsCount(int count) {
    return '$count animals';
  }

  @override
  String calcKgHarvest(String kg) {
    return '$kg kg harvest';
  }

  @override
  String get calcLivestockTermsFootnote =>
      'Terms like tabi\', musinnah, bint makhad, bint labun, hiqqah, and jadhah are explained below in Livestock details.';

  @override
  String get calcStep2EnterAssets => 'Step 2: Enter Your Assets';

  @override
  String get calcStep2EnterAssetsBody =>
      'Enter the value of your assets in ETB';

  @override
  String get calcCashBankSavings => 'Cash & Bank Savings';

  @override
  String get calcCashOnHand => 'Cash on Hand';

  @override
  String get calcBankBalance => 'Bank Balance';

  @override
  String get calcMobileWallet => 'Mobile Wallet';

  @override
  String get calcBusinessAssets => 'Business Assets';

  @override
  String get calcFieldDescription => 'Description';

  @override
  String get calcFieldType => 'Type';

  @override
  String get calcAmountEtb => 'Amount (ETB)';

  @override
  String get calcAddBusinessAsset => 'Add business asset';

  @override
  String get calcGoldSilver => 'Gold & Silver';

  @override
  String get calcGoldGrams => 'Gold (grams)';

  @override
  String get calcGoldKarat => 'Gold Karat';

  @override
  String get calcSilverGrams => 'Silver (grams)';

  @override
  String get calcLiabilities => 'Liabilities';

  @override
  String get calcAddLiability => 'Add liability';

  @override
  String get calcAssetInventory => 'Inventory';

  @override
  String get calcAssetReceivable => 'Receivable';

  @override
  String get calcAssetOther => 'Other';

  @override
  String get calcLiabilityShortTermDebt => 'Short-term debt';

  @override
  String get calcLiabilityPayable => 'Payable';

  @override
  String get calcLiabilityOther => 'Other';

  @override
  String get calcLivestockSheepGoats => 'Sheep / Goats';

  @override
  String get calcLivestockCattle => 'Cattle';

  @override
  String get calcLivestockCamels => 'Camels';

  @override
  String get calcPastureFedTitle => 'Pasture-fed most of the year';

  @override
  String get calcPastureFedSubtitle =>
      'Advisory only; does not block calculation';

  @override
  String get calcHawlTitle => 'Completed one lunar year (hawl)';

  @override
  String get calcHawlSubtitle => 'Advisory only; does not block calculation';

  @override
  String get calcWorkAnimalsTitle => 'Used for work (plowing/transport)';

  @override
  String get calcWorkAnimalsSubtitle =>
      'Advisory only; does not block calculation';

  @override
  String get calcLivestockSummaryHeading => 'Livestock summary';

  @override
  String get calcCropNisabHeading => 'Nisab & crop due';

  @override
  String calcEffectiveCropRateLine(String percent) {
    return 'Effective crop rate: $percent%';
  }

  @override
  String calcCropZakatDueKgLine(String kg) {
    return 'Crop Zakat due: $kg kg';
  }

  @override
  String get calcHowCropZakatWorksTitle => 'How crop Zakat works';

  @override
  String get calcHowCropZakatWorksBody =>
      'Nisab: 653kg. Rates: rain-fed 10%, irrigated 5%, mixed = weighted split. Zakat is due at harvest (no annual hawl for crops).';

  @override
  String get calcHowCropZakatNote =>
      'Note: App applies these rules broadly for simplicity. Scholarly positions differ on crop-type scope and expense deductions; consult qualified scholars for specific cases.';

  @override
  String get calcCropWeightKg => 'Crop Weight (kg)';

  @override
  String get calcCropModeRainFed => 'Rain-fed';

  @override
  String get calcCropModeIrrigated => 'Irrigated';

  @override
  String get calcCropModeMixed => 'Mixed';

  @override
  String get calcRainFedSharePct => 'Rain-fed share %';

  @override
  String get calcIrrigatedSharePct => 'Irrigated share %';

  @override
  String get calcGoldK24 => '24k';

  @override
  String get calcGoldK22 => '22k';

  @override
  String get calcGoldK21 => '21k';

  @override
  String get calcGoldK18 => '18k';

  @override
  String get calcGoldK14 => '14k';

  @override
  String get calcMethodologyPlaceholder =>
      'Zakat methodology content placeholder.';

  @override
  String get calcPayBlockedWealth =>
      'No wealth Zakat is due (below nisab or zero ETB due). Adjust your inputs.';

  @override
  String get calcPayBlockedLivestock =>
      'No livestock Zakat is due for your current counts.';

  @override
  String get calcPayBlockedCrops =>
      'Crop Zakat is not due yet (below harvest nisab or zero kg due).';

  @override
  String calcCertCropDueLine(String kg) {
    return 'Crop Zakat due: $kg kg';
  }

  @override
  String get calcBulletSeparator => ' • ';

  @override
  String calcLsSheepGoats(int count) {
    return 'Sheep/Goats: $count sheep';
  }

  @override
  String calcLsCattle(int tabi, int musinnah) {
    return 'Cattle: $tabi tabi\' + $musinnah musinnah';
  }

  @override
  String calcLsCamels(String description) {
    return 'Camels: $description';
  }

  @override
  String get calcLsNone => 'No livestock due under current counts';

  @override
  String calcTransSheep(int head, int due) {
    return 'Sheep/Goats threshold: $head >= 40 => due $due sheep.';
  }

  @override
  String calcTransCattle(int head, int tabi, int musinnah) {
    return 'Cattle threshold: $head >= 30 => due $tabi tabi\', $musinnah musinnah (30/40 combination).';
  }

  @override
  String calcTransCamel(int head, String due) {
    return 'Camel threshold: $head >= 5 => due $due.';
  }

  @override
  String calcTransAdvisoryLine(String text) {
    return 'Advisory: $text';
  }

  @override
  String get calcAdvNotPasture =>
      'Not pasture-fed most of the year: check trade/business treatment with scholars.';

  @override
  String get calcAdvHawl =>
      'Hawl not completed: many scholars require one lunar year for livestock zakat.';

  @override
  String get calcAdvWork =>
      'Work animals are typically exempt from livestock zakat.';

  @override
  String calcCropTransBelow(String kg, String nisab) {
    return 'Harvest ${kg}kg is below Nisab ($nisab kg), so no crop Zakat is due.';
  }

  @override
  String calcCropTransMixed(
    String rain,
    String irrig,
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'Mixed irrigation: rain $rain%, irrigated $irrig%. Effective rate = $rate%. Formula: $kg × $rate2% = ${due}kg.';
  }

  @override
  String calcCropTransRainFed(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'Rain-fed rate $rate%. Formula: $kg × $rate2% = ${due}kg.';
  }

  @override
  String calcCropTransIrrigated(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'Irrigated rate $rate%. Formula: $kg × $rate2% = ${due}kg.';
  }

  @override
  String get calcCamelNoDue => 'No due';

  @override
  String calcCamelSheepN(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sheep',
      one: '1 sheep',
    );
    return '$_temp0';
  }

  @override
  String get calcCamel1BintMakhad => '1 bint makhad';

  @override
  String get calcCamel1BintLabun => '1 bint labun';

  @override
  String get calcCamel1Hiqqah => '1 hiqqah';

  @override
  String get calcCamel1Jadhah => '1 jadhah';

  @override
  String get calcCamel2BintLabun => '2 bint labun';

  @override
  String get calcCamel2Hiqqah => '2 hiqqah';

  @override
  String calcCamelCombo(int hiqqah, int bintLabun) {
    return '$hiqqah hiqqah + $bintLabun bint labun';
  }

  @override
  String calcCamelApproxBintLabun(int count) {
    return '$count bint labun (approximate combo)';
  }

  @override
  String get profileLoadErrorTitle => 'Could not load your profile';

  @override
  String get profileTryAgain => 'Try again';

  @override
  String get profileSectionImpactDashboard => 'Impact Dashboard';

  @override
  String get profileSectionBeneficiaryInsights => 'Beneficiary Insights';

  @override
  String get profileSectionPersonalInformation => 'Personal Information';

  @override
  String get profileSectionSpiritualSettings => 'Spiritual Settings';

  @override
  String get profileSectionCoreActions => 'Core Actions';

  @override
  String get profileSectionSettingsSecurity => 'Settings & Security';

  @override
  String get profileSectionSupport => 'Support';

  @override
  String get profileNoNewNotifications => 'No new notifications';

  @override
  String get profileVerificationStatus => 'Verification Status';

  @override
  String get profileFaydaVerified => 'Fayda Verified';

  @override
  String get profileNotVerified => 'Not verified';

  @override
  String get profileTotalZakatPaid => 'Total Zakat Paid';

  @override
  String get profileFySummary => 'FY 2023 Summary';

  @override
  String get profileActiveEndowments => 'Active Endowments';

  @override
  String get profileSustainableImpact => 'Sustainable impact';

  @override
  String get profileBeneficiariesHelped => 'Beneficiaries Helped';

  @override
  String get profileAcrossPrograms => 'Across programs';

  @override
  String get profileApplicationStatus => 'Application Status';

  @override
  String get profileLastDisbursement => 'Last Disbursement';

  @override
  String get profileTotalAidReceived => 'Total Aid Received';

  @override
  String get profileEmailAddress => 'Email Address';

  @override
  String get profilePhoneNumber => 'Phone Number';

  @override
  String profileEditFieldComingSoon(String field) {
    return 'Edit $field coming soon';
  }

  @override
  String get profileNisabThresholdAlerts => 'Nisab Threshold Alerts';

  @override
  String get profileNisabThresholdAlertsSubtitle =>
      'Notify when wealth reaches threshold';

  @override
  String get profileChangePin => 'Change PIN';

  @override
  String get profileChangePinComingSoon => 'Change PIN coming soon';

  @override
  String get profileMyZakatHistory => 'My Zakat History';

  @override
  String get profileMyZakatHistorySubtitle => 'View ledger & certificates';

  @override
  String get profileZakatHistoryComingSoon => 'Zakat history coming soon';

  @override
  String get profileMyAwqafEndowments => 'My Awqaf Endowments';

  @override
  String get profileMyAwqafEndowmentsSubtitle => 'View schools & wells';

  @override
  String get profileBeneficiaryApplication => 'Beneficiary Application';

  @override
  String get profileApplyAsBeneficiary => 'Apply as Beneficiary';

  @override
  String get profileBeneficiaryApplicationSubtitle =>
      'Submit or track aid requests';

  @override
  String get profileApplyAsBeneficiarySubtitle => 'Register to receive aid';

  @override
  String get profileDonationHistory => 'Donation History';

  @override
  String get profileDonationHistorySubtitle => 'See every contribution';

  @override
  String get profileDonationHistoryComingSoon => 'Donation history coming soon';

  @override
  String get profileHelpCenter => 'Help Center';

  @override
  String get profileHelpCenterSubtitle => 'FAQs and guidance';

  @override
  String get profileHelpCenterComingSoon => 'Help center coming soon';

  @override
  String get profileSupportAndGrievances => 'Support & Grievances';

  @override
  String get profileSupportAndGrievancesSubtitle => 'Talk to our team';

  @override
  String get profileSupportCenterComingSoon => 'Support center coming soon';

  @override
  String get profileLogOut => 'Log Out';

  @override
  String get profileLogOutSubtitle => 'End your current session';

  @override
  String get profileLogOutDialogTitle => 'Log out?';

  @override
  String get profileLogOutDialogBody =>
      'You will be signed out of the app on this device.';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileHadithOfTheDay => 'Hadith of the Day';

  @override
  String get profileHadithQuote =>
      '\"The believer\'s shade on the Day of Resurrection will be his charity.\"';

  @override
  String get profileHadithSource => '— At-Tirmidhi';

  @override
  String get impactNationalImpact => 'National Impact';

  @override
  String get impactNotifications => 'Notifications';

  @override
  String get impactCouldNotLoad => 'Could not load national impact';

  @override
  String get impactGeographicReach => 'Geographic Reach';

  @override
  String get impactBarakaStories => 'Baraka Stories';

  @override
  String get impactActiveAwqafProjects => 'Active Awqaf Projects';

  @override
  String get impactAllProjectsComingSoon => 'All projects coming soon';

  @override
  String get impactLiveImpactStream => 'LIVE IMPACT STREAM';

  @override
  String get impactDistributedFunds => 'DISTRIBUTED FUNDS';

  @override
  String impactEtbAmount(String amount) {
    return '$amount ETB';
  }

  @override
  String get impactLivesTouched => 'LIVES TOUCHED';

  @override
  String get impactActiveProjects => 'ACTIVE PROJECTS';

  @override
  String get impactTapRegionHint => 'Tap a region to see local impact';

  @override
  String impactRegionImpactComingSoon(String region) {
    return '$region impact coming soon';
  }

  @override
  String impactStoryComingSoon(String name) {
    return '$name story coming soon';
  }

  @override
  String impactProjectDetailsComingSoon(String title) {
    return '$title details coming soon';
  }

  @override
  String impactPercentFunded(String percent) {
    return '$percent% Funded';
  }

  @override
  String impactEtbLeft(String amount) {
    return '$amount ETB Left';
  }

  @override
  String get impactSeeYourPersonalBaraka => 'See Your Personal Baraka';

  @override
  String get impactTrackStewardship => 'Track every cent of your stewardship.';

  @override
  String get impactViewMyHistory => 'View My History';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingTitleFaithAndPurpose => 'Faith with Purpose';

  @override
  String get onboardingSubtitleFaithAndPurpose =>
      'Welcome to a trusted platform for Zakat and Awqaf stewardship.';

  @override
  String get onboardingTitleTransparentGiving => 'Transparent Giving';

  @override
  String get onboardingSubtitleTransparentGiving =>
      'See how your contributions flow into real impact across communities.';

  @override
  String get onboardingTitleEasyPayments => 'Fast, Simple Payments';

  @override
  String get onboardingSubtitleEasyPayments =>
      'Pay Zakat quickly with a smooth, secure, mobile-first experience.';

  @override
  String get onboardingTitleCompassionInAction => 'Compassion in Action';

  @override
  String get onboardingSubtitleCompassionInAction =>
      'Support beneficiaries and projects with clarity, trust, and baraka.';
}
