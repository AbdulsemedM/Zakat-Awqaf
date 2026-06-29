// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oromo (`om`).
class AppLocalizationsOm extends AppLocalizations {
  AppLocalizationsOm([String locale = 'om']) : super(locale);

  @override
  String get appTitle => 'Komishinii Zakaa fi Awqaaf';

  @override
  String get splashSlogan => 'Rabbiif jecha, tajaajila dhala namaatiif';

  @override
  String get splashWaqfByLabel => 'A Waaqeffannaa by';

  @override
  String get splashWaqfByTitle => 'Coop Bank Alhuda';

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
  String get urgentBeneficiaryNeeds => 'Sababa Ariifachiisaa';

  @override
  String get viewAll => 'Hunda Ilaali →';

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
  String get payZakatCause => 'Zakaa Kenni';

  @override
  String get zakatAlFitr => 'Zakaa Al-Fitr';

  @override
  String get zakatDueDays => 'Guyyoota 22 keessatti ni ga\'a jechuun tilmaama.';

  @override
  String get setReminder => 'Yaadachiisa kaa\'i';

  @override
  String get needQuickWayGive => 'Kenna Saffisaa';

  @override
  String get supportCommunityNeeds =>
      'Sadaqaan fedhii hawaasaa yeroo gabaabaa keessatti deeggaru.';

  @override
  String get donateSadaqah => 'Sadaqaa Kenni';

  @override
  String get aboutCommission => 'Komishinii Zakaa fi Awqaaf Itoophiyaa';

  @override
  String get aboutCommissionBody =>
      'Walitti qabama zakaa fi misooma awqaaf qindeessuun hawaasa miidhamoo ta\'an iftoominaan fi sagantaa shari\'aa wajjin walsimuun Itoophiyaa guutuu ni deeggarra.';

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
  String get calcAppBarTitle => 'Shallaggii Zakaa';

  @override
  String get calcPayYourZakat => 'Zakaa Keessan Bafadhaa';

  @override
  String get calcTabWealth => 'Qabeenya';

  @override
  String get calcTabLivestock => 'Beeylada';

  @override
  String get calcTabCrops => 'Midhaan';

  @override
  String get calcStep1NisabTitle => 'Tarkaanfii 1: Ulaagaa Nisab';

  @override
  String get calcStep1NisabBody =>
      'Zakaan kan kaffalamu yoo qabeenyi qulqulluun kee ulaagaa irra darbeedha. Nisab gatii warqee 85g platform 24k irratti hundaa\'a.';

  @override
  String calcNisabGoldFormula(String grams, String price, String total) {
    return '$grams × $price = $total .';
  }

  @override
  String calcNisabThresholdBanner(String amount) {
    return 'Ulaagaa Nisab (saffisa waltajjii, warqee 85g walqixa): $amount .';
  }

  @override
  String get calcUsdEtb => 'USD/ETB';

  @override
  String get calcFxLive => 'Sadarkaa jijjiirraa kallattiin fayyadamuu';

  @override
  String get calcFxCache => 'Sadarkaa jijjiirraa kaached fayyadamuu';

  @override
  String get calcFxFallback => 'Sadarkaa jijjiirraa fallback fayyadamuu';

  @override
  String get calcTimestampUnavailable => 'chaappaan yeroo hin jiru';

  @override
  String get calcStep1LivestockTitle => 'Tarkaanfii 1: Mala iskeelii horii';

  @override
  String get calcStep1LivestockBody =>
      'Zakaan beeyladaa kan shallagamu madaallii lakkoofsa mataa fiizikaalaatiin (% gatii miti).';

  @override
  String get calcStep1LivestockNisabNote =>
      'Ulaagaa Nisab: Hoolaa/Re’ee 40, Loon 30, Gaala 5. Loon walnyaatinsa 30/40 fayyadama; gaalli sadarkaa sadarkaa hordofu.';

  @override
  String calcAdvisoryPrefix(String text) {
    return 'Gorsaa: $text .';
  }

  @override
  String get calcArabicTermDefinitionsTitle => 'Hiika Jechoota Afaan Arabaa';

  @override
  String get calcArabicDefTabi => 're’ee waggaa tokkoo';

  @override
  String get calcArabicDefMusinnah => 're’ee waggaa lamaa';

  @override
  String get calcArabicDefBintMakhad => 'gaala dubaraa waggaa tokkoo';

  @override
  String get calcArabicDefBintLabun => 'gaala dubaraa waggaa lamaa';

