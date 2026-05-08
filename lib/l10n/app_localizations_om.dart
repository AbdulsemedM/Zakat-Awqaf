// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oromo (`om`).
class AppLocalizationsOm extends AppLocalizations {
  AppLocalizationsOm([String locale = 'om']) : super(locale);

  @override
  String get appTitle => 'Zakat & Awqaf Commission';

  @override
  String get navHome => 'Mana';

  @override
  String get navCalculator => 'Herregaa';

  @override
  String get navImpact => 'Bu\'aa';

  @override
  String get navProfile => 'Piroofaayilii';

  @override
  String get homeCommissionTitle => 'Komishinii Zakaa fi Awqaaf';

  @override
  String get homeGreeting => 'Assalaamu\'alaikum';

  @override
  String get registerAcceptZakat => 'Zakaa fudhachuuf galmaa\'i';

  @override
  String get urgentBeneficiaryNeeds => 'Fedhii Ariifachiisaa Fayyadamtootaa';

  @override
  String get viewAll => 'Hunda Ilaali';

  @override
  String get totalZakatCollected => 'WALITTI QABAMAA ZAKAA';

  @override
  String get thisMonth => 'Ji\'a kana';

  @override
  String get totalBeneficiariesSupported =>
      'Waliigala fayyadamtoota deeggaraman';

  @override
  String get transparencyQuote =>
      'Iftoomina, itti gaafatamummaa fi bu\'a qabeessummaa: arjoomni kee gargaarsa biyyaalessaa ni cimsaa.';

  @override
  String get payZakatCause => 'Sababa kanaaf Zakaa Kaffali';

  @override
  String get zakatAlFitr => 'Zakaa Al-Fitr';

  @override
  String get zakatDueDays => 'Guyyoota 22 keessatti ni ga\'a jechuun tilmaama.';

  @override
  String get setReminder => 'Yaadachiisa kaa\'i';

  @override
  String get needQuickWayGive => 'Karaa saffisaa itti kennitu barbaaddaa?';

  @override
  String get supportCommunityNeeds =>
      'Sadaqaan fedhii hawaasaa yeroo gabaabaa keessatti deeggaru.';

  @override
  String get donateSadaqah => 'Sadaqaa Kenni';

  @override
  String get aboutCommission => 'Waa\'ee Komishinii Zakaa fi Awqaaf Itoophiyaa';

  @override
  String get aboutCommissionBody =>
      'Komishiniin Zakaa fi Awqaaf Itoophiyaa walitti qabama zakaa fi misooma awqaaf qindeessuun hawaasa miidhamoo ta\'an iftoominaan fi sagantaa shari\'aa wajjin walsimuun ni deeggarra.';

  @override
  String get chipTransparencyFirst => 'Iftoomina dura';

  @override
  String get chipNationwideImpact => 'Bu\'aa biyyaalessaa';

  @override
  String get chipShariahAligned => 'Shari\'aa wajjin walsime';

  @override
  String get profileLanguagePreferences => 'Filannoo Afaanii';

  @override
  String get profileThemeMode => 'Fuula';

  @override
  String get themeLight => 'Ifa';

  @override
  String get themeDark => 'Dukkana';

  @override
  String get profileBiometricLogin => 'Seensa Baayomeetrikii';

  @override
  String get profileBiometricSubtitle => 'Quba yookaan fuula fayyadami';

  @override
  String get missingPaymentDetails => 'Bal\'ina kaffaltii hin jiru.';

  @override
  String get missingCertificateDetails => 'Bal\'ina ragaa hin jiru.';

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
  String get profileLoadErrorTitle =>
      'Piroofaayiliin kee fe\'amuu hin dandeenye';

  @override
  String get profileTryAgain => 'Ammas yaali';

  @override
  String get profileSectionImpactDashboard => 'Daashboordii Bu\'aa';

  @override
  String get profileSectionBeneficiaryInsights => 'Hubannoo Fayyadamtootaa';

  @override
  String get profileSectionPersonalInformation => 'Odeeffannoo Dhuunfaa';

  @override
  String get profileSectionSpiritualSettings => 'Qindaa\'ina Amantii';

  @override
  String get profileSectionCoreActions => 'Gochaalee Ijoo';

