// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Somali (`so`).
class AppLocalizationsSo extends AppLocalizations {
  AppLocalizationsSo([String locale = 'so']) : super(locale);

  @override
  String get appTitle => 'Zakat & Awqaf Commission';

  @override
  String get navHome => 'Hoyga';

  @override
  String get navCalculator => 'Xisaabiye';

  @override
  String get navImpact => 'Saameyn';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeCommissionTitle => 'Guddiga Zakada iyo Awqaafta';

  @override
  String get homeGreeting => 'Assalaamu Calaykum';

  @override
  String get registerAcceptZakat => 'Isdiiwaangeli si aad u hesho Zakat';

  @override
  String get urgentBeneficiaryNeeds =>
      'Baahiyaha Degdegga ah ee Ka-faa\'iideystayaasha';

  @override
  String get viewAll => 'Dhammaan Arag';

  @override
  String get totalZakatCollected => 'WADARTA ZAKADA LA URURIYAY';

  @override
  String get thisMonth => 'Bishan';

  @override
  String get totalBeneficiariesSupported =>
      'Wadarta ka-faa\'iideystayaasha la taageeray';

  @override
  String get transparencyQuote =>
      'Hufnaan, isla xisaabtan, iyo saameyn muuqata: sadaqadaadu waxay xoojisaa gargaar iyo awoodsiin qaran.';

  @override
  String get payZakatCause => 'U bixi Zakat sababtan';

  @override
  String get zakatAlFitr => 'Zakat Al-Fitr';

  @override
  String get zakatDueDays => 'Waxay ku egtahay qiyaastii 22 maalmood gudahood.';

  @override
  String get setReminder => 'Deji Xasuusin';

  @override
  String get needQuickWayGive =>
      'Ma u baahan tahay hab degdeg ah oo aad ku bixiso?';

  @override
  String get supportCommunityNeeds =>
      'Ku taageer baahiyaha bulshada si degdeg ah adigoo Sadaqo bixinaya.';

  @override
  String get donateSadaqah => 'Bixi Sadaqo';

  @override
  String get aboutCommission =>
      'Ku saabsan Guddiga Zakada iyo Awqaafta Itoobiya';

  @override
  String get aboutCommissionBody =>
      'Guddiga Zakada iyo Awqaafta Itoobiya wuxuu isku dubbaridaa ururinta zakada iyo horumarinta awqaafta si kor loogu qaado bulshooyinka nugul iyadoo la adeegsanayo barnaamijyo hufan oo waafaqsan shareecada.';

  @override
  String get chipTransparencyFirst => 'Hufnaan-hore';

  @override
  String get chipNationwideImpact => 'Saameyn qaran';

  @override
  String get chipShariahAligned => 'Waafaqsan Shareecada';

  @override
  String get profileLanguagePreferences => 'Doorashada Luqadda';

  @override
  String get profileThemeMode => 'Muuqaal';

  @override
  String get themeLight => 'Iftiin';

  @override
  String get themeDark => 'Madow';

  @override
  String get profileBiometricLogin => 'Galitaanka Biometric';

  @override
  String get profileBiometricSubtitle => 'Isticmaal far ama aqoonsi wajiga';

  @override
  String get missingPaymentDetails => 'Faahfaahinta lacag-bixinta maqan.';

  @override
  String get missingCertificateDetails => 'Faahfaahinta shahaadada maqan.';

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
  String get profileLoadErrorTitle => 'Lama soo dejin karin profile-kaaga';

  @override
  String get profileTryAgain => 'Mar kale isku day';

  @override
  String get profileSectionImpactDashboard => 'Dashboard-ka Saameynta';

  @override
  String get profileSectionBeneficiaryInsights =>
      'Aragtiyada Ka-faa\'iideystaha';

  @override
  String get profileSectionPersonalInformation => 'Macluumaadka Shakhsiyeed';

  @override
  String get profileSectionSpiritualSettings => 'Dejimaha Ruuxiga';

  @override
  String get profileSectionCoreActions => 'Tallaabooyinka Muhiimka ah';

  @override
  String get profileSectionSettingsSecurity => 'Dejimo & Ammaan';