  @override
  String get calcArabicDefHiqqah => 'gaala dubaraa waggaa sadii';

  @override
  String get calcArabicDefJadhah => 'gaala dubaraa waggaa afur';

  @override
  String get calcStep1CropTitle => 'Tarkaanfii 1: Shallaggii midhaanii (Ushr).';

  @override
  String get calcStep1CropBody =>
      'Zakaan midhaanii yeroo sassaabamuu qaba. Nisab 653kg dha. Saffisni %10 (roobaan kan sooramu), %5 (jallisii), ykn makaadhaaf ulfaataadha.';

  @override
  String calcCropLineThreshold(String kg, String relation) {
    return '$kg kg $relation 653 kg';
  }

  @override
  String calcCropLineIrrigation(String mode) {
    return 'Haala jallisii: $mode .';
  }

  @override
  String calcCropLineEffectiveRate(String rate) {
    return 'Sadarkaa bu\'a qabeessa: $rate%';
  }

  @override
  String calcCropLineFormula(String line) {
    return 'Foormulaa: $line .';
  }

  @override
  String get calcRelationGte => '≥';

  @override
  String get calcRelationLt => '<';

  @override
  String get calcOverviewNetWorthTitle => 'Haala Waliigalaa Qabeenya Qulqulluu';

  @override
  String get calcOverviewLivestockTitle => 'Haala Waliigalaa Beeyladaa';

  @override
  String get calcOverviewCropTitle => 'Haala Waliigalaa Midhaanii';

  @override
  String get calcBadgeAboveNisab => 'Nisab olitti';

  @override
  String get calcBadgeBelowNisab => 'Nisab gadiitti';

  @override
  String get calcBadgeZakatDue => 'Zakaa Duumee';

  @override
  String get calcBadgeNoDue => 'No Due';

  @override
  String get calcZakatDueLabel => 'Zakaa Duumee';

  @override
  String get calcLivestockDueLabel => 'Beeylada Due';

  @override
  String get calcCropZakatDueLabel => 'Midhaan Zakaa Guutuu';

  @override
  String calcAnimalsCount(int count) {
    return '$count bineensota';
  }

  @override
  String calcKgHarvest(String kg) {
    return '$kg kg sassaabbii';
  }

  @override
  String get calcLivestockTermsFootnote =>
      'Jechoonni akka tabi\', musinnah, bint makhad, bint labun, hiqqah, fi jadhah bal\'inaan Beeylada keessatti akka armaan gadiitti ibsamaniiru.';

  @override
  String get calcStep2EnterAssets =>
      'Tarkaanfii 2ffaa: Qabeenya Keessan Galchi';

  @override
  String get calcStep2EnterAssetsBody =>
      'Gatii qabeenya keetii ETB keessatti galchi';

  @override
  String get calcCashBankSavings => 'Qusannoo Maallaqaa fi Baankii';

  @override
  String get calcCashOnHand => 'Maallaqa Harkaa';

  @override
  String get calcBankBalance => 'Hafnaan Baankii';

  @override
  String get calcMobileWallet => 'Wallet Mobaayilaa';

  @override
  String get calcBusinessAssets => 'Qabeenya Daldalaa';

  @override
  String get calcFieldDescription => 'Ibsa';

  @override
  String get calcFieldType => 'Akaakuu';

  @override
  String get calcAmountEtb => 'Maallaqa (ETB) .';

  @override
  String get calcAddBusinessAsset => 'Qabeenya daldalaa dabaluu';

  @override
  String get calcGoldSilver => 'Warqee & Meetii';

  @override
  String get calcGoldGrams => 'Warqee (giraama) .';

  @override
  String get calcGoldKarat => 'Warqee Karat';

  @override
  String get calcSilverGrams => 'Meetii (giraama) .';

  @override
  String get calcLiabilities => 'Itti gaafatamummaa';

  @override
  String get calcAddLiability => 'Itti gaafatamummaa itti dabali';

  @override
  String get calcAssetInventory => 'Eeruu';

  @override
  String get calcAssetReceivable => 'Fudhatama kan qabu';

  @override
  String get calcAssetOther => 'Kan biraa';

  @override
  String get calcLiabilityShortTermDebt => 'Liqaa yeroo gabaabaa';

  @override
  String get calcLiabilityPayable => 'Kaffaltii kan qabu';

  @override
  String get calcLiabilityOther => 'Kan biraa';

