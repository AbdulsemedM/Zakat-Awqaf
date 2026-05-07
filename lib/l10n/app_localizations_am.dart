// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appTitle => 'Zakat & Awqaf Commission';

  @override
  String get navHome => 'መነሻ';

  @override
  String get navCalculator => 'ማስያ';

  @override
  String get navImpact => 'ተፅዕኖ';

  @override
  String get navProfile => 'መገለጫ';

  @override
  String get homeCommissionTitle => 'የዘካትና ወቅፍ ኮሚሽን';

  @override
  String get homeGreeting => 'አሰላሙ ዓለይኩም';

  @override
  String get registerAcceptZakat => 'ዘካት ለመቀበል ይመዝገቡ';

  @override
  String get urgentBeneficiaryNeeds => 'አስቸኳይ የተጠቃሚ ፍላጎቶች';

  @override
  String get viewAll => 'ሁሉንም ይመልከቱ';

  @override
  String get totalZakatCollected => 'ጠቅላላ የተሰበሰበ ዘካት';

  @override
  String get thisMonth => 'ይህ ወር';

  @override
  String get totalBeneficiariesSupported => 'ድጋፍ የተደረገላቸው ጠቅላላ ተጠቃሚዎች';

  @override
  String get transparencyQuote =>
      'ግልጽ፣ ተጠያቂ እና ተፅዕኖ ያለው፤ ስጦታዎ ሀገር አቀፍ ድጋፍን እና ማበረታቻን ያበረታታል።';

  @override
  String get payZakatCause => 'ለዚህ ምክንያት ዘካት ይክፈሉ';

  @override
  String get zakatAlFitr => 'ዘካት አልፊጥር';

  @override
  String get zakatDueDays => 'በግምት ከ22 ቀናት በኋላ ይደርሳል።';

  @override
  String get setReminder => 'ማስታወሻ ያዘጋጁ';

  @override
  String get needQuickWayGive => 'ፈጣን መስጫ መንገድ ይፈልጋሉ?';

  @override
  String get supportCommunityNeeds => 'በሰደቃ የማህበረሰብ ፍላጎቶችን ወዲያውኑ ይደግፉ።';

  @override
  String get donateSadaqah => 'ሰደቃ ይስጡ';

  @override
  String get aboutCommission => 'ስለ ኢትዮጵያ ዘካትና ወቅፍ ኮሚሽን';

  @override
  String get aboutCommissionBody =>
      'የኢትዮጵያ ዘካትና ወቅፍ ኮሚሽን የዘካት ስብስብን እና የወቅፍ ልማትን በማስተባበር ተጋላጭ ማህበረሰቦችን በግልጽነት እና ሸሪዓን በሚከተሉ ፕሮግራሞች ይደግፋል።';

  @override
  String get chipTransparencyFirst => 'ግልጽነት ቀዳሚ';

  @override
  String get chipNationwideImpact => 'ሀገር አቀፍ ተፅዕኖ';

  @override
  String get chipShariahAligned => 'ከሸሪዓ ጋር የተስማማ';

  @override
  String get profileLanguagePreferences => 'የቋንቋ ምርጫ';

  @override
  String get profileThemeMode => 'ገጽታ';

  @override
  String get themeLight => 'ብሩህ';

  @override
  String get themeDark => 'ጨለማ';

  @override
  String get profileBiometricLogin => 'ባዮሜትሪክ ግባ';

  @override
  String get profileBiometricSubtitle => 'የጣት አሻራ ወይም ፊት መለያ ይጠቀሙ';

  @override
  String get missingPaymentDetails => 'የክፍያ ዝርዝር የለም።';

  @override
  String get missingCertificateDetails => 'የምስክር ወረቀት ዝርዝር የለም።';

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
  String get profileLoadErrorTitle => 'መገለጫዎ መጫን አልተቻለም';

  @override
  String get profileTryAgain => 'እንደገና ሞክር';

  @override
  String get profileSectionImpactDashboard => 'የተፅዕኖ ዳሽቦርድ';

  @override
  String get profileSectionBeneficiaryInsights => 'የተጠቃሚ ግንዛቤዎች';

  @override
  String get profileSectionPersonalInformation => 'የግል መረጃ';

  @override
  String get profileSectionSpiritualSettings => 'መንፈሳዊ ቅንብሮች';

  @override
  String get profileSectionCoreActions => 'ዋና እርምጃዎች';

  @override
  String get profileSectionSettingsSecurity => 'ቅንብሮች እና ደህንነት';

  @override
  String get profileSectionSupport => 'ድጋፍ';

  @override
  String get profileNoNewNotifications => 'አዲስ ማሳወቂያ የለም';

  @override
  String get profileVerificationStatus => 'የማረጋገጫ ሁኔታ';

  @override
  String get profileFaydaVerified => 'በፋይዳ የተረጋገጠ';

  @override
  String get profileNotVerified => 'አልተረጋገጠም';

  @override
  String get profileTotalZakatPaid => 'ጠቅላላ የተከፈለ ዘካት';

  @override
  String get profileFySummary => 'የ2015 በጀት ዓመት ማጠቃለያ';

  @override
  String get profileActiveEndowments => 'ንቁ ወቅፎች';

  @override
  String get profileSustainableImpact => 'ዘላቂ ተፅዕኖ';

  @override
  String get profileBeneficiariesHelped => 'የተረዱ ተጠቃሚዎች';

  @override
  String get profileAcrossPrograms => 'በፕሮግራሞች ውስጥ';

  @override
  String get profileApplicationStatus => 'የማመልከቻ ሁኔታ';

  @override
  String get profileLastDisbursement => 'የመጨረሻ ክፍያ';

  @override
  String get profileTotalAidReceived => 'ጠቅላላ የተቀበሉት እርዳታ';

  @override
  String get profileEmailAddress => 'ኢሜይል አድራሻ';

  @override
  String get profilePhoneNumber => 'ስልክ ቁጥር';

  @override
  String profileEditFieldComingSoon(String field) {
    return '$field ማስተካከያ በቅርቡ ይመጣል';
  }

  @override
  String get profileNisabThresholdAlerts => 'የኒሳብ ገደብ ማሳወቂያዎች';

  @override
  String get profileNisabThresholdAlertsSubtitle => 'ሀብት ወደ ኒሳብ ሲደርስ ያሳውቁ';

  @override
  String get profileChangePin => 'PIN ይቀይሩ';

  @override
  String get profileChangePinComingSoon => 'PIN መቀየር በቅርቡ ይመጣል';

  @override
  String get profileMyZakatHistory => 'የዘካት ታሪኬ';

  @override
  String get profileMyZakatHistorySubtitle => 'መዝገብ እና ሰርቲፊኬቶችን ይመልከቱ';

  @override
  String get profileZakatHistoryComingSoon => 'የዘካት ታሪክ በቅርቡ ይመጣል';

  @override
  String get profileMyAwqafEndowments => 'የእኔ ወቅፍ ንብረቶች';

  @override
  String get profileMyAwqafEndowmentsSubtitle => 'ትምህርት ቤቶችን እና ጉድጓዶችን ይመልከቱ';

  @override
  String get profileBeneficiaryApplication => 'የተጠቃሚ ማመልከቻ';

  @override
  String get profileApplyAsBeneficiary => 'እንደ ተጠቃሚ ይመዝገቡ';

  @override
  String get profileBeneficiaryApplicationSubtitle =>
      'የእርዳታ ጥያቄዎችን ያስገቡ ወይም ይከታተሉ';

  @override
  String get profileApplyAsBeneficiarySubtitle => 'እርዳታ ለመቀበል ይመዝገቡ';

  @override
  String get profileDonationHistory => 'የልገሳ ታሪክ';

  @override
  String get profileDonationHistorySubtitle => 'ሁሉንም አስተዋጽኦ ይመልከቱ';

  @override
  String get profileDonationHistoryComingSoon => 'የልገሳ ታሪክ በቅርቡ ይመጣል';

  @override
  String get profileHelpCenter => 'የእገዛ ማዕከል';

  @override
  String get profileHelpCenterSubtitle => 'ተደጋጋሚ ጥያቄዎች እና መመሪያ';

  @override
  String get profileHelpCenterComingSoon => 'የእገዛ ማዕከል በቅርቡ ይመጣል';

  @override
  String get profileSupportAndGrievances => 'ድጋፍ እና ቅሬታዎች';

  @override
  String get profileSupportAndGrievancesSubtitle => 'ከቡድናችን ጋር ይነጋገሩ';

  @override
  String get profileSupportCenterComingSoon => 'የድጋፍ ማዕከል በቅርቡ ይመጣል';

  @override
  String get profileLogOut => 'ውጣ';

  @override
  String get profileLogOutSubtitle => 'የአሁኑን ክፍለ ጊዜ ያቁሙ';

  @override
  String get profileLogOutDialogTitle => 'ልትወጡ ነው?';

  @override
  String get profileLogOutDialogBody => 'በዚህ መሣሪያ ላይ ከመተግበሪያው ይወጣሉ።';

  @override
  String get profileCancel => 'ሰርዝ';

  @override
  String get profileHadithOfTheDay => 'የዛሬ ሐዲስ';

  @override
  String get profileHadithQuote => '\"በትንሣኤ ቀን የአማኙ ጥላ ሰደቃው ነው።\"';

  @override
  String get profileHadithSource => '— አት-ቲርሚዚ';

  @override
  String get impactNationalImpact => 'ሀገር አቀፍ ተፅዕኖ';

  @override
  String get impactNotifications => 'ማሳወቂያዎች';

  @override
  String get impactCouldNotLoad => 'ሀገር አቀፍ ተፅዕኖ መጫን አልተቻለም';

  @override
  String get impactGeographicReach => 'የአካባቢ ስፋት';

  @override
  String get impactBarakaStories => 'የበረከት ታሪኮች';

  @override
  String get impactActiveAwqafProjects => 'ንቁ የወቅፍ ፕሮጀክቶች';

  @override
  String get impactAllProjectsComingSoon => 'ሁሉም ፕሮጀክቶች በቅርቡ ይመጣሉ';

  @override
  String get impactLiveImpactStream => 'ቀጥታ የተፅዕኖ ስርጭት';

  @override
  String get impactDistributedFunds => 'የተከፋፈለ ገንዘብ';

  @override
  String impactEtbAmount(String amount) {
    return '$amount ብር';
  }

  @override
  String get impactLivesTouched => 'የተነኩ ሕይወቶች';

  @override
  String get impactActiveProjects => 'ንቁ ፕሮጀክቶች';

  @override
  String get impactTapRegionHint => 'አካባቢያዊ ተፅዕኖ ለማየት ክልል ይንኩ';

  @override
  String impactRegionImpactComingSoon(String region) {
    return 'የ$region ተፅዕኖ በቅርቡ ይመጣል';
  }

  @override
  String impactStoryComingSoon(String name) {
    return 'የ$name ታሪክ በቅርቡ ይመጣል';
  }

  @override
  String impactProjectDetailsComingSoon(String title) {
    return 'የ$title ዝርዝሮች በቅርቡ ይመጣሉ';
  }

  @override
  String impactPercentFunded(String percent) {
    return '$percent% ተሸፍኗል';
  }

  @override
  String impactEtbLeft(String amount) {
    return '$amount ብር ይቀራል';
  }

  @override
  String get impactSeeYourPersonalBaraka => 'የግል በረከትዎን ይመልከቱ';

  @override
  String get impactTrackStewardship => 'የእርስዎን አስተዳደር እያንዳንዱን ሳንቲም ይከታተሉ።';

  @override
  String get impactViewMyHistory => 'ታሪኬን ይመልከቱ';

  @override
  String get onboardingSkip => 'ዝለል';

  @override
  String get onboardingNext => 'ቀጣይ';

  @override
  String get onboardingGetStarted => 'ጀምር';

  @override
  String get onboardingTitleFaithAndPurpose => 'እምነት ከዓላማ ጋር';

  @override
  String get onboardingSubtitleFaithAndPurpose =>
      'ለዘካትና ወቅፍ አስተዳደር የታመነ መድረክ እንኳን ደህና መጡ።';

  @override
  String get onboardingTitleTransparentGiving => 'ግልጽ ስጦታ';

  @override
  String get onboardingSubtitleTransparentGiving =>
      'ልገሳዎ በማህበረሰብ ላይ እውነተኛ ተፅዕኖ እንዴት እንደሚፈጥር ይከታተሉ።';

  @override
  String get onboardingTitleEasyPayments => 'ፈጣን እና ቀላል ክፍያ';

  @override
  String get onboardingSubtitleEasyPayments =>
      'በደህንነት እና በቀላሉ በሞባይል ተስማሚ ተሞክሮ ዘካትዎን ይክፈሉ።';

  @override
  String get onboardingTitleCompassionInAction => 'ርህራሄ በተግባር';

  @override
  String get onboardingSubtitleCompassionInAction =>
      'ተጠቃሚዎችንና ፕሮጀክቶችን በግልጽነት፣ በእምነት እና በበረከት ይደግፉ።';
}
