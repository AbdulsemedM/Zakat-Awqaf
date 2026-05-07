// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Zakat & Awqaf Commission';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCalculator => 'الحاسبة';

  @override
  String get navImpact => 'الأثر';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get homeCommissionTitle => 'هيئة الزكاة والأوقاف';

  @override
  String get homeGreeting => 'السلام عليكم';

  @override
  String get registerAcceptZakat => 'سجل لاستلام الزكاة';

  @override
  String get urgentBeneficiaryNeeds => 'احتياجات المستفيدين العاجلة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get totalZakatCollected => 'إجمالي الزكاة المحصلة';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get totalBeneficiariesSupported => 'إجمالي المستفيدين المدعومين';

  @override
  String get transparencyQuote =>
      'بشفافية ومساءلة وأثر حقيقي: عطاؤك يدعم الإغاثة والتمكين على مستوى الوطن.';

  @override
  String get payZakatCause => 'ادفع الزكاة لهذه الحالة';

  @override
  String get zakatAlFitr => 'زكاة الفطر';

  @override
  String get zakatDueDays => 'الموعد بعد حوالي 22 يوماً.';

  @override
  String get setReminder => 'ضبط تذكير';

  @override
  String get needQuickWayGive => 'تحتاج طريقة سريعة للتبرع؟';

  @override
  String get supportCommunityNeeds => 'ادعم احتياجات المجتمع فوراً بالصدقة.';

  @override
  String get donateSadaqah => 'تبرع بصدقة';

  @override
  String get aboutCommission => 'حول هيئة الزكاة والأوقاف الإثيوبية';

  @override
  String get aboutCommissionBody =>
      'تنسق هيئة الزكاة والأوقاف الإثيوبية جمع الزكاة وتطوير الأوقاف لرفع المجتمعات الهشة عبر برامج شفافة ومتوافقة مع الشريعة.';

  @override
  String get chipTransparencyFirst => 'الشفافية أولاً';

  @override
  String get chipNationwideImpact => 'أثر على مستوى الوطن';

  @override
  String get chipShariahAligned => 'متوافق مع الشريعة';

  @override
  String get profileLanguagePreferences => 'تفضيلات اللغة';

  @override
  String get profileThemeMode => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get profileBiometricLogin => 'تسجيل الدخول البيومتري';

  @override
  String get profileBiometricSubtitle => 'استخدم البصمة أو التعرف على الوجه';

  @override
  String get missingPaymentDetails => 'تفاصيل الدفع غير متوفرة.';

  @override
  String get missingCertificateDetails => 'تفاصيل الشهادة غير متوفرة.';

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
  String get profileLoadErrorTitle => 'تعذر تحميل ملفك الشخصي';

  @override
  String get profileTryAgain => 'حاول مرة أخرى';

  @override
  String get profileSectionImpactDashboard => 'لوحة الأثر';

  @override
  String get profileSectionBeneficiaryInsights => 'رؤى المستفيد';

  @override
  String get profileSectionPersonalInformation => 'المعلومات الشخصية';

  @override
  String get profileSectionSpiritualSettings => 'الإعدادات الشرعية';

  @override
  String get profileSectionCoreActions => 'الإجراءات الأساسية';

  @override
  String get profileSectionSettingsSecurity => 'الإعدادات والأمان';

  @override
  String get profileSectionSupport => 'الدعم';

  @override
  String get profileNoNewNotifications => 'لا توجد إشعارات جديدة';

  @override
  String get profileVerificationStatus => 'حالة التحقق';

  @override
  String get profileFaydaVerified => 'موثّق بفايدة';

  @override
  String get profileNotVerified => 'غير موثّق';

  @override
  String get profileTotalZakatPaid => 'إجمالي الزكاة المدفوعة';

  @override
  String get profileFySummary => 'ملخص السنة المالية 2023';

  @override
  String get profileActiveEndowments => 'الأوقاف النشطة';

  @override
  String get profileSustainableImpact => 'أثر مستدام';

  @override
  String get profileBeneficiariesHelped => 'المستفيدون الذين تمت مساعدتهم';

  @override
  String get profileAcrossPrograms => 'عبر البرامج';

  @override
  String get profileApplicationStatus => 'حالة الطلب';

  @override
  String get profileLastDisbursement => 'آخر صرف';

  @override
  String get profileTotalAidReceived => 'إجمالي المساعدات المستلمة';

  @override
  String get profileEmailAddress => 'البريد الإلكتروني';

  @override
  String get profilePhoneNumber => 'رقم الهاتف';

  @override
  String profileEditFieldComingSoon(String field) {
    return 'تعديل $field قريبًا';
  }

  @override
  String get profileNisabThresholdAlerts => 'تنبيهات حد النصاب';

  @override
  String get profileNisabThresholdAlertsSubtitle =>
      'الإشعار عند بلوغ الثروة حد النصاب';

  @override
  String get profileChangePin => 'تغيير الرقم السري';

  @override
  String get profileChangePinComingSoon => 'تغيير الرقم السري قريبًا';

  @override
  String get profileMyZakatHistory => 'سجل الزكاة الخاص بي';

  @override
  String get profileMyZakatHistorySubtitle => 'عرض السجل والشهادات';

  @override
  String get profileZakatHistoryComingSoon => 'سجل الزكاة قريبًا';

  @override
  String get profileMyAwqafEndowments => 'أوقافي';

  @override
  String get profileMyAwqafEndowmentsSubtitle => 'عرض المدارس والآبار';

  @override
  String get profileBeneficiaryApplication => 'طلب المستفيد';

  @override
  String get profileApplyAsBeneficiary => 'التقديم كمستفيد';

  @override
  String get profileBeneficiaryApplicationSubtitle =>
      'إرسال أو متابعة طلبات الدعم';

  @override
  String get profileApplyAsBeneficiarySubtitle => 'سجّل لتلقي المساعدة';

  @override
  String get profileDonationHistory => 'سجل التبرعات';

  @override
  String get profileDonationHistorySubtitle => 'عرض كل مساهمة';

  @override
  String get profileDonationHistoryComingSoon => 'سجل التبرعات قريبًا';

  @override
  String get profileHelpCenter => 'مركز المساعدة';

  @override
  String get profileHelpCenterSubtitle => 'الأسئلة الشائعة والإرشاد';

  @override
  String get profileHelpCenterComingSoon => 'مركز المساعدة قريبًا';

  @override
  String get profileSupportAndGrievances => 'الدعم والشكاوى';

  @override
  String get profileSupportAndGrievancesSubtitle => 'تواصل مع فريقنا';

  @override
  String get profileSupportCenterComingSoon => 'مركز الدعم قريبًا';

  @override
  String get profileLogOut => 'تسجيل الخروج';

  @override
  String get profileLogOutSubtitle => 'إنهاء جلستك الحالية';

  @override
  String get profileLogOutDialogTitle => 'تسجيل الخروج؟';

  @override
  String get profileLogOutDialogBody =>
      'سيتم تسجيل خروجك من التطبيق على هذا الجهاز.';

  @override
  String get profileCancel => 'إلغاء';

  @override
  String get profileHadithOfTheDay => 'حديث اليوم';

  @override
  String get profileHadithQuote => '\"ظل المؤمن يوم القيامة صدقته.\"';

  @override
  String get profileHadithSource => '— الترمذي';

  @override
  String get impactNationalImpact => 'الأثر الوطني';

  @override
  String get impactNotifications => 'الإشعارات';

  @override
  String get impactCouldNotLoad => 'تعذر تحميل الأثر الوطني';

  @override
  String get impactGeographicReach => 'الانتشار الجغرافي';

  @override
  String get impactBarakaStories => 'قصص البركة';

  @override
  String get impactActiveAwqafProjects => 'مشاريع الأوقاف النشطة';

  @override
  String get impactAllProjectsComingSoon => 'جميع المشاريع قريبًا';

  @override
  String get impactLiveImpactStream => 'بث الأثر المباشر';

  @override
  String get impactDistributedFunds => 'الأموال الموزعة';

  @override
  String impactEtbAmount(String amount) {
    return '$amount بر إثيوبي';
  }

  @override
  String get impactLivesTouched => 'الأرواح المستفيدة';

  @override
  String get impactActiveProjects => 'المشاريع النشطة';

  @override
  String get impactTapRegionHint => 'اضغط على منطقة لعرض الأثر المحلي';

  @override
  String impactRegionImpactComingSoon(String region) {
    return 'أثر $region قريبًا';
  }

  @override
  String impactStoryComingSoon(String name) {
    return 'قصة $name قريبًا';
  }

  @override
  String impactProjectDetailsComingSoon(String title) {
    return 'تفاصيل $title قريبًا';
  }

  @override
  String impactPercentFunded(String percent) {
    return 'تم تمويل $percent%';
  }

  @override
  String impactEtbLeft(String amount) {
    return 'متبقي $amount بر إثيوبي';
  }

  @override
  String get impactSeeYourPersonalBaraka => 'اطلع على بركتك الشخصية';

  @override
  String get impactTrackStewardship => 'تتبع كل مساهمة من أمانتك.';

  @override
  String get impactViewMyHistory => 'عرض سجلي';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get onboardingTitleFaithAndPurpose => 'إيمان ذو غاية';

  @override
  String get onboardingSubtitleFaithAndPurpose =>
      'مرحبًا بك في منصة موثوقة لإدارة الزكاة والأوقاف.';

  @override
  String get onboardingTitleTransparentGiving => 'عطاء شفاف';

  @override
  String get onboardingSubtitleTransparentGiving =>
      'تابع كيف تتحول مساهماتك إلى أثر حقيقي في المجتمعات.';

  @override
  String get onboardingTitleEasyPayments => 'مدفوعات سهلة وسريعة';

  @override
  String get onboardingSubtitleEasyPayments =>
      'ادفع زكاتك بسرعة عبر تجربة آمنة وسلسة على الجوال.';

  @override
  String get onboardingTitleCompassionInAction => 'رحمة تتحول إلى عمل';

  @override
  String get onboardingSubtitleCompassionInAction =>
      'ادعم المستفيدين والمشاريع بوضوح وثقة وبركة.';
}