  @override
  String get profileSectionSettingsSecurity => 'Qindaa\'ina fi Nageenya';

  @override
  String get profileSectionSupport => 'Deeggarsa';

  @override
  String get profileNoNewNotifications => 'Beeksisa haaraa hin jiru';

  @override
  String get profileVerificationStatus => 'Haala Mirkaneessaa';

  @override
  String get profileFaydaVerified => 'Faydaan mirkanaa\'eera';

  @override
  String get profileNotVerified => 'Hin mirkanoofne';

  @override
  String get profileTotalZakatPaid => 'Walitti qabama zakaa kaffalame';

  @override
  String get profileFySummary => 'Cuunfaa bara baajataa 2023';

  @override
  String get profileActiveEndowments => 'Awqaafa hojii irra jiran';

  @override
  String get profileSustainableImpact => 'Bu\'aa itti fufiinsa qabu';

  @override
  String get profileBeneficiariesHelped => 'Fayyadamtoota deeggarsa argatan';

  @override
  String get profileAcrossPrograms => 'Sagantaalee hunda keessatti';

  @override
  String get profileApplicationStatus => 'Haala iyyannoo';

  @override
  String get profileLastDisbursement => 'Kaffaltii dhumaa';

  @override
  String get profileTotalAidReceived => 'Walitti qabama gargaarsa argame';

  @override
  String get profileEmailAddress => 'Teessoo Imeelii';

  @override
  String get profilePhoneNumber => 'Lakkoofsa Bilbilaa';

  @override
  String profileEditFieldComingSoon(String field) {
    return '$field gulaaluun yeroo dhihoo dhufa';
  }

  @override
  String get profileNisabThresholdAlerts => 'Beeksisa daangaa Nisaab';

  @override
  String get profileNisabThresholdAlertsSubtitle =>
      'Qabeenyi yeroo daangaa nisaab ga\'u ni beeksifna';

  @override
  String get profileChangePin => 'PIN Jijjiiri';

  @override
  String get profileChangePinComingSoon => 'PIN jijjiiruun yeroo dhihoo dhufa';

  @override
  String get profileMyZakatHistory => 'Seenaa Zakaa Koo';

  @override
  String get profileMyZakatHistorySubtitle => 'Galmee fi ragaa ilaali';

  @override
  String get profileZakatHistoryComingSoon => 'Seenaa zakaa yeroo dhihoo dhufa';

  @override
  String get profileMyAwqafEndowments => 'Awqaafa Koo';

  @override
  String get profileMyAwqafEndowmentsSubtitle =>
      'Manneen barnootaa fi boolla bishaanii ilaali';

  @override
  String get profileBeneficiaryApplication => 'Iyyannoo Fayyadamaa';

  @override
  String get profileApplyAsBeneficiary => 'Akka fayyadamaa ta\'uun galmaa\'i';

  @override
  String get profileBeneficiaryApplicationSubtitle =>
      'Gaaffii gargaarsaa galchi yookaan hordofi';

  @override
  String get profileApplyAsBeneficiarySubtitle =>
      'Gargaarsa argachuuf galmaa\'i';

  @override
  String get profileDonationHistory => 'Seenaa Arjoomaa';

  @override
  String get profileDonationHistorySubtitle => 'Gumaacha hunda ilaali';

  @override
  String get profileDonationHistoryComingSoon =>
      'Seenaa arjoomaa yeroo dhihoo dhufa';

  @override
  String get profileHelpCenter => 'Wiirtuu Gargaarsa';

  @override
  String get profileHelpCenterSubtitle =>
      'Gaaffilee yeroo baay\'ee fi qajeelfama';

  @override
  String get profileHelpCenterComingSoon =>
      'Wiirtuun gargaarsa yeroo dhihoo dhufa';

  @override
  String get profileSupportAndGrievances => 'Deeggarsa fi Komii';

  @override
  String get profileSupportAndGrievancesSubtitle =>
      'Garee keenya waliin dubbadhu';

  @override
  String get profileSupportCenterComingSoon =>
      'Wiirtuun deeggarsaa yeroo dhihoo dhufa';

  @override
  String get profileLogOut => 'Ba\'i';

