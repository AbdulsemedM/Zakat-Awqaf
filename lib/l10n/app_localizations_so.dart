// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Somali (`so`).
class AppLocalizationsSo extends AppLocalizations {
  AppLocalizationsSo([String locale = 'so']) : super(locale);

  @override
  String get appTitle => 'Komishanka Sakada & Awqaafta';

  @override
  String get splashSlogan => 'Allaah dartiis, u adeegidda bini\'aadmiga';

  @override
  String get splashWaqfByLabel => 'Waqf by';

  @override
  String get splashWaqfByTitle => 'Coop Bank Alhuda';

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
  String get urgentBeneficiaryNeeds => 'Sababaha Degdegga ah';

  @override
  String get viewAll => 'Dhammaan Arag →';

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
  String get payZakatCause => 'Sii Zakat';

  @override
  String get zakatAlFitr => 'Zakat Al-Fitr';

  @override
  String get needQuickWayGive => 'Bixin Degdeg ah';

  @override
  String get supportCommunityNeeds =>
      'Ku taageer baahiyaha bulshada si degdeg ah adigoo Sadaqo bixinaya.';

  @override
  String get donateSadaqah => 'Bixi Sadaqo';

  @override
  String get aboutCommission => 'Guddiga Zakada iyo Awqaafta Itoobiya';

  @override
  String get aboutCommissionBody =>
      'Isku dubbaridka ururinta zakada iyo horumarinta awqaafta si kor loogu qaado bulshooyinka nugul iyadoo la adeegsanayo barnaamijyo hufan oo waafaqsan shareecada oo ku baahsan Itoobiya.';

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
  String get calcAppBarTitle => 'Xisaabiyaha Sakada';

  @override
  String get calcPayYourZakat => 'Bixi Sakadaada';

  @override
  String get calcTabWealth => 'Maalka';

  @override
  String get calcTabLivestock => 'Xoolaha';

  @override
  String get calcTabCrops => 'Dalagga';

  @override
  String get calcStep1NisabTitle => 'Tallaabada 1: Xadka Nisab';

  @override
  String calcStep1NisabBody(String grams, String metal) {
    return 'Sakadu waa waajib haddii hantidaada saafiga ahi gaarto nisabka: $grams g oo $metal ah qiimaha maanta.';
  }

  @override
  String calcNisabGoldFormula(String grams, String price, String total) {
    return '${grams}_ × $price = $total';
  }

  @override
  String calcNisabThresholdBanner(String amount, String grams, String metal) {
    return 'Xadka Nisab ($grams g $metal): $amount';
  }

  @override
  String get calcStep1LivestockTitle => 'Tallaabada 1: Habka cabbirka xoolaha';

  @override
  String get calcStep1LivestockBody =>
      'Sakada xoolaha waxaa lagu xisaabiyaa miisaanka madaxa-tirinta (ma aha % qiimaha).';

  @override
  String calcStep1LivestockNisabNote(
    int sheep,
    int cattle,
    int camels,
    int tabiPer,
    int musinnahPer,
  ) {
    return 'Xadka Nisab: Idaha/Riyaha $sheep, Lo\'da $cattle, Geela $camels. Lo\'du waxay isticmaashaa isku-darka $tabiPer/$musinnahPer; geeluna wuxuu raacaa heerarka.';
  }

  @override
  String calcAdvisoryPrefix(String text) {
    return 'La-talin: ${text}_';
  }

  @override
  String get calcArabicTermDefinitionsTitle => 'Qeexitaanno Erayga Carabiga';

  @override
  String get calcArabicDefTabi => 'dibi hal sano jir ah';

  @override
  String get calcArabicDefMusinnah => 'sac laba jir ah';

  @override
  String get calcArabicDefBintMakhad => 'hasha hal sano jirta';

  @override
  String get calcArabicDefBintLabun => 'hasha oo laba jir ah';

  @override
  String get calcArabicDefHiqqah => 'hasha oo saddex jir ah';

  @override
  String get calcArabicDefJadhah => 'hasha afar jir ah';

  @override
  String get calcStep1CropTitle => 'Talaabada 1: Dalagyada (Ushr) xisaabinta';

  @override
  String calcStep1CropBody(
    String nisab,
    String rainRate,
    String irrigatedRate,
  ) {
    return 'Sakada dalagga waxay ku egtahay xilliga goosashada. Nisab waa ${nisab}kg. Heerku waa $rainRate% (Roob-quut), $irrigatedRate% (waraabka la waraabiyo), ama lagu miisaamay isku darka.';
  }

  @override
  String calcCropLineThreshold(String kg, String relation) {
    return '${kg}_ kg $relation 653 kg';
  }

  @override
  String calcCropLineIrrigation(String mode) {
    return 'Habka waraabka: ${mode}_';
  }

  @override
  String calcCropLineEffectiveRate(String rate) {
    return 'Qiimaha waxtarka leh: ${rate}_%';
  }

  @override
  String calcCropLineFormula(String line) {
    return 'Formula: ${line}_';
  }

  @override
  String get calcRelationGte => '≥';

  @override
  String get calcRelationLt => '<';

  @override
  String get calcOverviewNetWorthTitle => 'Dulmarka Net Worth';

  @override
  String get calcOverviewLivestockTitle => 'Dulmarka Xoolaha';

  @override
  String get calcOverviewCropTitle => 'Dulmarka Dalagga';

  @override
  String get calcBadgeAboveNisab => 'Korka Nisab';

  @override
  String get calcBadgeBelowNisab => 'Hoosta Nisab';

  @override
  String get calcBadgeZakatDue => 'Sakada oo la rabo';

  @override
  String get calcBadgeNoDue => 'Maya Due';

  @override
  String get calcZakatDueLabel => 'Sakada oo la rabo';

  @override
  String get calcLivestockDueLabel => 'Qiimaha Xoolaha';

  @override
  String get calcCropZakatDueLabel => 'Dalagyada Sakada oo la rabo';

  @override
  String calcAnimalsCount(int count) {
    return '${count}_ xoolaha';
  }

  @override
  String calcKgHarvest(String kg) {
    return '${kg}_ kg goosashada';
  }

  @override
  String get calcLivestockTermsFootnote =>
      'Shuruudaha ay ka midka yihiin tabi\', musinnah, bint makhad, bint labun, xiqqah, iyo jadhah ayaa lagu sharaxay hoos tafaasiisha Xoolaha.';