  @override
  String get calcLivestockSheepGoats => 'Hoolaa / Re\'ee';

  @override
  String get calcLivestockCattle => 'Loon';

  @override
  String get calcLivestockCamels => 'Gaala';

  @override
  String get calcPastureFedTitle =>
      'Waggaa keessaa harka caalu dheedichaan kan sooramu';

  @override
  String get calcPastureFedSubtitle => 'Gorsa qofa; shallaggii hin ugguru';

  @override
  String get calcHawlTitle => 'Waggaa ji\'aa tokko xumure (hawl) .';

  @override
  String get calcHawlSubtitle => 'Gorsa qofa; shallaggii hin ugguru';

  @override
  String get calcWorkAnimalsTitle => 'Hojiif kan oolu (qottoo/geejjibaa) .';

  @override
  String get calcWorkAnimalsSubtitle => 'Gorsa qofa; shallaggii hin ugguru';

  @override
  String get calcLivestockSummaryHeading => 'Cuunfaa beeyladaa';

  @override
  String get calcCropNisabHeading => 'Nisab & midhaan irraa kan ka\'e';

  @override
  String calcEffectiveCropRateLine(String percent) {
    return 'Sadarkaa midhaan bu’a qabeessa: $percent% .';
  }

  @override
  String calcCropZakatDueKgLine(String kg) {
    return 'Zakaa midhaanii kaffalamuu qabu: $kg kg';
  }

  @override
  String get calcHowCropZakatWorksTitle =>
      'Zakaan midhaan akkamitti akka hojjetu';

  @override
  String get calcHowCropZakatWorksBody =>
      'Nisab: 653kg. Sadarkaa: roobaan kan nyaatame %10, kan jallisiin misoomu 5%, makaa = ulfaataa kan ta’e qoqqoodinsa. Zakaan yeroo sassaabamuu qaba (midhaniif hawl waggaa hin qabu).';

  @override
  String get calcHowCropZakatNote =>
      'Hubachiisa: App seera kana bal\'inaan hojiirra oolcha salphaa ta\'eef. Ejjennoo hayyootaa bal’ina gosa midhaanii fi hir’ina baasii irratti garaagarummaa qaba; dhimmoota adda ta’aniif hayyoota gahumsa qaban mariisisuu.';

  @override
  String get calcWealthNisabHeading => 'Nisab & qabeenya Zakaa';

  @override
  String calcWealthNisabLine(String nisab) {
    return 'Ulaagaa Nisab: $nisab .';
  }

  @override
  String calcWealthZakatDueLine(String due) {
    return 'Qabeenya Zakaa kaffalamuu qabu (kaardii irratti maallaqa xiqqaa): $due .';
  }

  @override
  String get calcHowWealthZakatWorksTitle =>
      'Akkamitti qabeenyi Zakaan shallagama';

  @override
  String calcHowWealthZakatWorksBody(int grams, int silverRate) {
    return 'Maallaqa harka jiru, hafnaan baankii, boorsaa moobaayilaa, qabeenya daldalaa, fi gatii warqee fi meetii itti daballa. Nisab warqee $grams g gatii app’n giraama tokkoof 24k ta’een. Warqeen ati qabdu kaaraatii filatteef saffisa appii fayyadamuun gatii kennama. Meetiin wabii dhaabbataa $silverRate ETB giraama tokkoof fayyadama. Dirqamni ati galchitu qabeenya qulqulluu argachuuf hir’ifama. Qabeenyi qulqulluun nisaab irratti yookiin isaa ol yoo ta’e, Zakaan kaffalamuu qabu qabeenya qulqulluu irraa %2.5 ta’a.';
  }

  @override
  String get calcHowWealthZakatNote =>
      'Hubachiisa: Hayyoonni qabeenyi kam akka zakaa ta’u, liqiin qabeenya akkamitti akka hir’isu, bara ji’aa (hawl) yoom akka raawwatamuu fi bal’ina biroo irratti garaagarummaa qabu. Iskiriiniin kun tilmaama barnootaati-haala kee hayyoota gahumsa qaban waliin mirkaneessi.';

  @override
  String get calcWealthBreakdownTitle =>
      'Akkaataa maallaqni armaan olii itti shallagamu';

  @override
  String calcWealthTransLiquidsLine(
    String cash,
    String bank,
    String mobile,
    String subtotal,
  ) {
    return 'Maallaqa + baankii + moobaayila: $cash + $bank + $mobile = $subtotal .';
  }

