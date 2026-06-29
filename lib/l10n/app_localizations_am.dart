// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appTitle => 'ዘካት እና አውቃፍ ኮሚሽን';

  @override
  String get splashSlogan => 'ለአላህ ብሎ ለሰው ልጅ አገልግሎት';

  @override
  String get splashWaqfByLabel => 'ዋቅፍ በ';

  @override
  String get splashWaqfByTitle => 'Coop Bank Alhuda';

  @override
  String get navHome => 'መነሻ';

  @override
  String get navCalculator => 'ማስያ';

  @override
  String get navImpact => 'ተፅዕኖ';

  @override
  String get navProfile => 'መገለጫ';

  @override
  String get homeCommissionTitle => 'ዘካት እና ወቅፍ ኮሚሽን';

  @override
  String get homeGreeting => 'አሰላሙ ዓለይኩም';

  @override
  String get registerAcceptZakat => 'ዘካት ለመቀበል ይመዝገቡ';

  @override
  String get urgentBeneficiaryNeeds => 'አስቸኳይ ጉዳዮች';

  @override
  String get viewAll => 'ሁሉንም ይመልከቱ →';

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
  String get payZakatCause => 'ዘካት ይስጡ';

  @override
  String get zakatAlFitr => 'ዘካት አልፊጥር';

  @override
  String get zakatDueDays => 'በግምት ከ22 ቀናት በኋላ ይደርሳል።';

  @override
  String get setReminder => 'ማስታወሻ ያዘጋጁ';

  @override
  String get needQuickWayGive => 'ፈጣን መስጫ';

  @override
  String get supportCommunityNeeds => 'በሰደቃ የማህበረሰብ ፍላጎቶችን ወዲያውኑ ይደግፉ።';

  @override
  String get donateSadaqah => 'ሰደቃ ይስጡ';

  @override
  String get aboutCommission => 'የኢትዮጵያ ዘካት እና ወቅፍ ኮሚሽን';

  @override
  String get aboutCommissionBody =>
      'የዘካት ስብስብን እና የወቅፍ ልማትን በማስተባበር ተጋላጭ ማህበረሰቦችን በግልጽነት እና ሸሪዓን በሚከተሉ ፕሮግራሞች በኢትዮጵያ ዙሪያ ይደግፋል።';

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
  String get calcAppBarTitle => 'ዘካት ካልኩሌተር';

  @override
  String get calcPayYourZakat => 'ዘካህን ክፈል።';

  @override
  String get calcTabWealth => 'ሀብት';

  @override
  String get calcTabLivestock => 'የእንስሳት እርባታ';

  @override
  String get calcTabCrops => 'ሰብሎች';

  @override
  String get calcStep1NisabTitle => 'ደረጃ 1፡ የኒሳብ ገደብ';

  @override
  String get calcStep1NisabBody =>
      'የእርስዎ የተጣራ ሀብት ከደረጃው ካለፈ ዘካት መከፈል አለበት። ኒሳብ በ 85g መድረክ 24k የወርቅ ዋጋ ላይ የተመሰረተ ነው።';

  @override
  String calcNisabGoldFormula(String grams, String price, String total) {
    return '${grams}_ × ${price}_ = $total';
  }

  @override
  String calcNisabThresholdBanner(String amount) {
    return 'የኒሳብ ገደብ (የመድረክ ደረጃ፣ 85ግ ወርቅ አቻ)፦ $amount';
  }

  @override
  String get calcUsdEtb => 'USD/ETB';

  @override
  String get calcFxLive => 'የቀጥታ የምንዛሬ ተመን መጠቀም';

  @override
  String get calcFxCache => 'የተሸጎጠ የምንዛሬ ተመንን በመጠቀም';

  @override
  String get calcFxFallback => 'የውድቀት ምንዛሬ ተመንን በመጠቀም';

  @override
  String get calcTimestampUnavailable => 'የጊዜ ማህተም የለም።';

  @override
  String get calcStep1LivestockTitle => 'ደረጃ 1፡ የከብት እርባታ ዘዴ';

  @override
  String get calcStep1LivestockBody =>
      'የእንስሳት ዘካት የሚሰላው በአካላዊ የራስ ቆጠራ ሚዛኖች (የዋጋ % ሳይሆን) ነው።';

  @override
  String get calcStep1LivestockNisabNote =>
      'የኒሳብ ገደቦች፡ በግ/ፍየል 40፣ከብቶች 30፣ ግመሎች 5.ከብቶች 30/40 ጥምር ይጠቀማሉ። ግመሎች የደረጃ ደረጃዎችን ይከተላሉ.';

  @override
  String calcAdvisoryPrefix(String text) {
    return 'ምክር፡ ${text}_';
  }

  @override
  String get calcArabicTermDefinitionsTitle => 'የአረብኛ ቃል ፍቺዎች';

  @override
  String get calcArabicDefTabi => 'የአንድ አመት ጥጃ';

  @override
  String get calcArabicDefMusinnah => 'የሁለት አመት ላም';

  @override
  String get calcArabicDefBintMakhad => 'የአንድ አመት ሴት ግመል';

  @override
  String get calcArabicDefBintLabun => 'የሁለት አመት ሴት ግመል';

  @override
  String get calcArabicDefHiqqah => 'የሶስት አመት ሴት ግመል';

  @override
  String get calcArabicDefJadhah => 'የአራት አመት ሴት ግመል';

  @override
  String get calcStep1CropTitle => 'ደረጃ 1፡ የሰብል (Ushr) ስሌት';

  @override
  String get calcStep1CropBody =>
      'የሰብል ዘካት በመኸር ወቅት ነው. ኒሳብ 653 ኪ.ግ. መጠኑ 10% (ዝናብ-የተበላ)፣ 5% (የመስኖ) ወይም የተቀላቀለ ክብደት ነው።';

  @override
  String calcCropLineThreshold(String kg, String relation) {
    return '${kg}_ ኪግ ${relation}_ 653 ኪ.ግ';
  }

  @override
  String calcCropLineIrrigation(String mode) {
    return 'የመስኖ ሁነታ፡ ${mode}_';
  }

  @override
  String calcCropLineEffectiveRate(String rate) {
    return 'ውጤታማ ዋጋ፡ ${rate}_%';
  }

  @override
  String calcCropLineFormula(String line) {
    return 'ቀመር፡ ${line}_';
  }

  @override
  String get calcRelationGte => '≥';

  @override
  String get calcRelationLt => '<';

  @override
  String get calcOverviewNetWorthTitle => 'የተጣራ ዎርዝ አጠቃላይ እይታ';

  @override
  String get calcOverviewLivestockTitle => 'የእንስሳት አጠቃላይ እይታ';

  @override
  String get calcOverviewCropTitle => 'አጠቃላይ እይታን ይከርክሙ';

  @override
  String get calcBadgeAboveNisab => 'ከኒሳብ በላይ';

  @override
  String get calcBadgeBelowNisab => 'ከኒሳብ በታች';

  @override
  String get calcBadgeZakatDue => 'ዘካት ክፍያ';

  @override
  String get calcBadgeNoDue => 'ምንም ክፍያ የለም።';

  @override
  String get calcZakatDueLabel => 'ዘካት ክፍያ';

  @override
  String get calcLivestockDueLabel => 'የከብት እርባታ';

  @override
  String get calcCropZakatDueLabel => 'ዘካት የሚከፈልበት ጊዜ ይከርክሙ';

  @override
  String calcAnimalsCount(int count) {
    return '${count}_ እንስሳት';
  }

  @override
  String calcKgHarvest(String kg) {
    return '${kg}_ ኪ.ግ መከር';
  }

  @override
  String get calcLivestockTermsFootnote =>
      'እንደ ታቢእ፣ ሙሲናህ፣ ቢንት ማክሃድ፣ ቢንት ላቡን፣ ሂቃህ እና ጃድሃህ የመሳሰሉ ቃላት በቁም እንስሳት ዝርዝር ውስጥ ከዚህ በታች ተብራርተዋል።';

  @override
  String get calcStep2EnterAssets => 'ደረጃ 2: የእርስዎን ንብረቶች ያስገቡ';

  @override
  String get calcStep2EnterAssetsBody => 'የንብረቶችህን ዋጋ በETB አስገባ';

  @override
  String get calcCashBankSavings => 'ጥሬ ገንዘብ እና የባንክ ቁጠባዎች';

  @override
  String get calcCashOnHand => 'ገንዘብ በእጅ ላይ';

  @override
  String get calcBankBalance => 'የባንክ ሂሳብ';

  @override
  String get calcMobileWallet => 'የሞባይል ቦርሳ';

  @override
  String get calcBusinessAssets => 'የንግድ ንብረቶች';

  @override
  String get calcFieldDescription => 'መግለጫ';

  @override
  String get calcFieldType => 'ዓይነት';

  @override
  String get calcAmountEtb => 'መጠን (ኢቲቢ)';

  @override
  String get calcAddBusinessAsset => 'የንግድ ንብረት ያክሉ';

  @override
  String get calcGoldSilver => 'ወርቅ እና ብር';

  @override
  String get calcGoldGrams => 'ወርቅ (ግራም)';

  @override
  String get calcGoldKarat => 'ወርቅ ካራት';

  @override
  String get calcSilverGrams => 'ብር (ግራም)';

  @override
  String get calcLiabilities => 'ተጠያቂነቶች';

  @override
  String get calcAddLiability => 'ተጠያቂነትን ጨምር';

  @override
  String get calcAssetInventory => 'ቆጠራ';

  @override
  String get calcAssetReceivable => 'የሚቀበል';

  @override
  String get calcAssetOther => 'ሌላ';

  @override
  String get calcLiabilityShortTermDebt => 'የአጭር ጊዜ ዕዳ';

  @override
  String get calcLiabilityPayable => 'የሚከፈል';

  @override
  String get calcLiabilityOther => 'ሌላ';

  @override
  String get calcLivestockSheepGoats => 'በግ / ፍየሎች';

  @override
  String get calcLivestockCattle => 'ከብት';

  @override
  String get calcLivestockCamels => 'ግመሎች';

  @override
  String get calcPastureFedTitle => 'አብዛኛውን አመት በግጦሽ ይመገባል።';

  @override
  String get calcPastureFedSubtitle => 'ምክር ብቻ; ስሌትን አያግድም።';

  @override
  String get calcHawlTitle => 'የተጠናቀቀው አንድ የጨረቃ ዓመት (ሀውል)';

  @override
  String get calcHawlSubtitle => 'ምክር ብቻ; ስሌትን አያግድም።';

  @override
  String get calcWorkAnimalsTitle => 'ለስራ (ማረሻ/መጓጓዣ) ጥቅም ላይ ይውላል';

  @override
  String get calcWorkAnimalsSubtitle => 'ምክር ብቻ; ስሌትን አያግድም።';

  @override
  String get calcLivestockSummaryHeading => 'የእንስሳት እርባታ ማጠቃለያ';

  @override
  String get calcCropNisabHeading => 'የኒሳብ እና የመከር ጊዜ';

  @override
  String calcEffectiveCropRateLine(String percent) {
    return 'ውጤታማ የሰብል መጠን፡ ${percent}_%';
  }

  @override
  String calcCropZakatDueKgLine(String kg) {
    return 'የሚከፈልበት ዘካ: ${kg}_ ኪ.ግ';
  }

  @override
  String get calcHowCropZakatWorksTitle => 'የሰብል ዘካት እንዴት እንደሚሰራ';

  @override
  String get calcHowCropZakatWorksBody =>
      'ኒሳብ፡ 653 ኪ.ግ. ተመኖች፡- በዝናብ መመገብ 10%፣ በመስኖ 5%፣ ድብልቅ = የክብደት ክፍፍል። ዘካ በመከር ወቅት መከፈል አለበት (ለሰብሎች አመታዊ ሃውል የለም)።';

  @override
  String get calcHowCropZakatNote =>
      'ማሳሰቢያ፡ መተግበሪያ እነዚህን ህጎች ለቀላልነት በሰፊው ይተገበራል። ምሁራዊ የስራ መደቦች በሰብል አይነት ስፋት እና በወጪ ተቀናሾች ላይ ይለያያሉ; ለተወሰኑ ጉዳዮች ብቁ ምሁራንን አማክር።';

  @override
  String get calcWealthNisabHeading => 'ንሰብ & ሃብት ዘካት';

  @override
  String calcWealthNisabLine(String nisab) {
    return 'የኒሳብ ገደብ፡ ${nisab}_';
  }

  @override
  String calcWealthZakatDueLine(String due) {
    return 'የሀብት ዘካት (በካርዱ ላይ ያለው አነስተኛ መጠን)፡ $due';
  }

  @override
  String get calcHowWealthZakatWorksTitle => 'ዘካት ሀብት እንዴት እንደሚሰላ';

  @override
  String calcHowWealthZakatWorksBody(int grams, int silverRate) {
    return 'በእጃችን ላይ ጥሬ ገንዘብ፣ የባንክ ሒሳቦች፣ የሞባይል ቦርሳዎች፣ የንግድ ሥራ ንብረቶች እና የወርቅ እና የብር ዋጋ እንጨምራለን። ኒሳብ $grams ግራም ወርቅ በመተግበሪያው 24k ዋጋ ግራም ነው። የያዙት ወርቅ የሚለካው ለመረጡት የካራት የመተግበሪያውን ዋጋ በመጠቀም ነው። ብር በአንድ ግራም $silverRate ETB ቋሚ ማጣቀሻ ይጠቀማል። የተጣራ ሀብት ለማግኘት የሚያስገቧቸው ዕዳዎች ይቀነሳሉ። የተጣራ ሀብት በኒሳብ ወይም ከዚያ በላይ ከሆነ, የዘካ ክፍያ ከተጣራ ሀብት 2.5% ነው.';
  }

  @override
  String get calcHowWealthZakatNote =>
      'ማሳሰቢያ፡- ሊቃውንት የየትኞቹ ንብረቶች ዘካ እንደሚሆኑ፣ ዕዳዎች ሀብትን እንዴት እንደሚቀነሱ፣ የጨረቃ ዓመት (ሀውል) በሚውልበት ጊዜ እና ሌሎች ዝርዝሮች ይለያያሉ። ይህ ማያ ገጽ ትምህርታዊ ግምት ነው - ሁኔታዎን ብቃት ካላቸው ምሁራን ጋር ያረጋግጡ።';

  @override
  String get calcWealthBreakdownTitle => 'ከላይ ያሉት መጠኖች እንዴት እንደሚሰሉ';

  @override
  String calcWealthTransLiquidsLine(
    String cash,
    String bank,
    String mobile,
    String subtotal,
  ) {
    return 'ጥሬ ገንዘብ + ባንክ + ሞባይል፡ $cash + $bank + $mobile = $subtotal';
  }

  @override
  String calcWealthTransBusinessLine(String business) {
    return 'የንግድ ንብረቶች (የረድፎች ድምር): ${business}_';
  }

  @override
  String calcWealthTransRollupLine(
    String liquids,
    String business,
    String gold,
    String silver,
    String total,
  ) {
    return 'ጠቅላላ ንብረቶች፡ ${liquids}_ + $business + $gold + $silver = $total';
  }

  @override
  String calcWealthTransNisabLine(String grams, String price, String nisab) {
    return 'ኒሳብ፡ ${grams}_ g × 24k ($price/ግ) = $nisab';
  }

  @override
  String calcWealthTransGoldLine(
    String grams,
    String karat,
    String price,
    String value,
  ) {
    return 'ወርቅ፡ ${grams}_ g × ${karat}_ ($price/ግ) = $value';
  }

  @override
  String calcWealthTransSilverLine(String grams, String rate, String value) {
    return 'ብር፡ ${grams}_ g × ${rate}_ ኢቲቢ/ግ = $value';
  }

  @override
  String calcWealthTransNetLine(String liabilities, String net) {
    return 'የተጣራ ሀብት (በካርዱ ላይ ትልቅ መጠን)፡ ጠቅላላ ንብረቶች - እዳዎች ($liabilities) = $net';
  }

  @override
  String calcWealthTransDueAbove(String net, String due, String nisab) {
    return 'ምክንያቱም ${net}_ በኒሳብ ($nisab) ላይ ወይም ከዚያ በላይ ስለሆነ፣ ዘካተ ክፍያ = $net × 2.5% = $due።';
  }

  @override
  String calcWealthTransDueBelow(String net, String nisab, String due) {
    return 'ምክንያቱም ${net}_ ከኒሳብ በታች ነው ($nisab)፣ የሀብት ዘካት ክፍያ = $due።';
  }

  @override
  String get calcCropWeightKg => 'የሰብል ክብደት (ኪግ)';

  @override
  String get calcCropModeRainFed => 'በዝናብ የተሞላ';

  @override
  String get calcCropModeIrrigated => 'መስኖ የገባ';

  @override
  String get calcCropModeMixed => 'የተቀላቀለ';

  @override
  String get calcRainFedSharePct => 'በዝናብ ላይ የተመሰረተ ድርሻ %';

  @override
  String get calcIrrigatedSharePct => 'የመስኖ ድርሻ %';

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
  String get calcMethodologyPlaceholder => 'የዘካት ዘዴ ይዘት ቦታ ያዥ።';

  @override
  String get calcPayBlockedWealth =>
      'ዘካት ምንም አይነት ሀብት አይከፈልም ​​(ከኒሳብ በታች ወይም ከዜሮ ኢቲቢ ክፍያ በታች)። ግብዓቶችዎን ያስተካክሉ።';

  @override
  String get calcPayBlockedLivestock => 'ለአሁኑ ቆጠራዎ ምንም የእንስሳት ዘካት አይከፈልበትም።';

  @override
  String get calcPayBlockedCrops =>
      'የሰብል ዘካት ገና አልገባም (ከመከር ኒሳብ በታች ወይም ከዜሮ ኪሎ ግራም በታች)።';

  @override
  String calcCertCropDueLine(String kg) {
    return 'የሚከፈልበት ዘካ: ${kg}_ ኪ.ግ';
  }

  @override
  String get calcBulletSeparator => ' • ';

  @override
  String calcLsSheepGoats(int count) {
    return 'በግ/ፍየሎች፡$count በግ';
  }

  @override
  String calcLsCattle(int tabi, int musinnah) {
    return 'ከብት፡ ${tabi}_ ታቢ\' + $musinnah ሙሲናህ';
  }

  @override
  String calcLsCamels(String description) {
    return 'ግመሎች፡ ${description}_';
  }

  @override
  String get calcLsNone => 'አሁን ባለው ቆጠራ ምክንያት ምንም የቤት እንስሳ የለም።';

  @override
  String calcTransSheep(int head, int due) {
    return 'የበግ/የፍየል ደጃፍ፡_ ${head}_ >= 40=የሚገባው $due በግ።';
  }

  @override
  String calcTransCattle(int head, int tabi, int musinnah) {
    return 'የከብት እርከን፡_ ${head}_ >= 30 => የሚከፈልበት $tabi ታቢዕ፣ $musinnah ሙሲና (30/40 ጥምር)።';
  }

  @override
  String calcTransCamel(int head, String due) {
    return 'የግመል ገደብ፡_ ${head}_ >= 5=\\u003e $due።';
  }

  @override
  String calcTransAdvisoryLine(String text) {
    return 'ምክር፡ ${text}_';
  }

  @override
  String get calcAdvNotPasture =>
      'አብዛኛውን አመት በግጦሽ የማይመገብ፡ ንግድ/የንግድ አያያዝ ከምሁራን ጋር ያረጋግጡ።';

  @override
  String get calcAdvHawl =>
      'ኸል አልተጠናቀቀም፡ ብዙ ሊቃውንት ለከብቶች ዘካ አንድ የጨረቃ አመት ይፈልጋሉ።';

  @override
  String get calcAdvWork => 'የስራ እንስሳት በተለምዶ ከእንስሳት ዘካ ነፃ ናቸው።';

  @override
  String calcCropTransBelow(String kg, String nisab) {
    return 'መኸር ${kg}_ኪሎ ከኒሳብ ($nisab ኪሎ ግራም) በታች ነው፣ ስለዚህ ምንም የሰብል ዘካት መከፈል የለበትም።';
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
    return 'የተቀላቀለ መስኖ፡ ዝናብ $rain%፣ መስኖ $irrig%. ውጤታማ ተመን = ${rate}_%. ቀመር፡ ${kg}_ × $rate2% = $dueኪሎ';
  }

  @override
  String calcCropTransRainFed(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'በዝናብ-የተመገብን መጠን ${rate}_%. ፎርሙላ፡ ${kg}_ × $rate2% = $dueኪሎ';
  }

  @override
  String calcCropTransIrrigated(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'የመስኖ መጠን $rate%. ፎርሙላ፡ ${kg}_ × $rate2% = $dueኪሎ';
  }

  @override
  String get calcCamelNoDue => 'ምንም ክፍያ የለም።';

  @override
  String calcCamelSheepN(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count በግ',
      one: '1 በግ',
    );
    return '$_temp0';
  }

  @override
  String get calcCamel1BintMakhad => '1 ቢንት ማክሃድ';

  @override
  String get calcCamel1BintLabun => '1 ቢንት ላቡን';

  @override
  String get calcCamel1Hiqqah => '1 ሂቃህ';

  @override
  String get calcCamel1Jadhah => '1 ጃዳህ';

  @override
  String get calcCamel2BintLabun => '2 ቢንት ላቡን';

  @override
  String get calcCamel2Hiqqah => '2 ሂቃህ';

  @override
  String calcCamelCombo(int hiqqah, int bintLabun) {
    return '${hiqqah}_ ሂቃህ + $bintLabun ቢንት ላቡን';
  }

  @override
  String calcCamelApproxBintLabun(int count) {
    return '${count}_ ቢንት ላቡን (ግምታዊ ጥምር)';
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
  String get loginTitle => 'ይግቡ';

  @override
  String get loginSubtitle => 'የእርስዎን የተመዘገበ ስልክ ቁጥር እና የይለፍ ቃል ይጠቀሙ';

  @override
  String get loginPhoneLabel => 'ስልክ ቁጥር';

  @override
  String get loginPasswordLabel => 'የይለፍ ቃል';

  @override
  String get loginButton => 'ይግቡ';

  @override
  String get loginPhoneRequired => 'ስልክ ቁጥርህን አስገባ';

  @override
  String get loginPhoneInvalid =>
      'የሚሰራ ባለ 9-አሃዝ የሞባይል ቁጥር ያስገቡ (ለምሳሌ 923974838)';

  @override
  String get loginSecureNote => 'መግባትህ የተመሰጠረ እና ደህንነቱ የተጠበቀ ነው።';

  @override
  String get loginPasswordRequired => 'የይለፍ ቃልዎን ያስገቡ';

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
  String get onboardingTitleTransparentGiving => 'የዘካት ማስያ';

  @override
  String get onboardingSubtitleTransparentGiving =>
      'ዘካትዎን በሀብት፣ በእንስሳት እና በሰብል ላይ በግልጽ መመሪያ ወዲያውኑ ያስሉ።';

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

  @override
  String get donationCurrencySheetTitle => 'እንዴት መስጠት ይፈልጋሉ?';

  @override
  String get donationCurrencySheetSubtitle =>
      'የሀገር ውስጥ የኢቲቢ ክፍያ ወይም የአለምአቀፍ ካርድ ክፍያ ይምረጡ።';

  @override
  String get donationLocalPaymentTitle => 'የአካባቢ ክፍያ (ኢ.ቲ.ቢ.)';

  @override
  String get donationLocalPaymentSubtitle =>
      'ቴሌቢር፣ ንግድ ባንክ ብር፣ ኤም-ፔሳ እና ሌሎች የኢትዮጵያ መግቢያ መንገዶች።';

  @override
  String get donationInternationalPaymentTitle => 'ዓለም አቀፍ ክፍያ';

  @override
  String get donationInternationalPaymentSubtitle =>
      'ከየትኛውም ቦታ ሆነው በካርድዎ እና በክፍያ አድራሻዎ ይክፈሉ።';

  @override
  String get donationInternationalTitle => 'ዓለም አቀፍ ሰዳቃ';

  @override
  String get donationInternationalSubtitle =>
      'በዓለም ላይ ከየትኛውም ቦታ ሆነው ማህበረሰቦችን ይደግፉ።';

  @override
  String get donationAmountLabel => 'የመዋጮ መጠን';

  @override
  String get donationAmountHint => '0.00';

  @override
  String get donationAmountHelper => 'መጠኑ በኢትዮጵያ ብር (ኢቲቢ) ተቀምጧል።';

  @override
  String get donationAnonymousLabel => 'ስም-አልባ ስጡ';

  @override
  String get donationAnonymousSubtitle => 'ስምህ በይፋ አይታይም።';

  @override
  String get donationDonorSectionTitle => 'ዝርዝሮችህ';

  @override
  String get donationFullNameLabel => 'ሙሉ ስም';

  @override
  String get donationPhoneLabel => 'ስልክ';

  @override
  String get donationEmailLabel => 'ኢሜይል';

  @override
  String get donationBillingSectionTitle => 'የመክፈያ አድራሻ';

  @override
  String get donationAddress1Label => 'የአድራሻ መስመር 1';

  @override
  String get donationAddress2Label => 'አድራሻ መስመር 2 (አማራጭ)';

  @override
  String get donationCountryLabel => 'ሀገር';

  @override
  String get donationCountryOther => 'የሀገር ስም';

  @override
  String get donationAdminAreaLabel => 'ግዛት / ክልል';

  @override
  String get donationLocalityLabel => 'ከተማ';

  @override
  String get donationPostalCodeLabel => 'የፖስታ መላኪያ ኮድ';

  @override
  String get donationContinueToPayment => 'መክፈሉን ይቀጥሉ';

  @override
  String get donationSubmitting => 'በማስሄድ ላይ…';

  @override
  String get donationSuccess => 'ስለ ሰደቃህ አመሰግናለሁ።';

  @override
  String get donationValidationPhone =>
      'የሚሰራ ስልክ ቁጥር በአለምአቀፍ ቅርጸት አስገባ (ለምሳሌ +15551234567)።';

  @override
  String get donationPaymentWebViewTitle => 'ሙሉ ክፍያ';

  @override
  String get donationSelectCountry => 'አገር ይምረጡ';

  @override
  String get donationSearchCountry => 'አገሮችን ይፈልጉ';

  @override
  String get donationSelectState => 'ግዛት/አውራጃ ይምረጡ';

  @override
  String get donationSearchState => 'በስም ወይም በምህፃረ ቃል ይፈልጉ';

  @override
  String get donationNoMatchesFound => 'ምንም ተዛማጅ አልተገኙም።';

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
}