  @override
  String get calcStep2EnterAssets => 'Tallaabada 2: Geli Hantidaada';

  @override
  String get calcStep2EnterAssetsBody => 'Geli qiimaha hantidaada ETB';

  @override
  String get calcCashBankSavings => 'Lacag caddaan ah & Keydka Bankiga';

  @override
  String get calcCashOnHand => 'Lacag caddaan ah oo gacanta ku jirta';

  @override
  String get calcBankBalance => 'Balance-ka';

  @override
  String get calcMobileWallet => 'Jeebka gacanta';

  @override
  String get calcBusinessAssets => 'Hantida Ganacsiga';

  @override
  String get calcFieldDescription => 'Sharaxaada';

  @override
  String get calcFieldType => 'Nooca';

  @override
  String get calcAmountEtb => 'Qadarka (ETB)';

  @override
  String get calcAddBusinessAsset => 'Ku dar hantida ganacsiga';

  @override
  String get calcGoldSilver => 'Dahab & Qalin';

  @override
  String get calcGoldGrams => 'Dahab (gram)';

  @override
  String get calcGoldKarat => 'Dahab Karaat';

  @override
  String get calcSilverGrams => 'Silver (gram)';

  @override
  String get calcLiabilities => 'Waajibaadka';

  @override
  String get calcAddLiability => 'Ku dar masuuliyad';

  @override
  String get calcAssetInventory => 'Alaabada';

  @override
  String get calcAssetReceivable => 'La qaadan karo';

  @override
  String get calcAssetOther => 'Mid kale';

  @override
  String get calcLiabilityShortTermDebt => 'Deynta muddada gaaban';

  @override
  String get calcLiabilityPayable => 'La bixin karo';

  @override
  String get calcLiabilityOther => 'Mid kale';

  @override
  String get calcLivestockSheepGoats => 'Idaha/Riyaha';

  @override
  String get calcLivestockCattle => 'Lo\'da';

  @override
  String get calcLivestockCamels => 'Geela';

  @override
  String get calcPastureFedTitle => 'Daaq la quudiyo sanadka intiisa badan';

  @override
  String get calcPastureFedSubtitle => 'La-talin kaliya; ma xannibo xisaabinta';

  @override
  String get calcHawlTitle => 'Dhammaatay hal sano oo dayaxeed (Hawl)';

  @override
  String get calcHawlSubtitle => 'La-talin kaliya; ma xannibo xisaabinta';

  @override
  String get calcWorkAnimalsTitle => 'Loo isticmaalo shaqada (xaaqid/gaadiid)';

  @override
  String get calcWorkAnimalsSubtitle =>
      'La-talin kaliya; ma xannibo xisaabinta';

  @override
  String get calcLivestockSummaryHeading => 'Xoolaha oo kooban';

  @override
  String get calcCropNisabHeading => 'Nisab & dalagga la rabo';

  @override
  String calcEffectiveCropRateLine(String percent) {
    return 'Heerka dalagga ee waxtarka leh: ${percent}_%';
  }

  @override
  String calcCropZakatDueKgLine(String kg) {
    return 'Sakada dalagga ee la rabo: ${kg}_ kg';
  }

  @override
  String get calcHowCropZakatWorksTitle => 'Sida sakada dalagga u shaqeyso';

  @override
  String calcHowCropZakatWorksBody(
    String nisab,
    String rainRate,
    String irrigatedRate,
  ) {
    return 'Nisab: ${nisab}kg. Heerarka: roobka lagu quudiyo $rainRate%, waraabinta $irrigatedRate%, isku dhafan = kala qaybsanaan miisaan leh. Sakadu waxay ku beegan tahay xilliga goosashada (wax sanadle ah oo la beero ma jirto).';
  }

  @override
  String get calcHowCropZakatNote =>
      'Fiiro gaar ah: Appku wuxuu u dabaqaa xeerarkan si guud si ay u fududaato. Jagooyinka aqoon-yahanku way ku kala duwan yihiin baaxadda nooca dalagga iyo dhimista kharashyada; la tasho aqoonyahanno aqoon u leh kiisas gaar ah.';

  @override
  String get calcWealthNisabHeading => 'Nisaab & Maal Sakada';

  @override
  String calcWealthNisabLine(String nisab) {
    return 'Xadka Nisab: ${nisab}_';
  }

  @override
  String calcWealthZakatDueLine(String due) {
    return 'Sakada maalka ah ee la leeyahay ( qadar yar oo kaadhka saaran): $due';
  }

  @override
  String get calcHowWealthZakatWorksTitle =>
      'Sida hantida Zakada loo xisaabiyo';

  @override
  String get calcHowWealthZakatNote =>
      'Fiiro gaar ah: Culimadu waxay ku kala duwan yihiin hantida sakada lagu bixin karo, sida daymaha loo dhimo hantida, marka la qabanayo sanadka (Hawl) iyo tafaasiil kale. Shaashadani waa qiyaas waxbarasho - ka xaqiiji xaaladaada aqoonyahano aqoon leh.';

  @override
  String get calcWealthBreakdownTitle => 'Sida loo xisaabiyo cadadka kore';

  @override
  String calcWealthTransLiquidsLine(
    String cash,
    String bank,
    String mobile,
    String subtotal,
  ) {
    return 'Lacag caddaan ah + bangiga + mobilada: ${cash}_ + $bank + $mobile = $subtotal';
  }

  @override
  String calcWealthTransBusinessLine(String business) {
    return 'Hantida ganacsiga (wadarta safafka): $business';
  }

  @override
  String calcWealthTransRollupLine(
    String liquids,
    String business,
    String gold,
    String silver,
    String total,
  ) {
    return 'Wadarta hantida: ${liquids}_ + $business + $gold + $silver = $total';
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
    return 'Dahab: $grams g × $karat ($price/g) = $value';
  }

  @override
  String calcWealthTransSilverLine(String grams, String rate, String value) {
    return 'Lacag: $grams g × $rate ETB/g = $value';
  }

  @override
  String calcWealthTransNetLine(String liabilities, String net) {
    return 'Hantida saafiga ah (qadar badan oo kaadhka ku jirta): wadarta hantida - deymaha ($liabilities) = $net';
  }