  @override
  String get profileSectionSupport => 'Taageero';

  @override
  String get profileNoNewNotifications => 'Ogeysiis cusub ma jiro';

  @override
  String get profileVerificationStatus => 'Xaaladda Xaqiijinta';

  @override
  String get profileFaydaVerified => 'Fayda waa la xaqiijiyey';

  @override
  String get profileNotVerified => 'Lama xaqiijin';

  @override
  String get profileTotalZakatPaid => 'Wadarta Zakat la bixiyay';

  @override
  String get profileFySummary => 'Soo koobidda FY 2023';

  @override
  String get profileActiveEndowments => 'Awqaafta Firfircoon';

  @override
  String get profileSustainableImpact => 'Saameyn waarta';

  @override
  String get profileBeneficiariesHelped => 'Ka-faa\'iideystayaal la caawiyay';

  @override
  String get profileAcrossPrograms => 'Dhammaan barnaamijyada';

  @override
  String get profileApplicationStatus => 'Xaaladda Codsiga';

  @override
  String get profileLastDisbursement => 'Bixintii Ugu Dambeysay';

  @override
  String get profileTotalAidReceived => 'Wadarta Kaalmada la helay';

  @override
  String get profileEmailAddress => 'Cinwaanka Iimaylka';

  @override
  String get profilePhoneNumber => 'Lambarka Taleefanka';

  @override
  String profileEditFieldComingSoon(String field) {
    return 'Wax-ka-beddelka $field dhawaan ayuu imanayaa';
  }

  @override
  String get profileNisabThresholdAlerts => 'Digniinaha xadka Nisab';

  @override
  String get profileNisabThresholdAlertsSubtitle =>
      'Ogow marka hantidu gaadho xadka nisab';

  @override
  String get profileChangePin => 'Beddel PIN';

  @override
  String get profileChangePinComingSoon =>
      'Beddelka PIN-ka dhawaan ayuu imanayaa';

  @override
  String get profileMyZakatHistory => 'Taariikhda Zakat-kayga';

  @override
  String get profileMyZakatHistorySubtitle =>
      'Eeg ledger-ka iyo shahaadooyinka';

  @override
  String get profileZakatHistoryComingSoon =>
      'Taariikhda zakat-ka dhawaan ayay imanaysaa';

  @override
  String get profileMyAwqafEndowments => 'Awqaaftayda';

  @override
  String get profileMyAwqafEndowmentsSubtitle => 'Eeg dugsiyada iyo ceelasha';

  @override
  String get profileBeneficiaryApplication => 'Codsiga Ka-faa\'iideystaha';

  @override
  String get profileApplyAsBeneficiary => 'Codso Ka-faa\'iideyste ahaan';

  @override
  String get profileBeneficiaryApplicationSubtitle =>
      'Gudbi ama la soco codsiyada kaalmo';

  @override
  String get profileApplyAsBeneficiarySubtitle =>
      'Isdiiwaangeli si aad kaalmo u hesho';

  @override
  String get profileDonationHistory => 'Taariikhda Deeqaha';

  @override
  String get profileDonationHistorySubtitle => 'Eeg tabaruc kasta';

  @override
  String get profileDonationHistoryComingSoon =>
      'Taariikhda deeqaha dhawaan ayay imanaysaa';

  @override
  String get profileHelpCenter => 'Xarunta Caawinta';

  @override
  String get profileHelpCenterSubtitle =>
      'Su\'aalaha badanaa la isweydiiyo iyo hagid';

  @override
  String get profileHelpCenterComingSoon =>
      'Xarunta caawinta dhawaan ayay imanaysaa';

  @override
  String get profileSupportAndGrievances => 'Taageero & Cabashooyin';

  @override
  String get profileSupportAndGrievancesSubtitle => 'La hadal kooxdayada';

  @override
  String get profileSupportCenterComingSoon =>
      'Xarunta taageerada dhawaan ayay imanaysaa';

  @override
  String get profileLogOut => 'Ka bax';

  @override
  String get profileLogOutSubtitle => 'Dhamee fadhigaaga hadda';

  @override
  String get profileLogOutDialogTitle => 'Ma ka baxaysaa?';

