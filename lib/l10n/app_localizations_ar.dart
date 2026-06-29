// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'هيئة الزكاة والأوقاف';

  @override
  String get splashSlogan => 'في سبيل الله لخدمة الإنسانية';

  @override
  String get splashWaqfByLabel => 'الوقف به';

  @override
  String get splashWaqfByTitle => 'Coop Bank Alhuda';

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
  String get urgentBeneficiaryNeeds => 'الحالات العاجلة';

  @override
  String get viewAll => 'عرض الكل →';

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
  String get payZakatCause => 'أعطِ الزكاة';

  @override
  String get zakatAlFitr => 'زكاة الفطر';

  @override
  String get zakatDueDays => 'الموعد بعد حوالي 22 يوماً.';

  @override
  String get setReminder => 'ضبط تذكير';

  @override
  String get needQuickWayGive => 'عطاء سريع';

  @override
  String get supportCommunityNeeds => 'ادعم احتياجات المجتمع فوراً بالصدقة.';

  @override
  String get donateSadaqah => 'تبرع بصدقة';

  @override
  String get aboutCommission => 'هيئة الزكاة والأوقاف الإثيوبية';

  @override
  String get aboutCommissionBody =>
      'تنسيق جمع الزكاة وتطوير الأوقاف لرفع المجتمعات الهشة عبر برامج شفافة ومتوافقة مع الشريعة في جميع أنحاء إثيوبيا.';

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
  String get calcAppBarTitle => 'حاسبة الزكاة';

  @override
  String get calcPayYourZakat => 'دفع الزكاة الخاصة بك';

  @override
  String get calcTabWealth => 'ثروة';

  @override
  String get calcTabLivestock => 'الماشية';

  @override
  String get calcTabCrops => 'المحاصيل';

  @override
  String get calcStep1NisabTitle => 'الخطوة 1: عتبة النصاب';

  @override
  String get calcStep1NisabBody =>
      'تجب الزكاة إذا تجاوز صافي ثروتك الحد الأدنى. يعتمد النصاب على 85 جرامًا من سعر الذهب عيار 24 قيراطًا.';

  @override
  String calcNisabGoldFormula(String grams, String price, String total) {
    return '$grams × $price = $total';
  }

  @override
  String calcNisabThresholdBanner(String amount) {
    return 'عتبة النصاب (سعر المنصة، ما يعادل 85 جرامًا من الذهب): $amount';
  }

  @override
  String get calcUsdEtb => 'USD/ETB';

  @override
  String get calcFxLive => 'باستخدام سعر الصرف المباشر';

  @override
  String get calcFxCache => 'باستخدام سعر الصرف المخزن مؤقتا';

  @override
  String get calcFxFallback => 'باستخدام سعر الصرف الاحتياطي';

  @override
  String get calcTimestampUnavailable => 'الطابع الزمني غير متاح';

  @override
  String get calcStep1LivestockTitle =>
      'الخطوة 1: طريقة مقياس الثروة الحيوانية';

  @override
  String get calcStep1LivestockBody =>
      'يتم احتساب زكاة الماشية بمقاييس عدد الرؤوس المادية (وليس النسبة المئوية من القيمة).';

  @override
  String get calcStep1LivestockNisabNote =>
      'عتبات النصاب: الأغنام/الماعز 40، الماشية 30، الإبل 5. تستخدم الماشية مجموعات 30/40؛ تتبع الجمال نطاقات الطبقة.';

  @override
  String calcAdvisoryPrefix(String text) {
    return 'استشاري: $text';
  }

  @override
  String get calcArabicTermDefinitionsTitle => 'تعريفات المصطلحات العربية';

  @override
  String get calcArabicDefTabi => 'عجل عمره عام واحد';

  @override
  String get calcArabicDefMusinnah => 'بقرة عمرها سنتين';

  @override
  String get calcArabicDefBintMakhad => 'ناقة عمرها عام واحد';

  @override
  String get calcArabicDefBintLabun => 'ناقة تبلغ من العمر عامين';

  @override
  String get calcArabicDefHiqqah => 'ناقة عمرها ثلاث سنوات';

  @override
  String get calcArabicDefJadhah => 'ناقة عمرها أربع سنوات';

  @override
  String get calcStep1CropTitle => 'الخطوة 1: حساب المحاصيل (العشر).';

  @override
  String get calcStep1CropBody =>
      'وتجب زكاة الزرع عند حصاده. النصاب 653 كيلوجرامًا. النسبة 10% (بعلي) أو 5% (مروي) أو مرجح للمختلط.';

  @override
  String calcCropLineThreshold(String kg, String relation) {
    return '$kg كجم $relation 653 كجم';
  }

  @override
  String calcCropLineIrrigation(String mode) {
    return 'وضع الري: $mode';
  }

  @override
  String calcCropLineEffectiveRate(String rate) {
    return 'المعدل الفعال: $rate%';
  }

  @override
  String calcCropLineFormula(String line) {
    return 'الصيغة: $line';
  }

  @override
  String get calcRelationGte => '≥';

  @override
  String get calcRelationLt => '<';

  @override
  String get calcOverviewNetWorthTitle => 'نظرة عامة على صافي القيمة';

  @override
  String get calcOverviewLivestockTitle => 'نظرة عامة على الثروة الحيوانية';

  @override
  String get calcOverviewCropTitle => 'نظرة عامة على المحاصيل';

  @override
  String get calcBadgeAboveNisab => 'فوق نصاب';

  @override
  String get calcBadgeBelowNisab => 'تحت نصاب';

  @override
  String get calcBadgeZakatDue => 'الزكاة المستحقة';

  @override
  String get calcBadgeNoDue => 'لا مستحق';

  @override
  String get calcZakatDueLabel => 'الزكاة المستحقة';

  @override
  String get calcLivestockDueLabel => 'مستحقات الثروة الحيوانية';

  @override
  String get calcCropZakatDueLabel => 'زكاة المحاصيل المستحقة';

  @override
  String calcAnimalsCount(int count) {
    return '$count الحيوانات';
  }

  @override
  String calcKgHarvest(String kg) {
    return '$kg كجم الحصاد';
  }

  @override
  String get calcLivestockTermsFootnote =>
      'مصطلحات مثل التابع، والمصنعة، وبنت مخاض، وبنت لبون، والحقة، والجده موضحة أدناه في تفاصيل الثروة الحيوانية.';

  @override
  String get calcStep2EnterAssets => 'الخطوة 2: أدخل الأصول الخاصة بك';

  @override
  String get calcStep2EnterAssetsBody => 'أدخل قيمة الأصول الخاصة بك في ETB';

  @override
  String get calcCashBankSavings => 'الادخار النقدي والبنوك';

  @override
  String get calcCashOnHand => 'النقد في متناول اليد';

  @override
  String get calcBankBalance => 'رصيد البنك';

  @override
  String get calcMobileWallet => 'المحفظة المتنقلة';

  @override
  String get calcBusinessAssets => 'أصول الأعمال';

  @override
  String get calcFieldDescription => 'وصف';

  @override
  String get calcFieldType => 'يكتب';

  @override
  String get calcAmountEtb => 'المبلغ (درهم إثيوبي)';

  @override
  String get calcAddBusinessAsset => 'إضافة الأصول التجارية';

  @override
  String get calcGoldSilver => 'الذهب والفضة';

  @override
  String get calcGoldGrams => 'الذهب (جرام)';

  @override
  String get calcGoldKarat => 'قيراط الذهب';

  @override
  String get calcSilverGrams => 'الفضة (جرام)';

  @override
  String get calcLiabilities => 'الإلتزامات';

  @override
  String get calcAddLiability => 'إضافة المسؤولية';

  @override
  String get calcAssetInventory => 'جرد';

  @override
  String get calcAssetReceivable => 'مستحق';

  @override
  String get calcAssetOther => 'آخر';

  @override
  String get calcLiabilityShortTermDebt => 'الديون قصيرة الأجل';

  @override
  String get calcLiabilityPayable => 'مستحق الدفع';

  @override
  String get calcLiabilityOther => 'آخر';

  @override
  String get calcLivestockSheepGoats => 'الأغنام / الماعز';

  @override
  String get calcLivestockCattle => 'ماشية';

  @override
  String get calcLivestockCamels => 'الجمال';

  @override
  String get calcPastureFedTitle => 'تتغذى على المراعي معظم أيام السنة';

  @override
  String get calcPastureFedSubtitle => 'استشارية فقط؛ لا يمنع الحساب';

  @override
  String get calcHawlTitle => 'أكملت سنة قمرية واحدة (الحول)';

  @override
  String get calcHawlSubtitle => 'استشارية فقط؛ لا يمنع الحساب';

  @override
  String get calcWorkAnimalsTitle => 'تستخدم للعمل (الحراثة / النقل)';

  @override
  String get calcWorkAnimalsSubtitle => 'استشارية فقط؛ لا يمنع الحساب';

  @override
  String get calcLivestockSummaryHeading => 'ملخص الثروة الحيوانية';

  @override
  String get calcCropNisabHeading => 'النصاب والمحصول الواجب';

  @override
  String calcEffectiveCropRateLine(String percent) {
    return 'معدل الاقتصاص الفعال: $percent%';
  }

  @override
  String calcCropZakatDueKgLine(String kg) {
    return 'زكاة الزرع الواجبة: $kg كيلو';
  }

  @override
  String get calcHowCropZakatWorksTitle => 'كيفية عمل زكاة المحاصيل';

  @override
  String get calcHowCropZakatWorksBody =>
      'النصاب : 653 كيلو جرام . المعدلات: البعلية 10%، المروية 5%، المختلطة = التقسيم المرجح. تجب الزكاة عند الحصاد (لا حول سنوي للمحاصيل).';

  @override
  String get calcHowCropZakatNote =>
      'ملحوظة: يطبق التطبيق هذه القواعد على نطاق واسع من أجل البساطة. تختلف المواقف العلمية على نطاق نوع المحاصيل وخصومات النفقات؛ استشارة العلماء المؤهلين لحالات محددة.';

  @override
  String get calcWealthNisabHeading => 'النصاب والمال والزكاة';

  @override
  String calcWealthNisabLine(String nisab) {
    return 'عتبة النصاب: $nisab';
  }

  @override
  String calcWealthZakatDueLine(String due) {
    return 'زكاة الثروة المستحقة (مبلغ أقل على البطاقة): $due';
  }

  @override
  String get calcHowWealthZakatWorksTitle => 'كيفية حساب زكاة الثروة';

  @override
  String calcHowWealthZakatWorksBody(int grams, int silverRate) {
    return 'نضيف النقد في الصندوق، والأرصدة المصرفية، ومحافظ الهاتف المحمول، والأصول التجارية، وقيمة الذهب والفضة. النصاب هو $grams جرام من الذهب بسعر 24 ألف جرام في التطبيق. يتم تقييم الذهب الذي تمتلكه باستخدام سعر التطبيق للقيراط الذي تختاره. تستخدم الفضة مرجعًا ثابتًا قدره $silverRate ETB لكل جرام. يتم طرح الالتزامات التي تدخلها للحصول على صافي الثروة. إذا كان صافي الثروة يساوي النصاب أو يزيد عليه، فإن الزكاة الواجبة هي 2.5% من صافي الثروة.';
  }

  @override
  String get calcHowWealthZakatNote =>
      'ملاحظة: اختلف العلماء في الأصول التي تجب فيها الزكاة، وفي كيفية خصم الديون من الثروة، ومتى يتم الحول، وغير ذلك من التفاصيل. هذه الشاشة عبارة عن تقدير تعليمي، قم بتأكيد حالتك مع العلماء المؤهلين.';

  @override
  String get calcWealthBreakdownTitle => 'كيف يتم حساب المبالغ المذكورة أعلاه';

  @override
  String calcWealthTransLiquidsLine(
    String cash,
    String bank,
    String mobile,
    String subtotal,
  ) {
    return 'نقدًا + بنك + جوال: $cash + $bank + $mobile = $subtotal';
  }

  @override
  String calcWealthTransBusinessLine(String business) {
    return 'أصول النشاط التجاري (مجموع الصفوف): $business';
  }

  @override
  String calcWealthTransRollupLine(
    String liquids,
    String business,
    String gold,
    String silver,
    String total,
  ) {
    return 'إجمالي الأصول: $liquids + $business + $gold + $silver = $total';
  }

  @override
  String calcWealthTransNisabLine(String grams, String price, String nisab) {
    return 'النصاب: $grams جم × 24 ك ($price/جم) = $nisab';
  }

  @override
  String calcWealthTransGoldLine(
    String grams,
    String karat,
    String price,
    String value,
  ) {
    return 'الذهب: $grams جم × $karat ($price/جم) = $value';
  }

  @override
  String calcWealthTransSilverLine(String grams, String rate, String value) {
    return 'الفضة: $grams جم × $rate ETB/g = $value';
  }

  @override
  String calcWealthTransNetLine(String liabilities, String net) {
    return 'صافي الثروة (مبلغ كبير على البطاقة): إجمالي الأصول − الخصوم ($liabilities) = $net';
  }

  @override
  String calcWealthTransDueAbove(String net, String due, String nisab) {
    return 'لأن $net يبلغ النصاب أو يزيد عليه ($nisab)، فإن الزكاة الواجبة = $net × 2.5% = $due.';
  }

  @override
  String calcWealthTransDueBelow(String net, String nisab, String due) {
    return 'لأن $net أقل من النصاب ($nisab)، فإن زكاة المال الواجبة = $due.';
  }

  @override
  String get calcCropWeightKg => 'وزن المحصول (كجم)';

  @override
  String get calcCropModeRainFed => 'البعلية';

  @override
  String get calcCropModeIrrigated => 'مروية';

  @override
  String get calcCropModeMixed => 'مختلط';

  @override
  String get calcRainFedSharePct => 'نسبة الأمطار البعلية %';

  @override
  String get calcIrrigatedSharePct => 'الحصة المروية %';

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
  String get calcMethodologyPlaceholder => 'عنصر نائب لمحتوى منهجية الزكاة.';

  @override
  String get calcPayBlockedWealth =>
      'لا توجد زكاة على الثروة (أقل من النصاب أو صفر مكتسب). ضبط المدخلات الخاصة بك.';

  @override
  String get calcPayBlockedLivestock =>
      'لا تجب زكاة الماشية على أعدادك الحالية.';

  @override
  String get calcPayBlockedCrops =>
      'لم تجب زكاة المحصول بعد (أقل من نصاب الحصاد أو صفر كيلو).';

  @override
  String calcCertCropDueLine(String kg) {
    return 'زكاة الزرع الواجبة: $kg كيلو';
  }

  @override
  String get calcBulletSeparator => ' • ';

  @override
  String calcLsSheepGoats(int count) {
    return 'الأغنام / الماعز: $count الأغنام';
  }

  @override
  String calcLsCattle(int tabi, int musinnah) {
    return 'الماشية: $tabi تابعي + $musinnah مسينة';
  }

  @override
  String calcLsCamels(String description) {
    return 'الجمال: $description';
  }

  @override
  String get calcLsNone => 'لا يوجد ماشية مستحقة بموجب التهم الحالية';

  @override
  String calcTransSheep(int head, int due) {
    return 'عتبة الأغنام/الماعز: $head >= 40 => بسبب $due الأغنام.';
  }

  @override
  String calcTransCattle(int head, int tabi, int musinnah) {
    return 'عتبة الماشية: $head >= 30 => بسبب $tabi تابع، $musinnah مسينة (مجموعة 30/40).';
  }

  @override
  String calcTransCamel(int head, String due) {
    return 'عتبة الجمل: $head >= 5 => بسبب $due.';
  }

  @override
  String calcTransAdvisoryLine(String text) {
    return 'استشاري: $text';
  }

  @override
  String get calcAdvNotPasture =>
      'لا يتغذى على المراعي معظم أيام السنة: تحقق من المعاملة التجارية / التجارية مع العلماء.';

  @override
  String get calcAdvHawl =>
      'لم يكتمل الحول: يشترط كثير من العلماء سنة قمرية واحدة لزكاة الماشية.';

  @override
  String get calcAdvWork => 'عادة ما تُعفى حيوانات العمل من زكاة الماشية.';

  @override
  String calcCropTransBelow(String kg, String nisab) {
    return 'حصاد $kgكجم أقل من النصاب ($nisab كجم)، فلا تجب فيه الزكاة.';
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
    return 'الري المختلط: المطري $rain%، المروي $irrig%. المعدل الفعال = $rate%. الصيغة: $kg × $rate2% = ${due}kg.';
  }

  @override
  String calcCropTransRainFed(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'معدل البعلية $rate%. الصيغة: $kg × $rate2% = ${due}kg.';
  }

  @override
  String calcCropTransIrrigated(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'معدل الري $rate%. الصيغة: $kg × $rate2% = ${due}kg.';
  }

  @override
  String get calcCamelNoDue => 'لا مستحق';

  @override
  String calcCamelSheepN(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خروف',
      one: '1 خروف',
    );
    return '$_temp0';
  }

  @override
  String get calcCamel1BintMakhad => '1 بنت مخاض';

  @override
  String get calcCamel1BintLabun => '1 بنت لبن';

  @override
  String get calcCamel1Hiqqah => '1 حقة';

  @override
  String get calcCamel1Jadhah => '1 جده';

  @override
  String get calcCamel2BintLabun => '2 بنت لبن';

  @override
  String get calcCamel2Hiqqah => '2 حقة';

  @override
  String calcCamelCombo(int hiqqah, int bintLabun) {
    return '$hiqqah حاقة + $bintLabun بنت لبون';
  }

  @override
  String calcCamelApproxBintLabun(int count) {
    return '$count بنت لبون (تحرير وسرد تقريبي)';
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
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'استخدم رقم هاتفك المسجل وكلمة المرور';

  @override
  String get loginPhoneLabel => 'رقم التليفون';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get loginPhoneRequired => 'أدخل رقم هاتفك';

  @override
  String get loginPhoneInvalid =>
      'أدخل رقم هاتف محمول صالحًا مكونًا من 9 أرقام (على سبيل المثال 923974838)';

  @override
  String get loginSecureNote => 'تسجيل دخولك مشفر وآمن';

  @override
  String get loginPasswordRequired => 'أدخل كلمة المرور الخاصة بك';

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
  String get onboardingTitleTransparentGiving => 'حاسبة الزكاة';

  @override
  String get onboardingSubtitleTransparentGiving =>
      'احسب زكاتك فورًا في الأموال والأنعام والزروع بإرشادات واضحة.';

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

  @override
  String get donationCurrencySheetTitle => 'كيف تريد أن تعطي؟';

  @override
  String get donationCurrencySheetSubtitle =>
      'اختر الدفع ETB المحلي أو الدفع بالبطاقة الدولية.';

  @override
  String get donationLocalPaymentTitle => 'الدفع المحلي (ETB)';

  @override
  String get donationLocalPaymentSubtitle =>
      'Telebirr وCBE Birr وM-Pesa والبوابات الإثيوبية الأخرى.';

  @override
  String get donationInternationalPaymentTitle => 'الدفع الدولي';

  @override
  String get donationInternationalPaymentSubtitle =>
      'ادفع من أي مكان باستخدام بطاقتك وعنوان إرسال الفواتير.';

  @override
  String get donationInternationalTitle => 'صدقة عالمية';

  @override
  String get donationInternationalSubtitle =>
      'دعم المجتمعات من أي مكان في العالم.';

  @override
  String get donationAmountLabel => 'مبلغ التبرع';

  @override
  String get donationAmountHint => '0.00';

  @override
  String get donationAmountHelper => 'يتم تسوية المبلغ بالبر الإثيوبي (ETB).';

  @override
  String get donationAnonymousLabel => 'إعطاء مجهول';

  @override
  String get donationAnonymousSubtitle => 'لن يتم عرض اسمك للعامة.';

  @override
  String get donationDonorSectionTitle => 'التفاصيل الخاصة بك';

  @override
  String get donationFullNameLabel => 'الاسم الكامل';

  @override
  String get donationPhoneLabel => 'هاتف';

  @override
  String get donationEmailLabel => 'بريد إلكتروني';

  @override
  String get donationBillingSectionTitle => 'عنوان إرسال الفواتير';

  @override
  String get donationAddress1Label => 'العنوان سطر 1';

  @override
  String get donationAddress2Label => 'سطر العنوان 2 (اختياري)';

  @override
  String get donationCountryLabel => 'دولة';

  @override
  String get donationCountryOther => 'اسم البلد';

  @override
  String get donationAdminAreaLabel => 'الولاية/المقاطعة';

  @override
  String get donationLocalityLabel => 'مدينة';

  @override
  String get donationPostalCodeLabel => 'رمز بريدي';

  @override
  String get donationContinueToPayment => 'الاستمرار في الدفع';

  @override
  String get donationSubmitting => 'يعالج…';

  @override
  String get donationSuccess => 'شكرا لصدقتك.';

  @override
  String get donationValidationPhone =>
      'أدخل رقم هاتف صالحًا بالتنسيق الدولي (على سبيل المثال: +15551234567).';

  @override
  String get donationPaymentWebViewTitle => 'استكمال الدفع';

  @override
  String get donationSelectCountry => 'اختر البلد';

  @override
  String get donationSearchCountry => 'دول البحث';

  @override
  String get donationSelectState => 'اختر الولاية/المقاطعة';

  @override
  String get donationSearchState => 'البحث بالاسم أو الاختصار';

  @override
  String get donationNoMatchesFound => 'لم يتم العثور على أي تطابقات';

  @override
  String get changeAppModeTooltip => 'تغيير الوضع';

  @override
  String get switchedToAwqafMode => 'تحولت إلى وضع الأوقاف';

  @override
  String get switchToAwqaf => 'التحول إلى الأوقاف';

  @override
  String get switchedToZakatMode => 'تحولت إلى وضع الزكاة';

  @override
  String get switchToZakat => 'التحول إلى الزكاة';

  @override
  String get loginForgotPassword => 'هل نسيت كلمة السر؟';

  @override
  String get loginForgotPasswordComingSoon => 'نسيت كلمة المرور قريبا';

  @override
  String get loginNewToBaraka => 'New to Baraka? ';

  @override
  String get loginCreateAccount => 'إنشاء حساب';

  @override
  String get loginCreateAccountComingSoon => 'إنشاء حساب قريبا';

  @override
  String get profileDisbursementIntro =>
      'اختر المكان الذي تريد تلقي المدفوعات فيه.';

  @override
  String get profileCoopAccountLabel => 'رقم الحساب البنكي التعاوني';

  @override
  String get profileCoopAccountHint => 'أدخل رقم حسابك';

  @override
  String get profileCoopAccountRequired =>
      'الرجاء إدخال رقم حسابك في Coop Bank.';

  @override
  String get profileSaveAccount => 'حفظ الحساب';

  @override
  String get faydaIdentityVerification => 'التحقق من الهوية';

  @override
  String get commonBack => 'خلف';

  @override
  String get commonContinue => 'يكمل';

  @override
  String get commonFinish => 'ينهي';

  @override
  String get commonTakePhoto => 'التقط صورة';

  @override
  String get commonChooseGallery => 'اختر من المعرض';

  @override
  String get commonChooseFile => 'اختر ملف';

  @override
  String get regTitle => 'تسجيل المستفيد';

  @override
  String get regMethodFastTrack => 'المسار السريع مع فايدة';

  @override
  String get regMethodManual => 'التسجيل اليدوي';

  @override
  String get regMethodInstitution => 'تسجيل المؤسسة';

  @override
  String get regMethodFastTrackDesc =>
      'تحقق بشكل آمن من الهوية باستخدام بطاقة الهوية الوطنية واستمر في دقائق.';

  @override
  String get regMethodManualDesc =>
      'شارك معلوماتك والتفاصيل الداعمة لمراجعة موثوقة.';

  @override
  String get regMethodInstitutionDesc =>
      'سجل مؤسستك وأرسل مستندات الامتثال المطلوبة.';

  @override
  String get regSecureIdentityTitle => 'التحقق الآمن من الهوية';

  @override
  String get regChooseMethodSubtitle =>
      'اختر طريقة التسجيل المفضلة لديك لتبدأ رحلتك.';

  @override
  String get regFastTrackFaydaTitle => 'المسار السريع بالهوية الوطنية (فايضة)';

  @override
  String get regFastTrackFaydaSubtitle =>
      'قم بالمصادقة باستخدام الهوية الرقمية الوطنية الخاصة بك.';

  @override
  String get regManualTitle => 'التسجيل اليدوي';

  @override
  String get regManualSubtitle => 'قم بتحميل الوثائق الداعمة للمراجعة.';

  @override
  String get regInstitutionCardTitle => 'سجل كمؤسسة';

  @override
  String get regInstitutionCardSubtitle =>
      'شركة أو منظمة غير حكومية أو تعاونية أو جهة حكومية.';

  @override
  String get regRegistrationCodeLabel => 'رمز التسجيل';

  @override
  String get regRegistrationCodeHint => 'EZW-A1B2-C3D4';

  @override
  String get regEncryptedPrivate => 'مشفرة وخاصة';

  @override
  String get regEncryptedPrivateBody =>
      'يتم تأمين بياناتك ومعالجتها بما يتماشى مع معايير الخصوصية.';

  @override
  String get regVerificationInterrupted => 'تمت مقاطعة عملية التحقق';

  @override
  String get regReopenVerification => 'إعادة فتح التحقق';

  @override
  String get regRetryListening => 'أعد محاولة الاستماع';

  @override
  String get regCameraPermissionError =>
      'لا يمكن فتح الكاميرا/المعرض. يرجى التحقق من الأذونات.';

  @override
  String get regSelectBirthdate => 'اختر تاريخ الميلاد';

  @override
  String get regManualIdentityTitle => 'التسجيل اليدوي للهوية';

  @override
  String get regFirstName => 'الاسم الأول';

  @override
  String get regLastName => 'اسم العائلة';

  @override
  String get regGrandfatherName => 'اسم الجد';

  @override
  String get regPhoneNumber => 'رقم التليفون';

  @override
  String get regPhoneHint => '+251911223344 or 0911223344';

  @override
  String get regEmail => 'بريد إلكتروني';

  @override
  String get regGender => 'جنس';

  @override
  String get regMale => 'ذكر';

  @override
  String get regFemale => 'أنثى';

  @override
  String get regBeneficiaryCategory => 'فئة المستفيد';

  @override
  String get regNotes => 'ملحوظات';

  @override
  String get regNotesHint => 'على سبيل المثال طالب دعم الزكاة';

  @override
  String get regUploadProfilePicture => 'تحميل صورة الملف الشخصي';

  @override
  String get regVerifyingFaydaBanner =>
      'التحقق مع فايدة... أكمل التحقق في المتصفح عند فتحه.';

  @override
  String get regNeedsAssessment => 'تقييم الاحتياجات';

  @override
  String get regSituationLabel => 'صف وضعك الحالي';

  @override
  String get regSituationHint =>
      'اشرح المشقة والمعالين والاحتياجات العاجلة ...';

  @override
  String get regUploadProof => 'تحميل إثبات';

  @override
  String get regDisbursementSetup => 'إعداد الصرف';

  @override
  String get regTelebirrTitle => 'محفظة تيليبير';

  @override
  String get regTelebirrSubtitle => 'تحويل فوري للأموال عبر الهاتف المحمول';

  @override
  String get regMpesaTitle => 'م-بيسا';

  @override
  String get regMpesaSubtitle => 'شبكة آمنة للدفع عبر الهاتف المحمول';

  @override
  String get regCoopbankTitle => 'حساب كوببانك';

  @override
  String get regCoopbankSubtitle => 'الإيداع البنكي المباشر';

  @override
  String get regAccountOrMobile => 'رقم الحساب أو الجوال';

  @override
  String get regFullLegalName => 'الاسم القانوني الكامل';

  @override
  String get regAgreementTitle => 'الاتفاقية والامتثال للشريعة';

  @override
  String get regAgreementBody =>
      'أقر بأن المعلومات صحيحة وسأستخدم المساعدة وفقًا للسياسة.';

  @override
  String get regInstitutionRegistration => 'تسجيل المؤسسة';

  @override
  String get regInstitutionType => 'نوع المؤسسة';

  @override
  String get regLegalName => 'الاسم القانوني';

  @override
  String get regTradingName => 'اسم التداول';

  @override
  String get regTradeRegistrationNumber => 'رقم السجل التجاري';

  @override
  String get regTin => 'رقم التعريف الضريبي (TIN)';

  @override
  String get regVatOptional => 'رقم التسجيل في ضريبة القيمة المضافة (اختياري)';

  @override
  String get regRegion => 'منطقة';

  @override
  String get regCity => 'مدينة';

  @override
  String get regAddress => 'عنوان';

  @override
  String get regNotesOptional => 'ملاحظات (اختياري)';

  @override
  String get regAuthorityDocTitle => 'وثيقة سلطة التصرف المطلوبة';

  @override
  String get regAuthorityDocBody =>
      'قم بالتمكين في حالة إرسال شخص آخر غير الموقع المسجل.';

  @override
  String get regFilePickError =>
      'لا يمكن اختيار الملف. يرجى التحقق من الأذونات.';

  @override
  String get regUploadKycTitle => 'قم بتحميل مستندات KYC';

  @override
  String get regUploadKycBody =>
      'قم بتحميل كل وثيقة مطلوبة. يمكنك الانتهاء بمجرد تحميل جميع المستندات المطلوبة.';

  @override
  String regReference(Object id) {
    return 'المرجع: $id';
  }

  @override
  String get regNoDocumentsRequired => 'لا توجد وثائق مطلوبة في هذا الوقت.';

  @override
  String get regRequired => 'مطلوب';

  @override
  String get regOptional => 'خياري';

  @override
  String regSelectedFile(Object name) {
    return 'تم التحديد: $name';
  }

  @override
  String get regUploaded => 'تم الرفع';

  @override
  String get regUpload => 'رفع';

  @override
  String get regCreatePasswordTitle => 'قم بإنشاء كلمة المرور الخاصة بك';

  @override
  String get regCreatePasswordBody =>
      'اختر كلمة مرور آمنة لحسابك. سوف تستخدمه لتسجيل الدخول بعد التسجيل.';

  @override
  String get regPassword => 'كلمة المرور';

  @override
  String get regConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get regPasswordRules =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل وتتضمن أحرفًا كبيرة وصغيرة ورقمًا وحرفًا خاصًا.';

  @override
  String get regPasswordSuccess =>
      'تم تعيين كلمة المرور بنجاح. مرحبا بكم في مركز المجلس الرقمي.';

  @override
  String regInstitutionComplete(Object id) {
    return 'اكتمل تسجيل المؤسسة. المرجع: $id';
  }

  @override
  String get regInstitutionCompleteGeneric => 'اكتمل تسجيل المؤسسة.';

  @override
  String get regCompleteLocal =>
      'اكتمل التسجيل. يتم حفظ الاحتياجات وتفاصيل الصرف محليًا.';

  @override
  String get regContinueWithFayda => 'تواصل مع فايدة';

  @override
  String get regVerifyingFayda => 'التحقق مع فايدة…';

  @override
  String get regSubmitContinue => 'إرسال ومتابعة';

  @override
  String get regSetPasswordContinue => 'تعيين كلمة المرور والمتابعة';

  @override
  String get regSetPasswordFinish => 'تعيين كلمة المرور والانتهاء';

  @override
  String get navAwqaf => 'Awqaf';
}