  @override
  String get profileLogOutSubtitle => 'Yeroo ammaa jiru xumuri';

  @override
  String get profileLogOutDialogTitle => 'Ba\'uu barbaaddaa?';

  @override
  String get profileLogOutDialogBody =>
      'Meeshaa kana irratti app keessaa ni baata.';

  @override
  String get profileCancel => 'Haqi';

  @override
  String get profileHadithOfTheDay => 'Hadiisa Guyyaa';

  @override
  String get profileHadithQuote =>
      '\"Gaaddisi amanaa guyyaa qiyaamaa sadaqaa isaa ta\'a.\"';

  @override
  String get profileHadithSource => '— At-Tirmidhi';

  @override
  String get impactNationalImpact => 'Bu\'aa Biyyaalessaa';

  @override
  String get impactNotifications => 'Beeksisoota';

  @override
  String get impactCouldNotLoad =>
      'Bu\'aan biyyaalessaa fe\'amuu hin dandeenye';

  @override
  String get impactGeographicReach => 'Dhaqqabina Naannoo';

  @override
  String get impactBarakaStories => 'Seenaawwan Barakaa';

  @override
  String get impactActiveAwqafProjects =>
      'Pirojektoota Awqaaf Sochii Irra Jiran';

  @override
  String get impactAllProjectsComingSoon =>
      'Pirojektoonni hundi yeroo dhihoo dhufu';

  @override
  String get impactLiveImpactStream => 'Tamsaasa Bu\'aa Kallattii';

  @override
  String get impactDistributedFunds => 'Maallaqa Raabsame';

  @override
  String impactEtbAmount(String amount) {
    return '$amount ETB';
  }

  @override
  String get impactLivesTouched => 'Jireenyota Tuqaman';

  @override
  String get impactActiveProjects => 'Pirojektoota Sochii Irra Jiran';

  @override
  String get impactTapRegionHint => 'Bu\'aa naannoo ilaaluuf naannoo tuqi';

  @override
  String impactRegionImpactComingSoon(String region) {
    return 'Bu\'aan $region yeroo dhihoo dhufa';
  }

  @override
  String impactStoryComingSoon(String name) {
    return 'Seenaa $name yeroo dhihoo dhufa';
  }

  @override
  String impactProjectDetailsComingSoon(String title) {
    return 'Bal\'inni $title yeroo dhihoo dhufa';
  }

  @override
  String impactPercentFunded(String percent) {
    return '$percent% guutameera';
  }

  @override
  String impactEtbLeft(String amount) {
    return '$amount ETB hafa';
  }

  @override
  String get impactSeeYourPersonalBaraka => 'Barakaa Dhuunfaa Kee Ilaali';

  @override
  String get impactTrackStewardship =>
      'Bulchiinsa kee keessatti saantima hunda hordofi.';

  @override
  String get impactViewMyHistory => 'Seenaa Koo Ilaali';

  @override
  String get onboardingSkip => 'Darbi';

  @override
  String get onboardingNext => 'Itti Aanu';

  @override
  String get onboardingGetStarted => 'Jalqabi';

  @override
  String get onboardingTitleFaithAndPurpose => 'Amantii fi Kaayyoo';

  @override
  String get onboardingSubtitleFaithAndPurpose =>
      'Baga gara waltajjii amanamaa zakaa fi awqaaf bulchiinsaa dhuftan.';

  @override
  String get onboardingTitleTransparentGiving => 'Herregaa Zakaa';

  @override
  String get onboardingSubtitleTransparentGiving =>
      'Qabeenya, horii fi midhaan irratti qajeelfama ifaan zakaa kee saffisaan herregi.';

  @override
  String get onboardingTitleEasyPayments => 'Kaffaltii Saffisaa fi Salphaa';

  @override
  String get onboardingSubtitleEasyPayments =>
      'Muuxannoo amansiisaa fi mobaayilii irratti salphaan zakaa kee kaffali.';

  @override
  String get onboardingTitleCompassionInAction => 'Rahmata Hojii Keessatti';

  @override
  String get onboardingSubtitleCompassionInAction =>
      'Ifaafi amanamummaadhaan fayyadamtootaa fi pirojektoota deeggari.';
}