  @override
  String calcWealthTransBusinessLine(String business) {
    return 'Qabeenya daldalaa (walitti qabama tarreewwanii): $business .';
  }

  @override
  String calcWealthTransRollupLine(
    String liquids,
    String business,
    String gold,
    String silver,
    String total,
  ) {
    return 'Qabeenya waliigalaa: $liquids + $business + $gold + $silver = $total .';
  }

  @override
  String calcWealthTransNisabLine(String grams, String price, String nisab) {
    return 'Nisab: $grams g × 24k ($price/g) = $nisab .';
  }

  @override
  String calcWealthTransGoldLine(
    String grams,
    String karat,
    String price,
    String value,
  ) {
    return 'Warqee: $grams g × $karat ($price/g) = $value .';
  }

  @override
  String calcWealthTransSilverLine(String grams, String rate, String value) {
    return 'Meetii: $grams g × $rate ETB/g = $value .';
  }

  @override
  String calcWealthTransNetLine(String liabilities, String net) {
    return 'Qabeenya qulqulluu (maallaqa guddaa kaardii irratti): qabeenya waliigalaa − dirqama ($liabilities) = $net .';
  }

  @override
  String calcWealthTransDueAbove(String net, String due, String nisab) {
    return '$net nisab ($nisab) irratti ykn isaa ol waan ta\'eef, Zakaa kaffalamuu = $net × 2.5% = $due.';
  }

  @override
  String calcWealthTransDueBelow(String net, String nisab, String due) {
    return 'Sababni isaas $net nisaaba ($nisab) gadi waan ta\'eef, qabeenyi Zakaa kaffalamuu = $due.';
  }

  @override
  String get calcCropWeightKg => 'Ulfaatina Midhaanii (kg) .';

  @override
  String get calcCropModeRainFed => 'Roobaan kan sooramu';

  @override
  String get calcCropModeIrrigated => 'Jallisii';

  @override
  String get calcCropModeMixed => 'Walmakaa';

  @override
  String get calcRainFedSharePct => 'Qooda rooba soorame % .';

  @override
  String get calcIrrigatedSharePct => 'Qooda jallisii % .';

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
  String get calcMethodologyPlaceholder => 'Qabiyyee mala Zakaa iddoo.';

  @override
  String get calcPayBlockedWealth =>
      'Qabeenyi Zakaan hin kaffalamu (nisab gadi ykn zeeroo ETB kaffalamuu qabu). Galtee kee sirreessaa.';

  @override
  String get calcPayBlockedLivestock =>
      'Lakkoofsa ammaa keessaniif Zakaan beeyladaa tokkollee hin kaffalamu.';

  @override
  String get calcPayBlockedCrops =>
      'Zakaan midhaanii ammallee yeroon isaa hin geenye (nisab midhaan sassaabuu gadi ykn zeeroo kg yeroon isaa kaffalamuu qaba).';

  @override
  String calcCertCropDueLine(String kg) {
    return 'Zakaa midhaanii kaffalamuu qabu: $kg kg';
  }

  @override
  String get calcBulletSeparator => ' • ';

  @override
  String calcLsSheepGoats(int count) {
    return 'Hoolota/Re\'ee: $count hoolaa';
  }

  @override
  String calcLsCattle(int tabi, int musinnah) {
    return 'Loon: $tabi tabii\' + $musinnah musinnah';
  }

  @override
  String calcLsCamels(String description) {
    return 'Gaalota: $description .';
  }

  @override
  String get calcLsNone =>
      'Lakkoofsa amma jiruun beeylada kaffalamuu qabu hin jiru';

  @override
  String calcTransSheep(int head, int due) {
    return 'Ulaagaa Hoolotaa/Re\'ee: $head >= 40 => hoolaa $due yeroon isaa ga\'e.';
  }

  @override
  String calcTransCattle(int head, int tabi, int musinnah) {
    return 'Ulaagaa loon: $head >= 30 => sababa $tabi tabii\', $musinnah musinnah (walmakaa 30/40).';
  }

  @override
  String calcTransCamel(int head, String due) {
    return 'Ulaagaa gaala: $head >= 5 => sababa $due.';
  }

  @override
  String calcTransAdvisoryLine(String text) {
    return 'Gorsaa: $text .';
  }

  @override
  String get calcAdvNotPasture =>
      'Waggaa irra caalaan dheedichaa kan hin sooramne: hayyoota waliin wal’aansa daldalaa/daldalaa ilaali.';

