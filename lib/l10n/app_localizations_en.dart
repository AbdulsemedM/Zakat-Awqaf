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
  String get splashSlogan =>
      'For the sake of Allah, for the service of humanity';

  @override
  String get splashWaqfByLabel => 'A Waqf by';

  @override
  String get splashWaqfByTitle => 'Coop Bank Alhuda';

  @override
  String get navHome => 'Home';

  @override
  String get navCalculator => 'Calculator';

  @override
  String get navImpact => 'Impact';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeCommissionTitle => 'Zakat & Awqaf Commission';

  @override
  String get homeGreeting => 'Assalamu\'alaikum';

  @override
  String get registerAcceptZakat => 'Register to Accept Zakat';

  @override
  String get urgentBeneficiaryNeeds => 'Urgent Causes';

  @override
  String get viewAll => 'View all →';

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
  String get payZakatCause => 'Give Zakat';

  @override
  String get zakatAlFitr => 'Zakat Al-Fitr';

  @override
  String get needQuickWayGive => 'Quick Giving';

  @override
  String get supportCommunityNeeds =>
      'Support ongoing community needs instantly with Sadaqah.';

  @override
  String get donateSadaqah => 'Donate Sadaqah';

  @override
  String get aboutCommission => 'Ethiopian Zakat & Awqaf Commission';

  @override
  String get aboutCommissionBody =>
      'Coordinating zakat collection and awqaf development to uplift vulnerable communities through transparent, Shariah-aligned programs across Ethiopia.';

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
  String calcStep1NisabBody(String grams, String metal) {
    return 'Zakat is due if your net wealth reaches the nisab: $grams g of $metal at today\'s price.';
  }

  @override
  String calcNisabGoldFormula(String grams, String price, String total) {
    return '$grams × $price = $total';
  }

  @override
  String calcNisabThresholdBanner(String amount, String grams, String metal) {
    return 'Nisab threshold ($grams g $metal): $amount';
  }

  @override
  String get calcStep1LivestockTitle => 'Step 1: Livestock scale method';

  @override
  String get calcStep1LivestockBody =>
      'Livestock Zakat is calculated by physical head-count scales (not % of value).';

  @override
  String calcStep1LivestockNisabNote(
    int sheep,
    int cattle,
    int camels,
    int tabiPer,
    int musinnahPer,
  ) {
    return 'Nisab thresholds: Sheep/Goats $sheep, Cattle $cattle, Camels $camels. Cattle uses $tabiPer/$musinnahPer combinations; camels follow tier ranges.';
  }

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
  String calcStep1CropBody(
    String nisab,
    String rainRate,
    String irrigatedRate,
  ) {
    return 'Crop Zakat is due at harvest. Nisab is ${nisab}kg. Rate is $rainRate% (rain-fed), $irrigatedRate% (irrigated), or weighted for mixed.';
  }

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
  String calcHowCropZakatWorksBody(
    String nisab,
    String rainRate,
    String irrigatedRate,
  ) {
    return 'Nisab: ${nisab}kg. Rates: rain-fed $rainRate%, irrigated $irrigatedRate%, mixed = weighted split. Zakat is due at harvest (no annual hawl for crops).';
  }

  @override
  String get calcHowCropZakatNote =>
      'Note: App applies these rules broadly for simplicity. Scholarly positions differ on crop-type scope and expense deductions; consult qualified scholars for specific cases.';

  @override
  String get calcWealthNisabHeading => 'Nisab & wealth Zakat';

  @override
  String calcWealthNisabLine(String nisab) {
    return 'Nisab threshold: $nisab';
  }

  @override
  String calcWealthZakatDueLine(String due) {
    return 'Wealth Zakat due (smaller amount on the card): $due';
  }

  @override
  String get calcHowWealthZakatWorksTitle => 'How wealth Zakat is calculated';

  @override
  String get calcHowWealthZakatNote =>
      'Note: Scholars differ on which assets are zakatable, how debts discount wealth, when the lunar year (hawl) applies, and other details. This screen is an educational estimate—confirm your situation with qualified scholars.';

  @override
  String get calcWealthBreakdownTitle => 'How the amounts above are calculated';

  @override
  String calcWealthTransLiquidsLine(
    String cash,
    String bank,
    String mobile,
    String subtotal,
  ) {
    return 'Cash + bank + mobile: $cash + $bank + $mobile = $subtotal';
  }

  @override
  String calcWealthTransBusinessLine(String business) {
    return 'Business assets (sum of rows): $business';
  }

  @override
  String calcWealthTransRollupLine(
    String liquids,
    String business,
    String gold,
    String silver,
    String total,
  ) {
    return 'Total assets: $liquids + $business + $gold + $silver = $total';
  }

  @override
  String calcWealthTransNisabLine(
    String grams,
    String metal,
    String price,
    String nisab,
  ) {
    return 'Nisab: $grams g $metal × $price/g = $nisab';
  }

  @override
  String calcWealthTransGoldLine(
    String grams,
    String karat,
    String price,
    String value,
  ) {
    return 'Gold: $grams g × $karat ($price/g) = $value';
  }

  @override
  String calcWealthTransSilverLine(String grams, String rate, String value) {
    return 'Silver: $grams g × $rate ETB/g = $value';
  }

  @override
  String calcWealthTransNetLine(String liabilities, String net) {
    return 'Net wealth (large amount on the card): total assets − liabilities ($liabilities) = $net';
  }

  @override
  String calcWealthTransDueAbove(
    String net,
    String due,
    String nisab,
    String rate,
  ) {
    return 'Because $net is at or above nisab ($nisab), Zakat due = $net × $rate% = $due.';
  }

  @override
  String calcWealthTransDueBelow(String net, String nisab, String due) {
    return 'Because $net is below nisab ($nisab), wealth Zakat due = $due.';
  }

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
  String calcTransSheep(int head, int due, int min) {
    return 'Sheep/Goats threshold: $head >= $min => due $due sheep.';
  }

  @override
  String calcTransCattle(
    int head,
    int tabi,
    int musinnah,
    int min,
    int tabiPer,
    int musinnahPer,
  ) {
    return 'Cattle threshold: $head >= $min => due $tabi tabi\', $musinnah musinnah ($tabiPer/$musinnahPer combination).';
  }

  @override
  String calcTransCamel(int head, String due, int min) {
    return 'Camel threshold: $head >= $min => due $due.';
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
  String get profileLoadErrorTitle => 'Could not load your profile';

  @override
  String get profileTryAgain => 'Try again';

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
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Use your registered phone number or email and your password';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginSecureNote => 'Your sign-in is encrypted and secure';

  @override
  String get loginPasswordRequired => 'Enter your password';

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
  String get onboardingTitleTransparentGiving => 'Zakat Calculator';

  @override
  String get onboardingSubtitleTransparentGiving =>
      'Calculate your Zakat instantly across wealth, livestock, and crops with clear guidance.';

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

  @override
  String get donationCurrencySheetTitle => 'How would you like to give?';

  @override
  String get donationCurrencySheetSubtitle =>
      'Choose local ETB payment or international card payment.';

  @override
  String get donationInternationalPaymentTitle => 'International payment';

  @override
  String get donationInternationalPaymentSubtitle =>
      'Pay from anywhere with your card and billing address.';

  @override
  String get donationInternationalTitle => 'International Sadaqah';

  @override
  String get donationInternationalSubtitle =>
      'Support communities from anywhere in the world.';

  @override
  String get donationAmountLabel => 'Donation amount';

  @override
  String get donationAmountHint => '0.00';

  @override
  String get donationAmountHelper =>
      'Amount is settled in Ethiopian Birr (ETB).';

  @override
  String get donationAnonymousLabel => 'Give anonymously';

  @override
  String get donationAnonymousSubtitle =>
      'Your name will not be shown publicly.';

  @override
  String get donationDonorSectionTitle => 'Your details';

  @override
  String get donationFullNameLabel => 'Full name';

  @override
  String get donationPhoneLabel => 'Phone';

  @override
  String get donationEmailLabel => 'Email';

  @override
  String get donationBillingSectionTitle => 'Billing address';

  @override
  String get donationAddress1Label => 'Address line 1';

  @override
  String get donationAddress2Label => 'Address line 2 (optional)';

  @override
  String get donationCountryLabel => 'Country';

  @override
  String get donationCountryOther => 'Country name';

  @override
  String get donationAdminAreaLabel => 'State / Province';

  @override
  String get donationLocalityLabel => 'City';

  @override
  String get donationPostalCodeLabel => 'Postal code';

  @override
  String get donationContinueToPayment => 'Continue to payment';

  @override
  String get donationSubmitting => 'Processing…';

  @override
  String get donationSuccess => 'Thank you for your Sadaqah.';

  @override
  String get donationValidationPhone =>
      'Enter a valid phone number in international format (e.g. +15551234567).';

  @override
  String get donationPaymentWebViewTitle => 'Complete payment';

  @override
  String get donationSelectCountry => 'Select country';

  @override
  String get donationSearchCountry => 'Search countries';

  @override
  String get donationSelectState => 'Select state / province';

  @override
  String get donationSearchState => 'Search by name or abbreviation';

  @override
  String get donationNoMatchesFound => 'No matches found';

  @override
  String get changeAppModeTooltip => 'Change mode';

  @override
  String get switchedToAwqafMode => 'Switched to Awqaf mode';

  @override
  String get switchToAwqaf => 'Switch to Awqaf';

  @override
  String get switchedToZakatMode => 'Switched to Zakat mode';

  @override
  String get switchToZakat => 'Switch to Zakat';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginForgotPasswordComingSoon => 'Forgot password coming soon';

  @override
  String get loginNewToBaraka => 'New to Baraka? ';

  @override
  String get loginCreateAccount => 'Create an account';

  @override
  String get loginCreateAccountComingSoon => 'Create account coming soon';

  @override
  String get profileDisbursementIntro =>
      'Choose where you want to receive disbursements.';

  @override
  String get profileCoopAccountLabel => 'Coop Bank Account Number';

  @override
  String get profileCoopAccountHint => 'Enter your account number';

  @override
  String get profileCoopAccountRequired =>
      'Please enter your Coop Bank account number.';

  @override
  String get profileSaveAccount => 'Save Account';

  @override
  String get faydaIdentityVerification => 'Identity verification';

  @override
  String get commonBack => 'Back';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonFinish => 'Finish';

  @override
  String get commonTakePhoto => 'Take Photo';

  @override
  String get commonChooseGallery => 'Choose from Gallery';

  @override
  String get commonChooseFile => 'Choose File';

  @override
  String get regTitle => 'Beneficiary Registration';

  @override
  String get regMethodFastTrack => 'Fast-Track with Fayda';

  @override
  String get regMethodManual => 'Manual Registration';

  @override
  String get regMethodInstitution => 'Institution Registration';

  @override
  String get regMethodFastTrackDesc =>
      'Securely verify identity with National ID and continue in minutes.';

  @override
  String get regMethodManualDesc =>
      'Share your information and supporting details for trusted review.';

  @override
  String get regMethodInstitutionDesc =>
      'Register your organization and submit required compliance documents.';

  @override
  String get regSecureIdentityTitle => 'Secure Identity Verification';

  @override
  String get regChooseMethodSubtitle =>
      'Choose your preferred registration method to begin your journey.';

  @override
  String get regFastTrackFaydaTitle => 'Fast-Track with National ID (Fayda)';

  @override
  String get regFastTrackFaydaSubtitle =>
      'Authenticate using your national digital ID.';

  @override
  String get regManualTitle => 'Manual Registration';

  @override
  String get regManualSubtitle => 'Upload supporting documentation for review.';

  @override
  String get regInstitutionCardTitle => 'Register as Institution';

  @override
  String get regInstitutionCardSubtitle =>
      'Company, NGO, cooperative, or government entity.';

  @override
  String get regRegistrationCodeLabel => 'Registration code';

  @override
  String get regRegistrationCodeHint => 'EZW-A1B2-C3D4';

  @override
  String get regEncryptedPrivate => 'Encrypted & Private';

  @override
  String get regEncryptedPrivateBody =>
      'Your data is secured and handled in line with privacy standards.';

  @override
  String get regVerificationInterrupted => 'Verification interrupted';

  @override
  String get regReopenVerification => 'Reopen verification';

  @override
  String get regRetryListening => 'Retry listening';

  @override
  String get regCameraPermissionError =>
      'Could not open camera/gallery. Please check permissions.';

  @override
  String get regSelectBirthdate => 'Select birthdate';

  @override
  String get regManualIdentityTitle => 'Manual Identity Registration';

  @override
  String get regFirstName => 'First Name';

  @override
  String get regLastName => 'Last Name';

  @override
  String get regGrandfatherName => 'Grandfather\'s Name';

  @override
  String get regPhoneNumber => 'Phone Number';

  @override
  String get regPhoneHint => '+251911223344 or 0911223344';

  @override
  String get regEmail => 'Email';

  @override
  String get regGender => 'Gender';

  @override
  String get regMale => 'Male';

  @override
  String get regFemale => 'Female';

  @override
  String get regBeneficiaryCategory => 'Beneficiary Category';

  @override
  String get regNotes => 'Notes';

  @override
  String get regNotesHint => 'e.g. Zakat support applicant';

  @override
  String get regUploadProfilePicture => 'Upload Profile Picture';

  @override
  String get regVerifyingFaydaBanner =>
      'Verifying with Fayda… Complete verification in the browser when it opens.';

  @override
  String get regNeedsAssessment => 'Needs Assessment';

  @override
  String get regSituationLabel => 'Describe your current situation';

  @override
  String get regSituationHint =>
      'Explain hardship, dependents, and urgent needs...';

  @override
  String get regUploadProof => 'Upload Proof';

  @override
  String get regDisbursementSetup => 'Disbursement Setup';

  @override
  String get regTelebirrTitle => 'Telebirr Wallet';

  @override
  String get regTelebirrSubtitle => 'Instant mobile money transfer';

  @override
  String get regMpesaTitle => 'M-Pesa';

  @override
  String get regMpesaSubtitle => 'Secure mobile payment network';

  @override
  String get regCoopbankTitle => 'Coopbank Account';

  @override
  String get regCoopbankSubtitle => 'Direct bank deposit';

  @override
  String get regAccountOrMobile => 'Account or Mobile Number';

  @override
  String get regFullLegalName => 'Full Legal Name';

  @override
  String get regAgreementTitle => 'Agreement & Sharia Compliance';

  @override
  String get regAgreementBody =>
      'I declare information is truthful and will use aid according to policy.';

  @override
  String get regInstitutionRegistration => 'Institution Registration';

  @override
  String get regInstitutionType => 'Institution Type';

  @override
  String get regLegalName => 'Legal Name';

  @override
  String get regTradingName => 'Trading Name';

  @override
  String get regTradeRegistrationNumber => 'Trade Registration Number';

  @override
  String get regTin => 'Tax Identification Number (TIN)';

  @override
  String get regVatOptional => 'VAT Registration Number (optional)';

  @override
  String get regRegion => 'Region';

  @override
  String get regCity => 'City';

  @override
  String get regAddress => 'Address';

  @override
  String get regNotesOptional => 'Notes (optional)';

  @override
  String get regAuthorityDocTitle => 'Authority to act document required';

  @override
  String get regAuthorityDocBody =>
      'Enable if someone other than a registered signatory submits.';

  @override
  String get regFilePickError =>
      'Could not pick file. Please check permissions.';

  @override
  String get regUploadKycTitle => 'Upload KYC Documents';

  @override
  String get regUploadKycBody =>
      'Upload each required document. You can finish once all required documents are uploaded.';

  @override
  String regReference(Object id) {
    return 'Reference: $id';
  }

  @override
  String get regNoDocumentsRequired => 'No documents required at this time.';

  @override
  String get regRequired => 'Required';

  @override
  String get regOptional => 'Optional';

  @override
  String regSelectedFile(Object name) {
    return 'Selected: $name';
  }

  @override
  String get regUploaded => 'Uploaded';

  @override
  String get regUpload => 'Upload';

  @override
  String get regCreatePasswordTitle => 'Create Your Password';

  @override
  String get regCreatePasswordBody =>
      'Choose a secure password for your account. You will use it to sign in after registration.';

  @override
  String get regPassword => 'Password';

  @override
  String get regConfirmPassword => 'Confirm Password';

  @override
  String get regPasswordRules =>
      'Password must be at least 8 characters and include uppercase, lowercase, a number, and a special character.';

  @override
  String get regPasswordSuccess =>
      'Password set successfully. Welcome to Mejlis Digital Hub.';

  @override
  String regInstitutionComplete(Object id) {
    return 'Institution registration complete. Reference: $id';
  }

  @override
  String get regInstitutionCompleteGeneric =>
      'Institution registration complete.';

  @override
  String get regCompleteLocal =>
      'Registration complete. Needs and disbursement details are saved locally.';

  @override
  String get regContinueWithFayda => 'Continue with Fayda';

  @override
  String get regVerifyingFayda => 'Verifying with Fayda…';

  @override
  String get regSubmitContinue => 'Submit & Continue';

  @override
  String get regSetPasswordContinue => 'Set Password & Continue';

  @override
  String get regSetPasswordFinish => 'Set Password & Finish';

  @override
  String get navAwqaf => 'Awqaf';

  @override
  String get regVerifyCode => 'Verify';

  @override
  String regCodeBranchLabel(String branchName) {
    return 'Branch: $branchName';
  }

  @override
  String get regCodeBranchConfirm =>
      'Please confirm this is your branch before continuing.';

  @override
  String get regAddressLine => 'Address';

  @override
  String get regKebele => 'Kebele';

  @override
  String get regReligion => 'Religion';

  @override
  String get regMaritalStatus => 'Marital status';

  @override
  String get regMaritalSingle => 'Single';

  @override
  String get regMaritalMarried => 'Married';

  @override
  String get regMaritalWidowed => 'Widowed';

  @override
  String get regMaritalDivorced => 'Divorced';

  @override
  String get regMaritalSeparated => 'Separated';

  @override
  String get regVerifyCodeFirst =>
      'Enter your registration code and tap Verify. The form opens once the code is accepted.';

  @override
  String get homeQuickCalculate => 'Calculate';

  @override
  String get homeQuickSadaqah => 'Sadaqah';

  @override
  String get homeQuickApply => 'Apply';

  @override
  String get homeUpcoming => 'UPCOMING';

  @override
  String get payTitleZakat => 'Complete your Zakat';

  @override
  String get paySubtitleZakat =>
      'Fulfil your obligation securely through trusted local channels.';

  @override
  String get payTotalZakatDue => 'TOTAL ZAKAT DUE';

  @override
  String get payCalculatedOverview => 'CALCULATED OVERVIEW';

  @override
  String get payAmountLabel => 'Amount to pay (ETB)';

  @override
  String get payAmountHintZakat => 'Enter the amount you want to pay';

  @override
  String get payAmountHintEtb => 'Enter an ETB amount';

  @override
  String get payNaturalUnitsLivestock =>
      'Zakat on livestock is due in animals. You may pay its ETB value based on current local market prices.';

  @override
  String get payNaturalUnitsCrops =>
      'Zakat on crops is due in harvest. You may pay its ETB value based on current local market prices.';

  @override
  String get payBeneficiary => 'Beneficiary (optional)';

  @override
  String get payProjectLabel => 'Beneficiary project';

  @override
  String get payGeneralFundZakat => 'General Zakat fund';

  @override
  String get payMethod => 'Payment method';

  @override
  String get paySecureSsl => '256-BIT SSL';

  @override
  String get paySecureBank => 'BANK-GRADE SECURITY';

  @override
  String get payImpactTitle => 'Your impact';

  @override
  String get payImpactBody =>
      'Every contribution is allocated transparently through the commission\'s programmes.';

  @override
  String get regStepIdentity => 'Identity';

  @override
  String get regStepNeeds => 'Needs';

  @override
  String get regStepVerify => 'Verify';

  @override
  String get regStepPayout => 'Payout';

  @override
  String get regStepDetails => 'Details';

  @override
  String get regStepPassword => 'Password';

  @override
  String get regStepDocuments => 'Documents';

  @override
  String get regEmailOptional => 'Email (optional)';

  @override
  String get regSubmittedNoAccount =>
      'Registration submitted. No sign-in account was created because no email was given.';

  @override
  String get loginIdentifierLabel => 'Phone number or email';

  @override
  String get loginIdentifierRequired => 'Enter your phone number or email';

  @override
  String get loginIdentifierInvalid =>
      'Enter a valid phone number (e.g. 0911223344) or email';

  @override
  String calcCamelBintMakhadN(int count) {
    return '$count bint makhad';
  }

  @override
  String calcCamelBintLabunN(int count) {
    return '$count bint labun';
  }

  @override
  String calcCamelHiqqahN(int count) {
    return '$count hiqqah';
  }

  @override
  String calcCamelJadhahN(int count) {
    return '$count jadhah';
  }

  @override
  String get calcNisabMetalGold => 'gold (24k)';

  @override
  String get calcNisabMetalSilver => 'silver';

  @override
  String calcPricesAsOf(String date, String source) {
    return 'Prices as of $date · $source';
  }

  @override
  String calcPricesAsOfNoSource(String date) {
    return 'Prices as of $date';
  }

  @override
  String get calcPricesStale => 'Prices may be out of date.';

  @override
  String get calcPricesSavedCopy =>
      'Couldn\'t refresh prices. Showing the prices saved on this device.';

  @override
  String get calcConfigErrorTitle => 'Couldn\'t load today\'s zakat rates';

  @override
  String get calcConfigErrorBody => 'Check your connection and try again.';

  @override
  String get calcConfigNotReadyBody =>
      'Gold and silver prices are not available yet. Please try again later.';

  @override
  String get commonRetry => 'Try again';

  @override
  String calcLivestockEstimateLine(String amount) {
    return 'Estimated market value: $amount';
  }

  @override
  String get calcLivestockEstimateNote =>
      'Estimated at average market prices per animal. You can change the amount before paying.';

  @override
  String homeLiveCollected(String amount) {
    return 'LIVE · $amount collected';
  }

  @override
  String homeCollected(String amount) {
    return '$amount collected';
  }

  @override
  String homeChangeUp(String percent) {
    return '↑ $percent% vs last month';
  }

  @override
  String homeChangeDown(String percent) {
    return '↓ $percent% vs last month';
  }

  @override
  String get homeChangeFlat => 'Same as last month';

  @override
  String get homeBeneficiariesSubtext => 'households';

  @override
  String get fitrStatusOpen => 'OPEN NOW';

  @override
  String get fitrStatusClosed => 'CLOSED';

  @override
  String fitrStartsIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Starts in $days days',
      one: 'Starts tomorrow',
      zero: 'Starts today',
    );
    return '$_temp0';
  }

  @override
  String fitrDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left to pay',
      one: '1 day left to pay',
      zero: 'Today is the last day to pay',
    );
    return '$_temp0';
  }

  @override
  String fitrClosedOn(String date) {
    return 'Closed on $date';
  }

  @override
  String fitrPerPerson(String amount) {
    return '$amount per person';
  }

  @override
  String get causesTitle => 'Causes';

  @override
  String get causesSubtitle => 'Projects your zakat supports';

  @override
  String get causesActive => 'Active';

  @override
  String get causesClosed => 'Closed';

  @override
  String get causesAllCategories => 'All';

  @override
  String get causeCategoryEducation => 'Education';

  @override
  String get causeCategoryWater => 'Water';

  @override
  String get causeCategoryHealth => 'Health';

  @override
  String get causeCategoryFood => 'Food';

  @override
  String get causeCategoryShelter => 'Shelter';

  @override
  String get causeCategoryLivelihood => 'Livelihood';

  @override
  String get causeCategoryEmergency => 'Emergency';

  @override
  String get causeCategoryGeneral => 'General';

  @override
  String get causeBadgeUrgent => 'URGENT';

  @override
  String get causeBadgeEssential => 'ESSENTIAL';

  @override
  String causeRaisedOfGoal(String raised, String goal) {
    return '$raised raised of $goal';
  }

  @override
  String causeRaised(String raised) {
    return '$raised raised';
  }

  @override
  String causeEndsOn(String date) {
    return 'Ends $date';
  }

  @override
  String causeEndedOn(String date) {
    return 'Ended $date';
  }

  @override
  String get causesEmpty => 'No causes to show yet.';

  @override
  String get causesLoadError => 'Couldn\'t load causes.';

  @override
  String get causeNotFound => 'This cause is no longer available.';

  @override
  String get causeAbout => 'About this cause';

  @override
  String get payProjectsLoading => 'Loading projects…';

  @override
  String impactAsOf(String date) {
    return 'As of $date';
  }

  @override
  String get impactBeneficiariesByAsnaf => 'Beneficiaries by category';

  @override
  String impactRegionBeneficiaries(String count) {
    return '$count beneficiaries';
  }

  @override
  String impactRegionProjects(String count) {
    return '$count projects';
  }

  @override
  String get impactShowNational => 'Show national';

  @override
  String get impactStoryNotFound => 'This story is no longer available.';

  @override
  String get impactStoryLoadError => 'Couldn\'t load this story.';

  @override
  String impactPublishedOn(String date) {
    return 'Published $date';
  }

  @override
  String get payNotAllowedBeneficiary =>
      'Beneficiary accounts receive zakat and can\'t pay it. Sign out to pay as a guest.';

  @override
  String get payEnterAmount => 'Enter an amount.';

  @override
  String payAmountOutOfRange(String min, String max) {
    return 'Enter an amount between $min and $max.';
  }

  @override
  String get payAccountNumberLabel => 'Coop Bank account number';

  @override
  String get payAccountNumberHelper =>
      'The account you pay from. We\'ll show the account holder\'s name for you to confirm.';

  @override
  String get payAccountNumberInvalid =>
      'Enter a valid account number (6–20 digits).';

  @override
  String get payNetworkError =>
      'No connection. Check your internet and try again.';

  @override
  String get payMethodsLoading => 'Loading payment methods…';

  @override
  String get payMethodsError => 'Couldn\'t load payment methods.';

  @override
  String get payNoMethods => 'No payment method is available right now.';

  @override
  String get payMethodUnavailable => 'Not available yet';

  @override
  String get payCancelConfirmTitle => 'Cancel this payment?';

  @override
  String get payCancelConfirmBody =>
      'No money has been taken. You can start again at any time.';

  @override
  String get payKeepPaying => 'Keep paying';

  @override
  String get payCancelPayment => 'Cancel payment';

  @override
  String payForCause(String cause) {
    return 'For: $cause';
  }

  @override
  String get payAccountHolder => 'Account holder';

  @override
  String get payAccountNumberShort => 'Account';

  @override
  String get payConfirmTitle => 'Is this your account?';

  @override
  String get payConfirmBody =>
      'If it is, Coop Bank will send a confirmation code to the phone registered on this account.';

  @override
  String get payYesSendCode => 'Yes, send code';

  @override
  String get payNotMyAccount => 'Not my account';

  @override
  String get payOtpTitle => 'Enter the confirmation code';

  @override
  String get payOtpBody =>
      'We sent a 6-digit code to the phone registered on your Coop Bank account.';

  @override
  String get payOtpLabel => 'Confirmation code';

  @override
  String payOtpAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attempts left',
      one: '1 attempt left',
    );
    return '$_temp0';
  }

  @override
  String get payResendCode => 'Send a new code';

  @override
  String payPayAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get payProcessingTitle => 'We are confirming your payment';

  @override
  String get payProcessingBody =>
      'Coop Bank hasn\'t answered yet. This page updates by itself; please don\'t pay again.';

  @override
  String get payCheckAgain => 'Check again';

  @override
  String get paySucceededTitle => 'Payment successful';

  @override
  String paySucceededBody(String amount) {
    return 'Your zakat of $amount has been paid. May Allah accept it from you.';
  }

  @override
  String payReference(String reference) {
    return 'Bank reference: $reference';
  }

  @override
  String get payViewCertificate => 'View certificate';

  @override
  String get payDone => 'Done';

  @override
  String get payCancelledTitle => 'Payment cancelled';

  @override
  String get payExpiredTitle => 'Payment expired';

  @override
  String get payExpiredBody =>
      'It wasn\'t finished within 15 minutes. No money was taken; please start again.';

  @override
  String get payFailedTitle => 'Payment not completed';

  @override
  String get payNoMoneyTaken => 'No money was taken.';

  @override
  String get payStartAgain => 'Start again';

  @override
  String get certTitle => 'Zakat certificate';

  @override
  String certNumber(String id) {
    return 'Certificate $id';
  }

  @override
  String get certSharePdf => 'Download / share PDF';

  @override
  String get certPdfError => 'Couldn\'t download the certificate.';

  @override
  String get certLoadError => 'Couldn\'t load the certificate.';

  @override
  String get certNotFound => 'Certificate not found.';

  @override
  String get certPayer => 'Payer';

  @override
  String get certType => 'Zakat type';

  @override
  String get certCause => 'Project';

  @override
  String get certNaturalUnits => 'Calculated due';

  @override
  String get certMethod => 'Method';

  @override
  String get certReference => 'Bank reference';

  @override
  String get certPaidAt => 'Paid';

  @override
  String get certIssuedAt => 'Issued';

  @override
  String get certHijriDate => 'Hijri date';

  @override
  String get certVerifyHint =>
      'The QR code on the PDF lets anyone verify this certificate.';

  @override
  String get zakatTypeWealth => 'Wealth';

  @override
  String get zakatTypeLivestock => 'Livestock';

  @override
  String get zakatTypeCrops => 'Crops';

  @override
  String get zakatTypeGeneral => 'General zakat';

  @override
  String get historyTitle => 'My zakat payments';

  @override
  String get historyEmpty => 'No payments yet.';

  @override
  String get historyLoadError => 'Couldn\'t load your payments.';

  @override
  String get payStatusSucceeded => 'Paid';

  @override
  String get payStatusPending => 'In progress';

  @override
  String get payStatusFailed => 'Failed';

  @override
  String get payStatusCancelled => 'Cancelled';

  @override
  String get payStatusExpired => 'Expired';

  @override
  String get fitrPayButton => 'Pay Zakat al-Fitr';

  @override
  String get fitrHouseholdTitle => 'How many people are you paying for?';

  @override
  String fitrHouseholdOf(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String fitrTotal(String amount) {
    return 'Total: $amount';
  }

  @override
  String get profileCaseStatus => 'Case';

  @override
  String get caseStatusSubmitted => 'Submitted';

  @override
  String get caseStatusVerified => 'Verified';

  @override
  String get caseStatusApproved => 'Approved';

  @override
  String get caseStatusActive => 'Active — receiving support';

  @override
  String get caseStatusClosed => 'Closed';

  @override
  String get impactComingSoonTitle => 'Impact data is coming soon';

  @override
  String get impactComingSoonBody =>
      'This page will show how zakat reaches communities across Ethiopia.';

  @override
  String payFinishWithin(String time) {
    return 'Finish within $time';
  }

  @override
  String payOtpExpiresIn(String time) {
    return 'Code expires in $time';
  }

  @override
  String get payOtpExpiredLocal => 'The code has expired. Send a new one.';

  @override
  String get unfinishedPaymentTitle => 'Unfinished payment';

  @override
  String get unfinishedPaymentContinue => 'Continue';

  @override
  String get payCheckStatus => 'Check status';

  @override
  String get recentPaymentsTitle => 'Recent payments on this device';

  @override
  String get recentPaymentsSubtitle =>
      'Resume an unfinished payment or open a certificate.';

  @override
  String get recentPaymentsEmpty => 'No payments on this device yet.';

  @override
  String get payOpenError => 'Couldn\'t open this payment.';

  @override
  String get profileSectionPayoutAccount => 'Payout Account';

  @override
  String get profileRoleBeneficiary => 'Beneficiary';

  @override
  String get profileRoleDonor => 'Donor';

  @override
  String get profileVerificationVerified => 'Verified';

  @override
  String get profileVerificationPending => 'Pending review';

  @override
  String get profileVerificationRejected => 'Not approved';
}