  @override
  String calcWealthTransDueAbove(
    String net,
    String due,
    String nisab,
    String rate,
  ) {
    return 'Sababtoo ah $net waa nisab ama ka sareeya ($nisab), Sakada la leeyahay = $net × $rate% = $due.';
  }

  @override
  String calcWealthTransDueBelow(String net, String nisab, String due) {
    return 'Sababtoo ah $net waxay ka hooseysaa nisab ($nisab), Sakada maalka ee la rabo = $due.';
  }

  @override
  String get calcCropWeightKg => 'Miisaanka Dalagga (kg)';

  @override
  String get calcCropModeRainFed => 'Roobab lagu quudiyo';

  @override
  String get calcCropModeIrrigated => 'Waraabka';

  @override
  String get calcCropModeMixed => 'Isku dhafan';

  @override
  String get calcRainFedSharePct => 'Saamiga roobka lagu quudiyo %';

  @override
  String get calcIrrigatedSharePct => 'Qaybta waraabka %';

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
  String get calcMethodologyPlaceholder => 'Habka Sakada meel hayaha nuxurka.';

  @override
  String calcCertCropDueLine(String kg) {
    return 'Sakada dalagga ee la rabo: ${kg}_ kg';
  }

  @override
  String get calcBulletSeparator => ' • ';

  @override
  String calcLsSheepGoats(int count) {
    return 'Idaha/Riyaha: $count idaha';
  }

  @override
  String calcLsCattle(int tabi, int musinnah) {
    return 'Lo\'da: $tabi tabi\' + $musinnah musinnah';
  }

  @override
  String calcLsCamels(String description) {
    return 'Geela: ${description}_';
  }

  @override
  String get calcLsNone =>
      'Ma jiraan wax xoolo ah oo loo haysto marka la eego tirada hadda';

  @override
  String calcTransSheep(int head, int due, int min) {
    return 'Meesha Idaha/Riyaha: $head >= $min => $due lax ah.';
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
    return 'Xadka lo\'da: ${head}_ >= $min => la\'aanta $tabi tabi\', $musinnah musinnah (isku darka $tabiPer/$musinnahPer).';
  }

  @override
  String calcTransCamel(int head, String due, int min) {
    return 'Meesha geela: ${head}_ >= $min => la rabo $due.';
  }

  @override
  String calcTransAdvisoryLine(String text) {
    return 'La-talin: ${text}_';
  }

  @override
  String get calcAdvNotPasture =>
      'Aan daaq la quudin inta badan sanadka: ka hubi ganacsiga/daawaynta ganacsiga culimada.';

  @override
  String get calcAdvHawl =>
      'Hawl aan la dhamaystirin: culimo badan ayaa u baahan sakada xoolaha hal sano oo dayaxa.';

  @override
  String get calcAdvWork =>
      'Xoolaha shaqadu caadi ahaan waa laga dhaafay sakada xoolaha.';

  @override
  String calcCropTransBelow(String kg, String nisab) {
    return 'Goynta ${kg}kg waxay ka hoosaysaa Nisab ($nisab kg), markaa sakada dalagga lagama rabo.';
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
    return 'Waraabka isku dhafan: roobka $rain%, waraabka $irrig%. Heerka waxtarka leh = $rate%. Formula: ${kg}_ × $rate2% = ${due}kg.';
  }

  @override
  String calcCropTransRainFed(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'Heerka roobka lagu quudiyo $rate%. Formula: ${kg}_ × $rate2% = ${due}kg.';
  }

  @override
  String calcCropTransIrrigated(
    String rate,
    String kg,
    String rate2,
    String due,
  ) {
    return 'Heerka waraabka $rate%. Formula: ${kg}_ × $rate2% = ${due}kg.';
  }

  @override
  String get calcCamelNoDue => 'Xaq uma laha';