  @override
  String get calcAdvHawl =>
      'Hawl hin xumuramne: hayyoonni baay’een zakaa beeyladaatiif waggaa ji’aa tokko barbaadu.';

  @override
  String get calcAdvWork =>
      'Bineensonni hojii akkaataa adda addaatiin zakaa beeyladaa irraa bilisa ta’u.';

  @override
  String calcCropTransBelow(String kg, String nisab) {
    return 'Sassaabni ${kg}kg Nisaaba ($nisab kg) gadi waan ta\'eef Zakaan midhaan kamiyyuu hin kaffalamu.';
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
    return 'Jallisii walmakaa: rooba $rain%, jallisii $irrig%. Sadarkaa bu\'a qabeessa = $rate%. Foormulaa: $kg × $rate2% = ${due}kg.';
  }

  @override
  String calcCropTransRainFed(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'Sadarkaan rooba sooramu $rate%. Foormulaa: $kg × $rate2% = ${due}kg.';
  }

  @override
  String calcCropTransIrrigated(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'Sadarkaa jallisii $rate%. Foormulaa: $kg × $rate2% = ${due}kg.';
  }

  @override
  String get calcCamelNoDue => 'Hin qabu';

  @override
  String calcCamelSheepN(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hoolaa',
      one: '1 hoolaa',
    );
    return '$_temp0';
  }

  @override
  String get calcCamel1BintMakhad => '1 bint makhad jedhamuun beekama';

  @override
  String get calcCamel1BintLabun => '1 bint labun jedhamuun beekama';

  @override
  String get calcCamel1Hiqqah => '1 hiqqaa';

  @override
  String get calcCamel1Jadhah => '1 jadhah';

  @override
  String get calcCamel2BintLabun => '2 bint labun jedhamuun beekama';

  @override
  String get calcCamel2Hiqqah => '2 hiqqaa';

  @override
  String calcCamelCombo(int hiqqah, int bintLabun) {
    return '$hiqqah hiqqah + $bintLabun bint labun';
  }

  @override
  String calcCamelApproxBintLabun(int count) {
    return '$count bint labun (tilmaamaan walnyaatinsa) .';
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
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Lakkoofsa bilbilaa fi jecha icciitii galmaa\'e fayyadamaa';

  @override
  String get loginPhoneLabel => 'Lakkoofsa bilbilaa';

  @override
  String get loginPasswordLabel => 'Jecha iccitii';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginPhoneRequired => 'Lakkoofsa bilbilaa keessan galchaa';

  @override
  String get loginPhoneInvalid =>
      'Lakkoofsa moobaayilaa dijiitii 9 sirrii ta\'e galchi (fkn 923974838)';

  @override
  String get loginSecureNote => 'Galmeen kee icciitii fi nageenya qaba';

  @override
  String get loginPasswordRequired => 'Jecha icciitii keessan galchaa';

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

  @override
  String get donationCurrencySheetTitle => 'Akkamitti kennuu barbaadda?';

  @override
  String get donationCurrencySheetSubtitle =>
      'Kaffaltii ETB biyya keessaa ykn kaffaltii kaardii idil-addunyaa filadhu.';

  @override
  String get donationLocalPaymentTitle => 'Kaffaltii biyya keessaa (ETB) .';

  @override
  String get donationLocalPaymentSubtitle =>
      'Telebirr, CBE Birr, M-Pesa, fi karra Itoophiyaa biroo.';

  @override
  String get donationInternationalPaymentTitle => 'Kaffaltii idil-addunyaa';

  @override
  String get donationInternationalPaymentSubtitle =>
      'Kaardii fi teessoo kaffaltii keessaniin bakka kamirraayyuu kaffalaa.';

  @override
  String get donationInternationalTitle => 'Sadaqaan Idil Addunyaa';

  @override
  String get donationInternationalSubtitle =>
      'Hawaasa addunyaa bakka kamirraayyuu deeggaru.';

  @override
  String get donationAmountLabel => 'Maallaqa arjooma';

  @override
  String get donationAmountHint => '0.00';

  @override
  String get donationAmountHelper =>
      'Maallaqni Birrii Itiyoophiyaan (ETB) qulqulleeffama.';

  @override
  String get donationAnonymousLabel => 'Maqaa osoo hin beekin kenni';

  @override
  String get donationAnonymousSubtitle => 'Maqaan kee ifatti hin mul\'atu.';

  @override
  String get donationDonorSectionTitle => 'Bal\'ina keessan';

  @override
  String get donationFullNameLabel => 'Maqaa guutuu';

  @override
  String get donationPhoneLabel => 'Bilbila';

  @override
  String get donationEmailLabel => 'Imeelii';

  @override
  String get donationBillingSectionTitle => 'Teessoo kaffaltii';

  @override
  String get donationAddress1Label => 'Sarara teessoo 1.1';

  @override
  String get donationAddress2Label => 'Sarara teessoo 2 (dirqama) .';

  @override
  String get donationCountryLabel => 'Biyya';

  @override
  String get donationCountryOther => 'Maqaa biyyaa';

  @override
  String get donationAdminAreaLabel => 'Naannoo / Naannoo';

  @override
  String get donationLocalityLabel => 'Magaalaa';

  @override
  String get donationPostalCodeLabel => 'Koodii poostaa';

  @override
  String get donationContinueToPayment => 'Kaffaltii itti fufaa';

  @override
  String get donationSubmitting => 'Adeemsa hojii...';

  @override
  String get donationSuccess => 'Sadaqa keessaniif galatoomaa.';

  @override
  String get donationValidationPhone =>
      'Lakkoofsa bilbilaa sirrii ta\'e bifa idil-addunyaatiin galchi (fkn +15551234567).';

  @override
  String get donationPaymentWebViewTitle => 'Kaffaltii guutuu';

  @override
  String get donationSelectCountry => 'Biyya filadhu';

  @override
  String get donationSearchCountry => 'Biyyoota barbaadi';

  @override
  String get donationSelectState => 'Naannoo / bulchiinsa filadhu';

  @override
  String get donationSearchState => 'Maqaa ykn gabaabduu barbaadi';

  @override
  String get donationNoMatchesFound => 'Walsimsiisaa hin argamne';

  @override
  String get changeAppModeTooltip => 'Haalata jijjiiri';

  @override
  String get switchedToAwqafMode => 'Gara haala Awqaf tti jijjiirame';

  @override
  String get switchToAwqaf => 'Gara Awqaf tti jijjiiraa';

  @override
  String get switchedToZakatMode => 'Gara haala Zakaatti jijjiirame';

  @override
  String get switchToZakat => 'Gara Zakaatti jijjiiraa';

  @override
  String get loginForgotPassword => 'Jecha icciitii dagattee?';

  @override
  String get loginForgotPasswordComingSoon =>
      'Password dagadhee yeroo dhiyootti dhufa';

  @override
  String get loginNewToBaraka => 'New to Baraka? ';

  @override
  String get loginCreateAccount => 'Akkaawuntii uumuu';

  @override
  String get loginCreateAccountComingSoon =>
      'Akkaawuntii uumuu yeroo dhiyootti';

  @override
  String get profileDisbursementIntro =>
      'Bakka kaffaltii argachuu barbaaddu filadhu.';

  @override
  String get profileCoopAccountLabel => 'Lakkoofsa Herrega Baankii Coop';

  @override
  String get profileCoopAccountHint => 'Lakkoofsa herrega keessanii galchaa';

  @override
  String get profileCoopAccountRequired =>
      'Mee lakkoofsa herrega Coop Bank keessanii galchaa.';

  @override
  String get profileSaveAccount => 'Herrega Qusachuu';

  @override
  String get faydaIdentityVerification => 'Eenyummaa mirkaneessuu';

  @override
  String get commonBack => 'Dugda';

  @override
  String get commonContinue => 'Itti fufuu';

  @override
  String get commonFinish => 'Xumuruu';

  @override
  String get commonTakePhoto => 'Suuraa Fudhadhaa';

  @override
  String get commonChooseGallery => 'Gallery keessaa filadhu';

  @override
  String get commonChooseFile => 'Faayilii filadhu';

  @override
  String get regTitle => 'Galmee Fayyadamtootaa';

  @override
  String get regMethodFastTrack => 'Faayidaa waliin Saffisaa';

  @override
  String get regMethodManual => 'Galmee Maanuwaalii';

  @override
  String get regMethodInstitution => 'Galmee Dhaabbilee';

  @override
  String get regMethodFastTrackDesc =>
      'Eenyummaa Biyyaalessaatiin haala nageenya qabuun mirkaneessuu fi daqiiqaa muraasa keessatti itti fufuu.';

  @override
  String get regMethodManualDesc =>
      'Odeeffannoo fi ibsa deeggarsaa keessan gamaaggama amanamaa ta\'eef qoodaa.';

  @override
  String get regMethodInstitutionDesc =>
      'Dhaabbata keessan galmeessuun sanadoota walsimannaa barbaachisan galchaa.';

  @override
  String get regSecureIdentityTitle => 'Mirkaneessa Eenyummaa Nageenya Qabu';

  @override
  String get regChooseMethodSubtitle =>
      'Imala kee jalqabuuf mala galmee filatte filadhu.';

  @override
  String get regFastTrackFaydaTitle =>
      'Saffisaan ID Biyyaalessaa (Fayda) waliin';

  @override
  String get regFastTrackFaydaSubtitle =>
      'ID dijitaalaa biyyoolessaa keessan fayyadamuun mirkaneessuu.';

  @override
  String get regManualTitle => 'Galmee Maanuwaalii';

  @override
  String get regManualSubtitle => 'Galmee deeggarsaa olkaa\'i gamaaggamaaf.';

  @override
  String get regInstitutionCardTitle => 'Akka Dhaabbataatti Galmaa\'uu';

  @override
  String get regInstitutionCardSubtitle =>
      'Dhaabbata, dhaabbata miti mootummaa, waldaa hojii gamtaa, ykn dhaabbata mootummaa.';

  @override
  String get regRegistrationCodeLabel => 'Koodii galmee';

  @override
  String get regRegistrationCodeHint => 'EZW-A1B2-C3D4';

  @override
  String get regEncryptedPrivate => 'Icciitii & Dhuunfaa';

  @override
  String get regEncryptedPrivateBody =>
      'Daataan keessan kan eegamee fi ulaagaa icciitii wajjin walsimuun kan qabamudha.';

  @override
  String get regVerificationInterrupted => 'Mirkaneessi addaan cite';

  @override
  String get regReopenVerification => 'Mirkaneessuu irra deebi\'ii banaa';

  @override
  String get regRetryListening => 'Irra deebi\'ii dhaggeeffachuu yaali';

  @override
  String get regCameraPermissionError =>
      'Kaameeraa/galma banachuu hin dandeenye. Mee hayyama ilaalaa.';

  @override
  String get regSelectBirthdate => 'Guyyaa dhalootaa filadhu';

  @override
  String get regManualIdentityTitle => 'Galmee Eenyummaa Harkaan';

  @override
  String get regFirstName => 'Maqaa jalqabaa';

  @override
  String get regLastName => 'Maqaa akaakayyuu';

  @override
  String get regGrandfatherName => 'Maqaa Akaakayyuu';

  @override
  String get regPhoneNumber => 'Lakkoofsa Bilbilaa';

  @override
  String get regPhoneHint => '+251911223344 or 0911223344';

  @override
  String get regEmail => 'Imeelii';

  @override
  String get regGender => 'Koorniyaa';

  @override
  String get regMale => 'Dhiira';

  @override
  String get regFemale => 'Dhalaa';

  @override
  String get regBeneficiaryCategory => 'Ramaddii Fayyadamtootaa';

  @override
  String get regNotes => 'Hubachiisa';

  @override
  String get regNotesHint => 'fkn. Iyyataa deeggarsa Zakaa';

  @override
  String get regUploadProfilePicture => 'Suuraa Profaayilii Olkaa\'i';

  @override
  String get regVerifyingFaydaBanner =>
      'Fayda waliin mirkaneessuu... Yeroo banamu browser keessatti mirkaneessuu guutuu.';

  @override
  String get regNeedsAssessment => 'Madaallii Fedhii';

  @override
  String get regSituationLabel => 'Haala yeroo ammaa keessa jirtu ibsi';

  @override
  String get regSituationHint =>
      'Rakkoo, hirkattoota, fi fedhii hatattamaa ibsi...';

  @override
  String get regUploadProof => 'Ragaa Olkaa\'uu';

  @override
  String get regDisbursementSetup => 'Qophii Kaffaltii';

  @override
  String get regTelebirrTitle => 'Telebirr Wallaggaa';

  @override
  String get regTelebirrSubtitle =>
      'Maallaqa mobaayilaan battalumatti dabarsuu';

  @override
  String get regMpesaTitle => 'M-Pesa jedhamuun beekama';

  @override
  String get regMpesaSubtitle =>
      'Neetworkiin kaffaltii moobaayilaa nageenya qabu';

  @override
  String get regCoopbankTitle => 'Coopbank Account';

  @override
  String get regCoopbankSubtitle => 'Direct bank deposit';

  @override
  String get regAccountOrMobile => 'Herrega ykn Lakkoofsa Mobaayilaa';

  @override
  String get regFullLegalName => 'Maqaa Seeraa Guutuu';

  @override
  String get regAgreementTitle => 'Waliigaltee & Shari\'aa Ulaagaa';

  @override
  String get regAgreementBody =>
      'Odeeffannoon dhugaa ta\'uu isaa fi akkaataa imaammataatti gargaarsa akka fayyadamu nan labsa.';

  @override
  String get regInstitutionRegistration => 'Galmee Dhaabbilee';

  @override
  String get regInstitutionType => 'Gosa Dhaabbataa';

  @override
  String get regLegalName => 'Maqaa Seeraa';

  @override
  String get regTradingName => 'Maqaa Daldalaa';

  @override
  String get regTradeRegistrationNumber => 'Lakkoofsa Galmee Daldalaa';

  @override
  String get regTin => 'Lakkoofsa Eenyummaa Gibiraa (TIN) .';

  @override
  String get regVatOptional => 'Lakkoofsa Galmee VAT (dirqama) .';

  @override
  String get regRegion => 'Naannoo';

  @override
  String get regCity => 'Magaalaa';

  @override
  String get regAddress => 'Teessoo';

  @override
  String get regNotesOptional => 'Yaadannoo (dirqama) .';

  @override
  String get regAuthorityDocTitle => 'Aangoo hojii sanada barbaachisu';

  @override
  String get regAuthorityDocBody =>
      'Yoo namni mallatteessaa galmaa\'e malee namni biraa dhiheesse dandeessisi.';

  @override
  String get regFilePickError =>
      'Faayilii fudhachuu hin dandeenye. Mee hayyama ilaalaa.';

  @override
  String get regUploadKycTitle => 'Sanadoota KYC olkaa\'aa';

  @override
  String get regUploadKycBody =>
      'Upload each required document. You can finish once all required documents are uploaded.';

  @override
  String regReference(Object id) {
    return 'Wabii: $id .';
  }

  @override
  String get regNoDocumentsRequired =>
      'Yeroo kanatti sanadoonni hin barbaachisu.';

  @override
  String get regRequired => 'Kan barbaadamu';

  @override
  String get regOptional => 'Dirqama kan hinta\'in';

  @override
  String regSelectedFile(Object name) {
    return 'Filatame: $name .';
  }

  @override
  String get regUploaded => 'Olkaa\'ameera';

  @override
  String get regUpload => 'Olkaa\'i';

  @override
  String get regCreatePasswordTitle => 'Password Keessan Uumuu';

  @override
  String get regCreatePasswordBody =>
      'Akkaawuntii keessaniif jecha icciitii nageenya qabu filadhaa. Erga galmooftanii booda galmaa\'uuf itti fayyadamtu.';

  @override
  String get regPassword => 'Jecha iccitii';

  @override
  String get regConfirmPassword => 'Password Mirkaneessi';

  @override
  String get regPasswordRules =>
      'Jechi icciitii yoo xiqqaate arfiilee 8 ta\'uu fi qubee guddaa, qubee xiqqaa, lakkoofsa, fi arfii addaa of keessaa qabaachuu qaba.';

  @override
  String get regPasswordSuccess =>
      'Password milkaa\'inaan saaguu. Baga gara Mejlis Digital Hub dhuftan.';

  @override
  String regInstitutionComplete(Object id) {
    return 'Galmeen dhaabbilee xumurameera. Wabii: $id .';
  }

  @override
  String get regInstitutionCompleteGeneric => 'Galmeen dhaabbilee xumurameera.';

  @override
  String get regCompleteLocal =>
      'Galmeen xumurameera. Fedhii fi ibsi kaffaltii naannootti ni kuufama.';

  @override
  String get regContinueWithFayda => 'Faaydaa waliin itti fufaa';

  @override
  String get regVerifyingFayda => 'Fayya waliin mirkaneessaa...';

  @override
  String get regSubmitContinue => 'Galchuu & Itti Fufa';

  @override
  String get regSetPasswordContinue => 'Password Saagi & Itti fufi';

  @override
  String get regSetPasswordFinish => 'Password & Finish Saagi';

  @override
  String get navAwqaf => 'Awqaf';
}