  @override
  String get profileLogOutDialogBody =>
      'Waxaad ka bixi doontaa app-ka qalabkan.';

  @override
  String get profileCancel => 'Jooji';

  @override
  String get profileHadithOfTheDay => 'Xadiiska Maanta';

  @override
  String get profileHadithQuote =>
      '\"Hadhka mu’minka maalinta qiyaame wuxuu ahaanayaa sadaqadiisa.\"';

  @override
  String get profileHadithSource => '— At-Tirmidhi';

  @override
  String get impactNationalImpact => 'Saameynta Qaran';

  @override
  String get impactNotifications => 'Ogeysiisyada';

  @override
  String get impactCouldNotLoad => 'Lama soo dejin karin saameynta qaranka';

  @override
  String get impactGeographicReach => 'Gaarsiinta Juqraafiyeed';

  @override
  String get impactBarakaStories => 'Sheekooyinka Barako';

  @override
  String get impactActiveAwqafProjects => 'Mashaariicda Awqaafta ee Firfircoon';

  @override
  String get impactAllProjectsComingSoon =>
      'Dhammaan mashaariicda dhawaan ayay imanayaan';

  @override
  String get impactLiveImpactStream => 'TOOS: QUUDINTA SAAMEYNTA';

  @override
  String get impactDistributedFunds => 'LACAGTA LA QAYBIYEY';

  @override
  String impactEtbAmount(String amount) {
    return '$amount ETB';
  }

  @override
  String get impactLivesTouched => 'NOLOLAL LA TAABTAY';

  @override
  String get impactActiveProjects => 'MASHAAARIIC FIRFIRCOON';

  @override
  String get impactTapRegionHint =>
      'Taabo gobol si aad u aragto saameynta deegaanka';

  @override
  String impactRegionImpactComingSoon(String region) {
    return 'Saameynta $region dhawaan ayay imanaysaa';
  }

  @override
  String impactStoryComingSoon(String name) {
    return 'Sheekada $name dhawaan ayay imanaysaa';
  }

  @override
  String impactProjectDetailsComingSoon(String title) {
    return 'Faahfaahinta $title dhawaan ayay imanaysaa';
  }

  @override
  String impactPercentFunded(String percent) {
    return '$percent% la maalgeliyey';
  }

  @override
  String impactEtbLeft(String amount) {
    return '$amount ETB ayaa hadhay';
  }

  @override
  String get impactSeeYourPersonalBaraka => 'Arag Barakadaada Shaqsiga ah';

  @override
  String get impactTrackStewardship =>
      'La soco senti kasta oo masuuliyaddaada ah.';

  @override
  String get impactViewMyHistory => 'Eeg Taariikhdhayda';

  @override
  String get onboardingSkip => 'Ka bood';

  @override
  String get onboardingNext => 'Xiga';

  @override
  String get onboardingGetStarted => 'Bilow';

  @override
  String get onboardingTitleFaithAndPurpose => 'Iimaan leh Ujeeddo';

  @override
  String get onboardingSubtitleFaithAndPurpose =>
      'Ku soo dhawoow madal lagu kalsoon yahay oo loogu talagalay maareynta Zakada iyo Awqaafta.';

  @override
  String get onboardingTitleTransparentGiving => 'Xisaabiyaha Zakat';

  @override
  String get onboardingSubtitleTransparentGiving =>
      'Si degdeg ah u xisaabi Zakat-kaaga hantida, xoolaha, iyo dalagyada adigoo helaya hagitaan cad.';

  @override
  String get onboardingTitleEasyPayments => 'Lacag-bixin Fudud oo Degdeg ah';

  @override
  String get onboardingSubtitleEasyPayments =>
      'Si dhakhso leh ugu bixi Zakada adigoo adeegsanaya khibrad ammaan ah oo mobile-friendly ah.';

  @override
  String get onboardingTitleCompassionInAction => 'Naxariis Ficil ah';

  @override
  String get onboardingSubtitleCompassionInAction =>
      'Ku taageer ka-faa\'iideystayaasha iyo mashaariicda si cad, kalsooni leh, kuna dheehan barako.';
}