  @override
  String calcCamelSheepN(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ido',
      one: '1 ido',
    );
    return '$_temp0';
  }

  @override
  String get profileLoadErrorTitle => 'Lama soo dejin karin profile-kaaga';

  @override
  String get profileTryAgain => 'Mar kale isku day';

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
  String get loginTitle => 'Soo gal';

  @override
  String get loginSubtitle =>
      'Isticmaal lambarka taleefanka ama iimaylka diiwaangashan iyo furahaaga sirta';

  @override
  String get loginPasswordLabel => 'Furaha';

  @override
  String get loginButton => 'Soo gal';

  @override
  String get loginSecureNote => 'Soo gelidaadu waa sir oo ammaan ah';

  @override
  String get loginPasswordRequired => 'Geli eraygaaga sirta ah';

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

  @override
  String get donationCurrencySheetTitle =>
      'Sideed u jeclaan lahayd inaad wax siiso?';

  @override
  String get donationCurrencySheetSubtitle =>
      'Dooro lacag bixinta ETB ee gudaha ama bixinta kaadhka caalamiga ah.';

  @override
  String get donationInternationalPaymentTitle => 'Lacag bixinta caalamiga ah';

  @override
  String get donationInternationalPaymentSubtitle =>
      'Meel kasta ku bixi kaarkaada iyo ciwaanka qaansheegtaada.';

  @override
  String get donationInternationalTitle => 'Sadaqah caalami ah';

  @override
  String get donationInternationalSubtitle =>
      'Taageer bulshooyinka meel kasta oo ay adduunka ka joogaan.';

  @override
  String get donationAmountLabel => 'Qadarka deeqda';

  @override
  String get donationAmountHint => '0.00';

  @override
  String get donationAmountHelper =>
      'Lacagta waxa lagu dejiyaa Birta Itoobiya (ETB).';

  @override
  String get donationAnonymousLabel => 'Si qarsoodi ah u bixi';

  @override
  String get donationAnonymousSubtitle =>
      'Magacaaga si guud looma muujin doono.';

  @override
  String get donationDonorSectionTitle => 'Faahfaahintaada';

  @override
  String get donationFullNameLabel => 'Magaca buuxa';

  @override
  String get donationPhoneLabel => 'Taleefanka';

  @override
  String get donationEmailLabel => 'iimaylka';

  @override
  String get donationBillingSectionTitle => 'Cinwaanka biilasha';

  @override
  String get donationAddress1Label => 'Xariiqa ciwaanka 1';

  @override
  String get donationAddress2Label => 'Sadarka ciwaanka 2 (ikhtiyaar)';

  @override
  String get donationCountryLabel => 'Dalka';

  @override
  String get donationCountryOther => 'Magaca dalka';

  @override
  String get donationAdminAreaLabel => 'Gobolka / Gobolka';

  @override
  String get donationLocalityLabel => 'Magaalada';

  @override
  String get donationPostalCodeLabel => 'Koodhka boostada';

  @override
  String get donationContinueToPayment => 'Sii wad bixinta';

  @override
  String get donationSubmitting => 'Hagaajinta…';

  @override
  String get donationSuccess => 'Waad ku mahadsan tahay Sadaqadaada.';

  @override
  String get donationValidationPhone =>
      'Geli nambar taleefoon ansax ah oo qaab caalami ah ( tusaale +15551234567).';

  @override
  String get donationPaymentWebViewTitle => 'Bixinta dhamaystiran';

  @override
  String get donationSelectCountry => 'Dalka dooro';

  @override
  String get donationSearchCountry => 'Raadi wadamada';

  @override
  String get donationSelectState => 'Dooro gobol/gobol';

  @override
  String get donationSearchState => 'Ku raadi magaca ama soo gaabinta';

  @override
  String get donationNoMatchesFound => 'Wax u dhigma lama helin';

  @override
  String get changeAppModeTooltip => 'Beddel qaabka';

  @override
  String get switchedToAwqafMode => 'Loo bedelay qaabka Awqaafta';

  @override
  String get switchToAwqaf => 'U beddelo Awqaafta';

  @override
  String get switchedToZakatMode => 'Loo beddelay qaabka Sakada';

  @override
  String get switchToZakat => 'U beddelo Sakada';

  @override
  String get loginForgotPassword => 'Ilmaamay erayga sirta ah?';

  @override
  String get loginForgotPasswordComingSoon =>
      'Illowday erayga sirta ah ee soo socda dhawaan';

  @override
  String get loginNewToBaraka => 'New to Baraka? ';

  @override
  String get loginCreateAccount => 'Samee xisaab';

  @override
  String get loginCreateAccountComingSoon => 'Abuur akoon dhawaan';

  @override
  String get profileDisbursementIntro =>
      'Dooro meesha aad rabto inaad ka hesho lacag bixinta.';

  @override
  String get profileCoopAccountLabel => 'Coop Number Account Bank';

  @override
  String get profileCoopAccountHint => 'Geli lambarka akoonkaaga';

  @override
  String get profileCoopAccountRequired =>
      'Fadlan geli lambarkaaga koontada Coop Bank';

  @override
  String get profileSaveAccount => 'Keydso Akoonka';

  @override
  String get faydaIdentityVerification => 'Xaqiijinta aqoonsiga';

  @override
  String get commonBack => 'Dib u noqo';

  @override
  String get commonContinue => 'Sii wad';

  @override
  String get commonFinish => 'dhame';

  @override
  String get commonTakePhoto => 'Sawir qaad';

  @override
  String get commonChooseGallery => 'Ka dooro Gallery';

  @override
  String get commonChooseFile => 'Dooro File';

  @override
  String get regTitle => 'Diiwaangelinta ka faa\'iidaystayaasha';

  @override
  String get regMethodFastTrack => 'Dhaqso-track leh Fayda';

  @override
  String get regMethodManual => 'Diiwaangelinta gacanta';

  @override
  String get regMethodInstitution => 'Diiwaangelinta Hay\'adaha';

  @override
  String get regMethodFastTrackDesc =>
      'Si sugan ugu xaqiiji aqoonsiga aqoonsiga qaranka oo ku sii wad daqiiqado gudahood.';

  @override
  String get regMethodManualDesc =>
      'La wadaag macluumaadkaaga iyo faahfaahinta taageerada si dib u eegis la aamini karo.';

  @override
  String get regMethodInstitutionDesc =>
      'Diiwaangeli ururkaaga oo soo gudbi dukumentiyada u hoggaansanaanta ee loo baahan yahay.';

  @override
  String get regSecureIdentityTitle => 'Xaqiijinta Aqoonsiga Sugan';

  @override
  String get regChooseMethodSubtitle =>
      'Dooro habka diiwaangelinta ee aad doorbidayso si aad u bilowdo safarkaaga.';

  @override
  String get regFastTrackFaydaTitle => 'Dhaqso-track leh aqoonsi qaran (Fayda)';

  @override
  String get regFastTrackFaydaSubtitle =>
      'Xaqiiji adigoo isticmaalaya aqoonsiga dhijitaalka ah ee qaranka';

  @override
  String get regManualTitle => 'Diiwaangelinta gacanta';

  @override
  String get regManualSubtitle => 'Soo rar dukumeenti taageeraya dib u eegista';

  @override
  String get regInstitutionCardTitle => 'Isku diwaangeli machad ahaan';

  @override
  String get regInstitutionCardSubtitle =>
      'Shirkad, NGO, iskaashato, ama hay\'ad dawladeed.';

  @override
  String get regRegistrationCodeLabel => 'Koodhka diiwaangelinta';

  @override
  String get regRegistrationCodeHint => 'EZW-A1B2-C3D4';

  @override
  String get regEncryptedPrivate => 'Sir & Gaar ah';

  @override
  String get regEncryptedPrivateBody =>
      'Xogtaada waa la xafiday waxaana loo maamulay si waafaqsan heerarka qarsoodiga.';

  @override
  String get regVerificationInterrupted => 'Xaqiijinta ayaa hakad gashay';

  @override
  String get regReopenVerification => 'Dib u fur xaqiijinta';

  @override
  String get regRetryListening => 'Isku day dhegeysiga';

  @override
  String get regCameraPermissionError =>
      'Ma furi karo kamarad/Gallery Fadlan hubi ogolaanshaha';

  @override
  String get regSelectBirthdate => 'Dooro taariikhda dhalashada';

  @override
  String get regManualIdentityTitle => 'Diiwaangelinta Aqoonsiga Buugga';

  @override
  String get regFirstName => 'Magaca Hore';

  @override
  String get regLastName => 'Magaca Dambe';

  @override
  String get regGrandfatherName => 'Magaca Awoowe';

  @override
  String get regPhoneNumber => 'Lambarka Taleefanka';

  @override
  String get regPhoneHint => '+251911223344 or 0911223344';

  @override
  String get regEmail => 'iimaylka';

  @override
  String get regGender => 'Jinsiga';

  @override
  String get regMale => 'Lab';

  @override
  String get regFemale => 'Dheddig';

  @override
  String get regBeneficiaryCategory => 'Qaybta ka faa\'iidaystayaasha';

  @override
  String get regNotes => 'Xusuusin';

  @override
  String get regNotesHint => 'tusaale. Codsadaha taageerada sakada';

  @override
  String get regUploadProfilePicture => 'Soo rar sawirka Profile';

  @override
  String get regVerifyingFaydaBanner =>
      'Xaqiijinta Fayda… Xaqiijinta dhammaystiran ee browserka marka uu furmo.';

  @override
  String get regNeedsAssessment => 'Wuxuu u baahan yahay Qiimayn';

  @override
  String get regSituationLabel => 'Sharax xaaladdaada hadda';

  @override
  String get regSituationHint =>
      'Sharax dhibka, dadka ku tiirsan, iyo baahiyaha degdega ah...';

  @override
  String get regUploadProof => 'Soo rar caddayn';

  @override
  String get regDisbursementSetup => 'Dejinta Lacag bixinta';

  @override
  String get regTelebirrTitle => 'Telebirr Wallet';

  @override
  String get regTelebirrSubtitle => 'Xawaaladaha moobilka degdega ah';

  @override
  String get regMpesaTitle => 'M-Pesa';

  @override
  String get regMpesaSubtitle => 'Shabakad lacag-bixineed mobilada oo sugan';

  @override
  String get regCoopbankTitle => 'Koontada Coopbank';

  @override
  String get regCoopbankSubtitle => 'Debaajiga tooska ah ee bangiga';

  @override
  String get regAccountOrMobile => 'Account ama Mobile Number';

  @override
  String get regFullLegalName => 'Magaca Sharciga oo Buuxa';

  @override
  String get regAgreementTitle => 'Heshiiska & Ku Dhaqanka Shareecada';

  @override
  String get regAgreementBody =>
      'Waxaan cadeynayaa in macluumaadka uu yahay mid run ah oo aan u adeegsan doono gargaarka si waafaqsan siyaasadda.';

  @override
  String get regInstitutionRegistration => 'Diiwaangelinta Hay\'adaha';

  @override
  String get regInstitutionType => 'Nooca Hay\'adda';

  @override
  String get regLegalName => 'Magaca Sharci';

  @override
  String get regTradingName => 'Magaca Ganacsiga';

  @override
  String get regTradeRegistrationNumber => 'Lambarka Diiwaangelinta Ganacsiga';

  @override
  String get regTin => 'Lambarka Aqoonsiga Canshuurta (TIN)';

  @override
  String get regVatOptional => 'Lambarka Diiwaangelinta VAT (ikhtiyaar)';

  @override
  String get regRegion => 'Gobolka';

  @override
  String get regCity => 'Magaalada';

  @override
  String get regAddress => 'Cinwaanka';

  @override
  String get regNotesOptional => 'Xusuusin (ikhtiyaar)';

  @override
  String get regAuthorityDocTitle =>
      'Awoodda ku-dhaqanka dukumentiga ayaa loo baahan yahay';

  @override
  String get regAuthorityDocBody =>
      'Daree haddii qof aan ahayn saxiixe diiwaangashan uu soo gudbiyo.';

  @override
  String get regFilePickError =>
      'Ma dooran karo faylka Fadlan hubi ogolaanshaha';

  @override
  String get regUploadKycTitle => 'Soo rar dukumeentiyada KYC';

  @override
  String get regUploadKycBody =>
      'Soo rar dukumeenti kasta oo loo baahan yahay. Waad dhammayn kartaa marka dhammaan dukumeentiyada loo baahan yahay la soo geliyo.';

  @override
  String regReference(Object id) {
    return 'Tixraac: _PH_0__';
  }

  @override
  String get regNoDocumentsRequired =>
      'Wax dukumeenti ah looma baahna wakhtigan.';

  @override
  String get regRequired => 'Loo baahan yahay';

  @override
  String get regOptional => 'Ikhtiyaar ah';

  @override
  String regSelectedFile(Object name) {
    return 'la doortay: _PH_0__';
  }

  @override
  String get regUploaded => 'La soo galiyay';

  @override
  String get regUpload => 'Soo rar';

  @override
  String get regCreatePasswordTitle => 'Samee eraygaaga sirta ah';

  @override
  String get regCreatePasswordBody =>
      'Dooro furaha sirta ah ee xisaabtaada Waxaad u isticmaali doontaa inaad ku soo gasho diiwaangelinta ka dib.';

  @override
  String get regPassword => 'Furaha';

  @override
  String get regConfirmPassword => 'Xaqiiji erayga sirta ah';

  @override
  String get regPasswordRules =>
      'Furaha sirta ah waa in uu ahaadaa ugu yaraan 8 xaraf oo ay ku jiraan far waaweyn, far yar, lambar, iyo xarfo gaar ah.';

  @override
  String get regPasswordSuccess =>
      'Si guul leh ayaa loo dejiyay erayga sirta ah Ku Soo Dhawoow Mejlis Digital Hub.';

  @override
  String regInstitutionComplete(Object id) {
    return 'Diiwaangelinta hay\'adda oo dhammaatay. Tixraac: _PH_0__';
  }

  @override
  String get regInstitutionCompleteGeneric =>
      'Diiwaangelinta hay\'adda oo dhammaatay.';

  @override
  String get regCompleteLocal =>
      'Diiwaangelintu way dhammaatay. Baahiyaha iyo faahfaahinta bixinta waxa lagu kaydiyaa gudaha.';

  @override
  String get regContinueWithFayda => 'Ku sii wad Fayda';

  @override
  String get regVerifyingFayda => 'Xaqiijinta Fayda...';

  @override
  String get regSubmitContinue => 'Gudbi oo sii wad';

  @override
  String get regSetPasswordContinue => 'Deji erayga sirta ah oo sii wad';

  @override
  String get regSetPasswordFinish => 'Deji erayga sirta ah oo dhame';

  @override
  String get navAwqaf => 'Awqaaf';

  @override
  String get regVerifyCode => 'Xaqiiji';

  @override
  String regCodeBranchLabel(String branchName) {
    return 'Laanta: $branchName';
  }

  @override
  String get regCodeBranchConfirm =>
      'Fadlan xaqiiji in tani tahay laantaada ka hor intaadan sii wadin.';

  @override
  String get regAddressLine => 'Cinwaanka';

  @override
  String get regKebele => 'Kebele';

  @override
  String get regReligion => 'Diinta';

  @override
  String get regMaritalStatus => 'Xaaladda guurka';

  @override
  String get regMaritalSingle => 'Doob';

  @override
  String get regMaritalMarried => 'Xaas leh';

  @override
  String get regMaritalWidowed => 'Carmal';

  @override
  String get regMaritalDivorced => 'Furiin';

  @override
  String get regMaritalSeparated => 'Kala tagay';

  @override
  String get regVerifyCodeFirst =>
      'Geli koodhka diiwaangelinta oo taabo «Xaaqiiji». Foomku wuu furmayaa marka koodhka la aqbalo.';

  @override
  String get homeQuickCalculate => 'Xisaabi';

  @override
  String get homeQuickSadaqah => 'Sadaqo';

  @override
  String get homeQuickApply => 'Codso';

  @override
  String get homeUpcoming => 'SOO SOCDA';

  @override
  String get payTitleZakat => 'Dhammaystir Sakadaada';

  @override
  String get paySubtitleZakat =>
      'Waajibkaaga si ammaan ah ugu gut kanaalada maxalliga ah ee la isku halleyn karo.';

  @override
  String get payTotalZakatDue => 'WADARTA SAKADA LAGU LEEYAHAY';

  @override
  String get payCalculatedOverview => 'SOO KOOBID XISAABSAN';

  @override
  String get payAmountLabel => 'Lacagta la bixinayo (ETB)';

  @override
  String get payAmountHintZakat => 'Geli lacagta aad rabto inaad bixiso';

  @override
  String get payAmountHintEtb => 'Geli lacag ETB ah';

  @override
  String get payNaturalUnitsLivestock =>
      'Sakada xoolaha waxaa lagu bixiyaa xoolo. Waxaad bixin kartaa qiimaheeda ETB ahaan iyadoo loo eegayo qiimaha suuqa maxalliga ah.';

  @override
  String get payNaturalUnitsCrops =>
      'Sakada dalagga waxaa lagu bixiyaa goosashada. Waxaad bixin kartaa qiimaheeda ETB ahaan iyadoo loo eegayo qiimaha suuqa maxalliga ah.';

  @override
  String get payBeneficiary => 'Ka faa\'iideystaha (ikhtiyaari)';

  @override
  String get payProjectLabel => 'Mashruuca ka faa\'iideystayaasha';

  @override
  String get payGeneralFundZakat => 'Sanduuqa guud ee Sakada';

  @override
  String get payMethod => 'Habka lacag bixinta';

  @override
  String get paySecureSsl => 'SSL 256-BIT';

  @override
  String get paySecureBank => 'AMNI HEER BANGI';

  @override
  String get payImpactTitle => 'Saamaynta aad leedahay';

  @override
  String get payImpactBody =>
      'Tabarruc kasta waxaa si hufan loogu qaybiyaa barnaamijyada guddiga.';

  @override
  String get regStepIdentity => 'Aqoonsi';

  @override
  String get regStepNeeds => 'Baahiyaha';

  @override
  String get regStepVerify => 'Xaqiijin';

  @override
  String get regStepPayout => 'Lacag bixinta';

  @override
  String get regStepDetails => 'Faahfaahin';

  @override
  String get regStepPassword => 'Furaha sirta';

  @override
  String get regStepDocuments => 'Dukumentiyo';

  @override
  String get regEmailOptional => 'Iimayl (ikhtiyaari)';

  @override
  String get regSubmittedNoAccount =>
      'Diiwaangelinta waa la gudbiyay. Xisaab gelitaan lama abuurin sababtoo ah iimayl lama bixin.';

  @override
  String get loginIdentifierLabel => 'Lambarka taleefanka ama iimayl';

  @override
  String get loginIdentifierRequired =>
      'Geli lambarka taleefankaaga ama iimaylkaaga';

  @override
  String get loginIdentifierInvalid =>
      'Geli lambar taleefan sax ah (tusaale 0911223344) ama iimayl sax ah';

  @override
  String calcCamelBintMakhadN(int count) {
    return '$count bint makhad';
  }

  @override
  String calcCamelBintLabunN(int count) {
    return '$count bint labuun';
  }

  @override
  String calcCamelHiqqahN(int count) {
    return '$count xiqqaah';
  }

  @override
  String calcCamelJadhahN(int count) {
    return '$count jaadka';
  }

  @override
  String get calcNisabMetalGold => 'dahab (24k)';

  @override
  String get calcNisabMetalSilver => 'fiddo';

  @override
  String calcPricesAsOf(String date, String source) {
    return 'Qiimaha ilaa $date · $source';
  }

  @override
  String calcPricesAsOfNoSource(String date) {
    return 'Qiimaha ilaa $date';
  }

  @override
  String get calcPricesStale => 'Qiimaha waxaa laga yaabaa inuu duugoobay.';

  @override
  String get calcPricesSavedCopy =>
      'Lama cusbooneysiin karin qiimaha. Waxaa la tusayaa qiimaha lagu kaydiyay qalabkan.';

  @override
  String get calcConfigErrorTitle =>
      'Lama soo rarin karin qiimaha sakada maanta';

  @override
  String get calcConfigErrorBody => 'Hubi xiriirkaaga oo mar kale isku day.';

  @override
  String get calcConfigNotReadyBody =>
      'Qiimaha dahabka iyo fiddada weli lama hayo. Fadlan mar dambe isku day.';

  @override
  String get commonRetry => 'Mar kale isku day';

  @override
  String calcLivestockEstimateLine(String amount) {
    return 'Qiimaha suuqa ee la qiyaasay: $amount';
  }

  @override
  String get calcLivestockEstimateNote =>
      'Waxaa lagu qiyaasay celceliska qiimaha suuqa xoolaha midkiiba. Waad beddeli kartaa qadarka ka hor intaadan bixin.';

  @override
  String homeLiveCollected(String amount) {
    return 'TOOS · $amount ayaa la ururiyay';
  }

  @override
  String homeCollected(String amount) {
    return '$amount ayaa la ururiyay';
  }

  @override
  String homeChangeUp(String percent) {
    return '↑ $percent% marka la barbardhigo bishii hore';
  }

  @override
  String homeChangeDown(String percent) {
    return '↓ $percent% marka la barbardhigo bishii hore';
  }

  @override
  String get homeChangeFlat => 'La mid ah bishii hore';

  @override
  String get homeBeneficiariesSubtext => 'qoys';

  @override
  String get fitrStatusOpen => 'HADDA FURAN';

  @override
  String get fitrStatusClosed => 'XIRAN';

  @override
  String fitrStartsIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Wuxuu bilaabmayaa $days maalmood gudahood',
      one: 'Berri ayuu bilaabmayaa',
      zero: 'Maanta ayuu bilaabmayaa',
    );
    return '$_temp0';
  }

  @override
  String fitrDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days maalmood ayaa ka harsan bixinta',
      one: '1 maalin ayaa ka harsan bixinta',
      zero: 'Maanta waa maalinta ugu dambeysa ee bixinta',
    );
    return '$_temp0';
  }

  @override
  String fitrClosedOn(String date) {
    return 'Waxaa la xiray $date';
  }

  @override
  String fitrPerPerson(String amount) {
    return '$amount qofkiiba';
  }

  @override
  String get causesTitle => 'Mashaariicda';

  @override
  String get causesSubtitle => 'Mashaariicda sakadaadu taageerto';

  @override
  String get causesActive => 'Firfircoon';

  @override
  String get causesClosed => 'Xiran';

  @override
  String get causesAllCategories => 'Dhammaan';

  @override
  String get causeCategoryEducation => 'Waxbarasho';

  @override
  String get causeCategoryWater => 'Biyo';

  @override
  String get causeCategoryHealth => 'Caafimaad';

  @override
  String get causeCategoryFood => 'Cunto';

  @override
  String get causeCategoryShelter => 'Hoy';

  @override
  String get causeCategoryLivelihood => 'Nolol maalmeed';

  @override
  String get causeCategoryEmergency => 'Gurmad degdeg ah';

  @override
  String get causeCategoryGeneral => 'Guud';

  @override
  String get causeBadgeUrgent => 'DEGDEG';

  @override
  String get causeBadgeEssential => 'MUHIIM';

  @override
  String causeRaisedOfGoal(String raised, String goal) {
    return '$raised ayaa la ururiyay $goal kamid ah';
  }

  @override
  String causeRaised(String raised) {
    return '$raised ayaa la ururiyay';
  }

  @override
  String causeEndsOn(String date) {
    return 'Wuxuu dhammaanayaa $date';
  }

  @override
  String causeEndedOn(String date) {
    return 'Wuxuu dhammaaday $date';
  }

  @override
  String get causesEmpty => 'Weli ma jiraan mashaariic la muujiyo.';

  @override
  String get causesLoadError => 'Lama soo rarin karin mashaariicda.';

  @override
  String get causeNotFound => 'Mashruucan hadda lama heli karo.';

  @override
  String get causeAbout => 'Ku saabsan mashruucan';

  @override
  String get payProjectsLoading => 'Mashaariicda ayaa la soo rarayaa…';

  @override
  String impactAsOf(String date) {
    return 'Ilaa $date';
  }

  @override
  String get impactBeneficiariesByAsnaf => 'Ka-faa’iideystayaasha qaybaha';

  @override
  String impactRegionBeneficiaries(String count) {
    return '$count ka-faa’iideyste';
  }

  @override
  String impactRegionProjects(String count) {
    return '$count mashruuc';
  }

  @override
  String get impactShowNational => 'Muuji heerka qaranka';

  @override
  String get impactStoryNotFound => 'Sheekadan hadda lama heli karo.';

  @override
  String get impactStoryLoadError => 'Lama soo rarin karin sheekadan.';

  @override
  String impactPublishedOn(String date) {
    return 'La daabacay $date';
  }

  @override
  String get payNotAllowedBeneficiary =>
      'Xisaabaadka ka-faa’iideystayaashu sakada way helaan, ma bixiyaan. Ka bax si aad marti ahaan u bixiso.';

  @override
  String get payEnterAmount => 'Geli qadarka.';

  @override
  String payAmountOutOfRange(String min, String max) {
    return 'Geli qadar u dhexeeya $min iyo $max.';
  }

  @override
  String get payAccountNumberLabel => 'Lambarka xisaabta Coop Bank';

  @override
  String get payAccountNumberHelper =>
      'Xisaabta aad ka bixinayso. Waxaan ku tusi doonnaa magaca milkiilaha si aad u xaqiijiso.';

  @override
  String get payAccountNumberInvalid => 'Geli lambar xisaab sax ah (6–20 god).';

  @override
  String get payNetworkError =>
      'Xiriir ma jiro. Hubi internetkaaga oo mar kale isku day.';

  @override
  String get payMethodsLoading => 'Hababka lacag bixinta ayaa la soo rarayaa…';

  @override
  String get payMethodsError => 'Lama soo rarin karin hababka lacag bixinta.';

  @override
  String get payNoMethods =>
      'Hadda ma jiro hab lacag bixin ah oo la heli karo.';

  @override
  String get payMethodUnavailable => 'Weli lama heli karo';

  @override
  String get payCancelConfirmTitle => 'Ma joojinaysaa lacag bixintan?';

  @override
  String get payCancelConfirmBody =>
      'Lacag lagama jarin. Waad dib u bilaabi kartaa wakhti kasta.';

  @override
  String get payKeepPaying => 'Sii wad bixinta';

  @override
  String get payCancelPayment => 'Jooji lacag bixinta';

  @override
  String payForCause(String cause) {
    return 'Loogu talagalay: $cause';
  }

  @override
  String get payAccountHolder => 'Milkiilaha xisaabta';

  @override
  String get payAccountNumberShort => 'Xisaabta';

  @override
  String get payConfirmTitle => 'Xisaabtani ma taada baa?';

  @override
  String get payConfirmBody =>
      'Haddii ay tahay, Coop Bank waxay kood xaqiijin ah u diri doontaa taleefanka ku diiwaangashan xisaabtan.';

  @override
  String get payYesSendCode => 'Haa, dir koodka';

  @override
  String get payNotMyAccount => 'Ma aha xisaabtayda';

  @override
  String get payOtpTitle => 'Geli koodka xaqiijinta';

  @override
  String get payOtpBody =>
      'Waxaan kood 6 god ah u dirnay taleefanka ku diiwaangashan xisaabtaada Coop Bank.';

  @override
  String get payOtpLabel => 'Koodka xaqiijinta';

  @override
  String payOtpAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count isku day ayaa haray',
      one: '1 isku day ayaa haray',
    );
    return '$_temp0';
  }

  @override
  String get payResendCode => 'Dir kood cusub';

  @override
  String payPayAmount(String amount) {
    return 'Bixi $amount';
  }

  @override
  String get payProcessingTitle => 'Waxaan xaqiijinaynaa lacag bixintaada';

  @override
  String get payProcessingBody =>
      'Coop Bank weli kama jawaabin. Boggani si toos ah ayuu isu cusbooneysiiyaa; fadlan mar kale ha bixin.';

  @override
  String get payCheckAgain => 'Mar kale hubi';

  @override
  String get paySucceededTitle => 'Lacag bixintu way guulaysatay';

  @override
  String paySucceededBody(String amount) {
    return 'Sakadaadii $amount waa la bixiyay. Alle ha kaa aqbalo.';
  }

  @override
  String payReference(String reference) {
    return 'Tixraaca bangiga: $reference';
  }

  @override
  String get payViewCertificate => 'Eeg shahaadada';

  @override
  String get payDone => 'Dhammaad';

  @override
  String get payCancelledTitle => 'Lacag bixinta waa la joojiyay';

  @override
  String get payExpiredTitle => 'Waqtiga lacag bixintu wuu dhacay';

  @override
  String get payExpiredBody =>
      'Laguma dhammayn 15 daqiiqo gudahood. Lacag lagama jarin; fadlan dib u bilow.';

  @override
  String get payFailedTitle => 'Lacag bixintu ma dhammaystirmin';

  @override
  String get payNoMoneyTaken => 'Lacag lagama jarin.';

  @override
  String get payStartAgain => 'Dib u bilow';

  @override
  String get certTitle => 'Shahaadada sakada';

  @override
  String certNumber(String id) {
    return 'Shahaadada $id';
  }

  @override
  String get certSharePdf => 'Soo deji / wadaag PDF';

  @override
  String get certPdfError => 'Lama soo dejin karin shahaadada.';

  @override
  String get certLoadError => 'Lama soo rarin karin shahaadada.';

  @override
  String get certNotFound => 'Shahaadada lama helin.';

  @override
  String get certPayer => 'Bixiyaha';

  @override
  String get certType => 'Nooca sakada';

  @override
  String get certCause => 'Mashruuca';

  @override
  String get certNaturalUnits => 'Waajibka la xisaabiyay';

  @override
  String get certMethod => 'Habka';

  @override
  String get certReference => 'Tixraaca bangiga';

  @override
  String get certPaidAt => 'La bixiyay';

  @override
  String get certIssuedAt => 'La bixiyay (shahaado)';

  @override
  String get certHijriDate => 'Taariikhda Hijriga';

  @override
  String get certVerifyHint =>
      'Koodka QR ee PDF-ka ku yaal wuxuu qof kasta u oggolaanayaa inuu xaqiijiyo shahaadadan.';

  @override
  String get zakatTypeWealth => 'Hanti';

  @override
  String get zakatTypeLivestock => 'Xoolo';

  @override
  String get zakatTypeCrops => 'Dalag';

  @override
  String get zakatTypeGeneral => 'Sakada guud';

  @override
  String get historyTitle => 'Lacag bixinadayda sakada';

  @override
  String get historyEmpty => 'Weli lacag bixin ma jirto.';

  @override
  String get historyLoadError => 'Lama soo rarin karin lacag bixinadaada.';

  @override
  String get payStatusSucceeded => 'La bixiyay';

  @override
  String get payStatusPending => 'Socda';

  @override
  String get payStatusFailed => 'Fashilmay';

  @override
  String get payStatusCancelled => 'La joojiyay';

  @override
  String get payStatusExpired => 'Waqtigu wuu dhacay';

  @override
  String get fitrPayButton => 'Bixi Sakada Fitriga';

  @override
  String get fitrHouseholdTitle => 'Imisa qof ayaad u bixinaysaa?';

  @override
  String fitrHouseholdOf(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count qof',
      one: '1 qof',
    );
    return '$_temp0';
  }

  @override
  String fitrTotal(String amount) {
    return 'Wadarta: $amount';
  }

  @override
  String get profileCaseStatus => 'Kiiska';

  @override
  String get caseStatusSubmitted => 'La gudbiyay';

  @override
  String get caseStatusVerified => 'La xaqiijiyay';

  @override
  String get caseStatusApproved => 'La ansixiyay';

  @override
  String get caseStatusActive => 'Firfircoon — taageero helaya';

  @override
  String get caseStatusClosed => 'La xiray';

  @override
  String get impactComingSoonTitle => 'Xogta saamaynta dhowaan ayay imanaysaa';

  @override
  String get impactComingSoonBody =>
      'Boggani wuxuu muujin doonaa sida sakadu u gaarto bulshooyinka Itoobiya oo dhan.';

  @override
  String payFinishWithin(String time) {
    return 'Ku dhammee $time gudahood';
  }

  @override
  String payOtpExpiresIn(String time) {
    return 'Koodku wuxuu dhacayaa $time kadib';
  }

  @override
  String get payOtpExpiredLocal =>
      'Koodka waqtigiisii wuu dhacay. Dir mid cusub.';

  @override
  String get unfinishedPaymentTitle => 'Lacag bixin aan dhammaan';

  @override
  String get unfinishedPaymentContinue => 'Sii wad';

  @override
  String get payCheckStatus => 'Hubi xaaladda';

  @override
  String get recentPaymentsTitle => 'Lacag bixinada dhowaan qalabkan';

  @override
  String get recentPaymentsSubtitle =>
      'Sii wad lacag bixin aan dhammaan ama fur shahaado.';

  @override
  String get recentPaymentsEmpty => 'Weli lacag bixin kuma jirto qalabkan.';

  @override
  String get payOpenError => 'Lama furi karin lacag bixintan.';

  @override
  String get profileSectionPayoutAccount => 'Xisaabta lacag qaadashada';

  @override
  String get profileRoleBeneficiary => 'Ka-faa’iideyste';

  @override
  String get profileRoleDonor => 'Deeq-bixiye';

  @override
  String get profileVerificationVerified => 'La xaqiijiyay';

  @override
  String get profileVerificationPending => 'Dib-u-eegis ayaa socda';

  @override
  String get profileVerificationRejected => 'Lama ansixin';
}
