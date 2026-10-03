import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_om.dart';
import 'app_localizations_so.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('ar'),
    Locale('en'),
    Locale('om'),
    Locale('so'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat & Awqaf Commission'**
  String get appTitle;

  /// No description provided for @splashSlogan.
  ///
  /// In en, this message translates to:
  /// **'For the sake of Allah, for the service of humanity'**
  String get splashSlogan;

  /// No description provided for @splashWaqfByLabel.
  ///
  /// In en, this message translates to:
  /// **'A Waqf by'**
  String get splashWaqfByLabel;

  /// No description provided for @splashWaqfByTitle.
  ///
  /// In en, this message translates to:
  /// **'Coop Bank Alhuda'**
  String get splashWaqfByTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCalculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get navCalculator;

  /// No description provided for @navImpact.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get navImpact;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeCommissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat & Awqaf Commission'**
  String get homeCommissionTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Assalamu\'alaikum'**
  String get homeGreeting;

  /// No description provided for @registerAcceptZakat.
  ///
  /// In en, this message translates to:
  /// **'Register to Accept Zakat'**
  String get registerAcceptZakat;

  /// No description provided for @urgentBeneficiaryNeeds.
  ///
  /// In en, this message translates to:
  /// **'Urgent Causes'**
  String get urgentBeneficiaryNeeds;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all →'**
  String get viewAll;

  /// No description provided for @totalZakatCollected.
  ///
  /// In en, this message translates to:
  /// **'TOTAL ZAKAT COLLECTED'**
  String get totalZakatCollected;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @totalBeneficiariesSupported.
  ///
  /// In en, this message translates to:
  /// **'Total beneficiaries supported'**
  String get totalBeneficiariesSupported;

  /// No description provided for @transparencyQuote.
  ///
  /// In en, this message translates to:
  /// **'Transparent, accountable, and impactful: your giving powers nationwide relief and empowerment.'**
  String get transparencyQuote;

  /// No description provided for @payZakatCause.
  ///
  /// In en, this message translates to:
  /// **'Give Zakat'**
  String get payZakatCause;

  /// No description provided for @zakatAlFitr.
  ///
  /// In en, this message translates to:
  /// **'Zakat Al-Fitr'**
  String get zakatAlFitr;

  /// No description provided for @needQuickWayGive.
  ///
  /// In en, this message translates to:
  /// **'Quick Giving'**
  String get needQuickWayGive;

  /// No description provided for @supportCommunityNeeds.
  ///
  /// In en, this message translates to:
  /// **'Support ongoing community needs instantly with Sadaqah.'**
  String get supportCommunityNeeds;

  /// No description provided for @donateSadaqah.
  ///
  /// In en, this message translates to:
  /// **'Donate Sadaqah'**
  String get donateSadaqah;

  /// No description provided for @aboutCommission.
  ///
  /// In en, this message translates to:
  /// **'Ethiopian Zakat & Awqaf Commission'**
  String get aboutCommission;

  /// No description provided for @aboutCommissionBody.
  ///
  /// In en, this message translates to:
  /// **'Coordinating zakat collection and awqaf development to uplift vulnerable communities through transparent, Shariah-aligned programs across Ethiopia.'**
  String get aboutCommissionBody;

  /// No description provided for @chipTransparencyFirst.
  ///
  /// In en, this message translates to:
  /// **'Transparency-first'**
  String get chipTransparencyFirst;

  /// No description provided for @chipNationwideImpact.
  ///
  /// In en, this message translates to:
  /// **'Nationwide impact'**
  String get chipNationwideImpact;

  /// No description provided for @chipShariahAligned.
  ///
  /// In en, this message translates to:
  /// **'Shariah aligned'**
  String get chipShariahAligned;

  /// No description provided for @profileLanguagePreferences.
  ///
  /// In en, this message translates to:
  /// **'Language Preferences'**
  String get profileLanguagePreferences;

  /// No description provided for @profileThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileThemeMode;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @profileBiometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get profileBiometricLogin;

  /// No description provided for @profileBiometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face ID'**
  String get profileBiometricSubtitle;

  /// No description provided for @missingPaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Missing payment details.'**
  String get missingPaymentDetails;

  /// No description provided for @calcAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get calcAppBarTitle;

  /// No description provided for @calcPayYourZakat.
  ///
  /// In en, this message translates to:
  /// **'Pay Your Zakat'**
  String get calcPayYourZakat;

  /// No description provided for @calcTabWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get calcTabWealth;

  /// No description provided for @calcTabLivestock.
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get calcTabLivestock;

  /// No description provided for @calcTabCrops.
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get calcTabCrops;

  /// No description provided for @calcStep1NisabTitle.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Nisab threshold'**
  String get calcStep1NisabTitle;

  /// No description provided for @calcStep1NisabBody.
  ///
  /// In en, this message translates to:
  /// **'Zakat is due if your net wealth reaches the nisab: {grams} g of {metal} at today\'s price.'**
  String calcStep1NisabBody(String grams, String metal);

  /// No description provided for @calcNisabGoldFormula.
  ///
  /// In en, this message translates to:
  /// **'{grams} × {price} = {total}'**
  String calcNisabGoldFormula(String grams, String price, String total);

  /// No description provided for @calcNisabThresholdBanner.
  ///
  /// In en, this message translates to:
  /// **'Nisab threshold ({grams} g {metal}): {amount}'**
  String calcNisabThresholdBanner(String amount, String grams, String metal);

  /// No description provided for @calcStep1LivestockTitle.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Livestock scale method'**
  String get calcStep1LivestockTitle;

  /// No description provided for @calcStep1LivestockBody.
  ///
  /// In en, this message translates to:
  /// **'Livestock Zakat is calculated by physical head-count scales (not % of value).'**
  String get calcStep1LivestockBody;

  /// No description provided for @calcStep1LivestockNisabNote.
  ///
  /// In en, this message translates to:
  /// **'Nisab thresholds: Sheep/Goats {sheep}, Cattle {cattle}, Camels {camels}. Cattle uses {tabiPer}/{musinnahPer} combinations; camels follow tier ranges.'**
  String calcStep1LivestockNisabNote(
    int sheep,
    int cattle,
    int camels,
    int tabiPer,
    int musinnahPer,
  );

  /// No description provided for @calcAdvisoryPrefix.
  ///
  /// In en, this message translates to:
  /// **'Advisory: {text}'**
  String calcAdvisoryPrefix(String text);

  /// No description provided for @calcArabicTermDefinitionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Arabic Term Definitions'**
  String get calcArabicTermDefinitionsTitle;

  /// No description provided for @calcArabicDefTabi.
  ///
  /// In en, this message translates to:
  /// **'one-year-old calf'**
  String get calcArabicDefTabi;

  /// No description provided for @calcArabicDefMusinnah.
  ///
  /// In en, this message translates to:
  /// **'two-year-old cow'**
  String get calcArabicDefMusinnah;

  /// No description provided for @calcArabicDefBintMakhad.
  ///
  /// In en, this message translates to:
  /// **'one-year-old she-camel'**
  String get calcArabicDefBintMakhad;

  /// No description provided for @calcArabicDefBintLabun.
  ///
  /// In en, this message translates to:
  /// **'two-year-old she-camel'**
  String get calcArabicDefBintLabun;

  /// No description provided for @calcArabicDefHiqqah.
  ///
  /// In en, this message translates to:
  /// **'three-year-old she-camel'**
  String get calcArabicDefHiqqah;

  /// No description provided for @calcArabicDefJadhah.
  ///
  /// In en, this message translates to:
  /// **'four-year-old she-camel'**
  String get calcArabicDefJadhah;

  /// No description provided for @calcStep1CropTitle.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Crop (Ushr) calculation'**
  String get calcStep1CropTitle;

  /// No description provided for @calcStep1CropBody.
  ///
  /// In en, this message translates to:
  /// **'Crop Zakat is due at harvest. Nisab is {nisab}kg. Rate is {rainRate}% (rain-fed), {irrigatedRate}% (irrigated), or weighted for mixed.'**
  String calcStep1CropBody(String nisab, String rainRate, String irrigatedRate);

  /// No description provided for @calcCropLineThreshold.
  ///
  /// In en, this message translates to:
  /// **'{kg} kg {relation} 653 kg'**
  String calcCropLineThreshold(String kg, String relation);

  /// No description provided for @calcCropLineIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation mode: {mode}'**
  String calcCropLineIrrigation(String mode);

  /// No description provided for @calcCropLineEffectiveRate.
  ///
  /// In en, this message translates to:
  /// **'Effective rate: {rate}%'**
  String calcCropLineEffectiveRate(String rate);

  /// No description provided for @calcCropLineFormula.
  ///
  /// In en, this message translates to:
  /// **'Formula: {line}'**
  String calcCropLineFormula(String line);

  /// No description provided for @calcRelationGte.
  ///
  /// In en, this message translates to:
  /// **'≥'**
  String get calcRelationGte;

  /// No description provided for @calcRelationLt.
  ///
  /// In en, this message translates to:
  /// **'<'**
  String get calcRelationLt;

  /// No description provided for @calcOverviewNetWorthTitle.
  ///
  /// In en, this message translates to:
  /// **'Net Worth Overview'**
  String get calcOverviewNetWorthTitle;

  /// No description provided for @calcOverviewLivestockTitle.
  ///
  /// In en, this message translates to:
  /// **'Livestock Overview'**
  String get calcOverviewLivestockTitle;

  /// No description provided for @calcOverviewCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Overview'**
  String get calcOverviewCropTitle;

  /// No description provided for @calcBadgeAboveNisab.
  ///
  /// In en, this message translates to:
  /// **'Above Nisab'**
  String get calcBadgeAboveNisab;

  /// No description provided for @calcBadgeBelowNisab.
  ///
  /// In en, this message translates to:
  /// **'Below Nisab'**
  String get calcBadgeBelowNisab;

  /// No description provided for @calcBadgeZakatDue.
  ///
  /// In en, this message translates to:
  /// **'Zakat Due'**
  String get calcBadgeZakatDue;

  /// No description provided for @calcBadgeNoDue.
  ///
  /// In en, this message translates to:
  /// **'No Due'**
  String get calcBadgeNoDue;

  /// No description provided for @calcZakatDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Zakat Due'**
  String get calcZakatDueLabel;

  /// No description provided for @calcLivestockDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Livestock Due'**
  String get calcLivestockDueLabel;

  /// No description provided for @calcCropZakatDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Crop Zakat Due'**
  String get calcCropZakatDueLabel;

  /// No description provided for @calcAnimalsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} animals'**
  String calcAnimalsCount(int count);

  /// No description provided for @calcKgHarvest.
  ///
  /// In en, this message translates to:
  /// **'{kg} kg harvest'**
  String calcKgHarvest(String kg);

  /// No description provided for @calcLivestockTermsFootnote.
  ///
  /// In en, this message translates to:
  /// **'Terms like tabi\', musinnah, bint makhad, bint labun, hiqqah, and jadhah are explained below in Livestock details.'**
  String get calcLivestockTermsFootnote;

  /// No description provided for @calcStep2EnterAssets.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Enter Your Assets'**
  String get calcStep2EnterAssets;

  /// No description provided for @calcStep2EnterAssetsBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the value of your assets in ETB'**
  String get calcStep2EnterAssetsBody;

  /// No description provided for @calcCashBankSavings.
  ///
  /// In en, this message translates to:
  /// **'Cash & Bank Savings'**
  String get calcCashBankSavings;

  /// No description provided for @calcCashOnHand.
  ///
  /// In en, this message translates to:
  /// **'Cash on Hand'**
  String get calcCashOnHand;

  /// No description provided for @calcBankBalance.
  ///
  /// In en, this message translates to:
  /// **'Bank Balance'**
  String get calcBankBalance;

  /// No description provided for @calcMobileWallet.
  ///
  /// In en, this message translates to:
  /// **'Mobile Wallet'**
  String get calcMobileWallet;

  /// No description provided for @calcBusinessAssets.
  ///
  /// In en, this message translates to:
  /// **'Business Assets'**
  String get calcBusinessAssets;

  /// No description provided for @calcFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get calcFieldDescription;

  /// No description provided for @calcFieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get calcFieldType;

  /// No description provided for @calcAmountEtb.
  ///
  /// In en, this message translates to:
  /// **'Amount (ETB)'**
  String get calcAmountEtb;

  /// No description provided for @calcAddBusinessAsset.
  ///
  /// In en, this message translates to:
  /// **'Add business asset'**
  String get calcAddBusinessAsset;

  /// No description provided for @calcGoldSilver.
  ///
  /// In en, this message translates to:
  /// **'Gold & Silver'**
  String get calcGoldSilver;

  /// No description provided for @calcGoldGrams.
  ///
  /// In en, this message translates to:
  /// **'Gold (grams)'**
  String get calcGoldGrams;

  /// No description provided for @calcGoldKarat.
  ///
  /// In en, this message translates to:
  /// **'Gold Karat'**
  String get calcGoldKarat;

  /// No description provided for @calcSilverGrams.
  ///
  /// In en, this message translates to:
  /// **'Silver (grams)'**
  String get calcSilverGrams;

  /// No description provided for @calcLiabilities.
  ///
  /// In en, this message translates to:
  /// **'Liabilities'**
  String get calcLiabilities;

  /// No description provided for @calcAddLiability.
  ///
  /// In en, this message translates to:
  /// **'Add liability'**
  String get calcAddLiability;

  /// No description provided for @calcAssetInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get calcAssetInventory;

  /// No description provided for @calcAssetReceivable.
  ///
  /// In en, this message translates to:
  /// **'Receivable'**
  String get calcAssetReceivable;

  /// No description provided for @calcAssetOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get calcAssetOther;

  /// No description provided for @calcLiabilityShortTermDebt.
  ///
  /// In en, this message translates to:
  /// **'Short-term debt'**
  String get calcLiabilityShortTermDebt;

  /// No description provided for @calcLiabilityPayable.
  ///
  /// In en, this message translates to:
  /// **'Payable'**
  String get calcLiabilityPayable;

  /// No description provided for @calcLiabilityOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get calcLiabilityOther;

  /// No description provided for @calcLivestockSheepGoats.
  ///
  /// In en, this message translates to:
  /// **'Sheep / Goats'**
  String get calcLivestockSheepGoats;

  /// No description provided for @calcLivestockCattle.
  ///
  /// In en, this message translates to:
  /// **'Cattle'**
  String get calcLivestockCattle;

  /// No description provided for @calcLivestockCamels.
  ///
  /// In en, this message translates to:
  /// **'Camels'**
  String get calcLivestockCamels;

  /// No description provided for @calcPastureFedTitle.
  ///
  /// In en, this message translates to:
  /// **'Pasture-fed most of the year'**
  String get calcPastureFedTitle;

  /// No description provided for @calcPastureFedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advisory only; does not block calculation'**
  String get calcPastureFedSubtitle;

  /// No description provided for @calcHawlTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed one lunar year (hawl)'**
  String get calcHawlTitle;

  /// No description provided for @calcHawlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advisory only; does not block calculation'**
  String get calcHawlSubtitle;

  /// No description provided for @calcWorkAnimalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Used for work (plowing/transport)'**
  String get calcWorkAnimalsTitle;

  /// No description provided for @calcWorkAnimalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advisory only; does not block calculation'**
  String get calcWorkAnimalsSubtitle;

  /// No description provided for @calcLivestockSummaryHeading.
  ///
  /// In en, this message translates to:
  /// **'Livestock summary'**
  String get calcLivestockSummaryHeading;

  /// No description provided for @calcCropNisabHeading.
  ///
  /// In en, this message translates to:
  /// **'Nisab & crop due'**
  String get calcCropNisabHeading;

  /// No description provided for @calcEffectiveCropRateLine.
  ///
  /// In en, this message translates to:
  /// **'Effective crop rate: {percent}%'**
  String calcEffectiveCropRateLine(String percent);

  /// No description provided for @calcCropZakatDueKgLine.
  ///
  /// In en, this message translates to:
  /// **'Crop Zakat due: {kg} kg'**
  String calcCropZakatDueKgLine(String kg);

  /// No description provided for @calcHowCropZakatWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How crop Zakat works'**
  String get calcHowCropZakatWorksTitle;

  /// No description provided for @calcHowCropZakatWorksBody.
  ///
  /// In en, this message translates to:
  /// **'Nisab: {nisab}kg. Rates: rain-fed {rainRate}%, irrigated {irrigatedRate}%, mixed = weighted split. Zakat is due at harvest (no annual hawl for crops).'**
  String calcHowCropZakatWorksBody(
    String nisab,
    String rainRate,
    String irrigatedRate,
  );

  /// No description provided for @calcHowCropZakatNote.
  ///
  /// In en, this message translates to:
  /// **'Note: App applies these rules broadly for simplicity. Scholarly positions differ on crop-type scope and expense deductions; consult qualified scholars for specific cases.'**
  String get calcHowCropZakatNote;

  /// No description provided for @calcWealthNisabHeading.
  ///
  /// In en, this message translates to:
  /// **'Nisab & wealth Zakat'**
  String get calcWealthNisabHeading;

  /// No description provided for @calcWealthNisabLine.
  ///
  /// In en, this message translates to:
  /// **'Nisab threshold: {nisab}'**
  String calcWealthNisabLine(String nisab);

  /// No description provided for @calcWealthZakatDueLine.
  ///
  /// In en, this message translates to:
  /// **'Wealth Zakat due (smaller amount on the card): {due}'**
  String calcWealthZakatDueLine(String due);

  /// No description provided for @calcHowWealthZakatWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How wealth Zakat is calculated'**
  String get calcHowWealthZakatWorksTitle;

  /// No description provided for @calcHowWealthZakatNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Scholars differ on which assets are zakatable, how debts discount wealth, when the lunar year (hawl) applies, and other details. This screen is an educational estimate—confirm your situation with qualified scholars.'**
  String get calcHowWealthZakatNote;

  /// No description provided for @calcWealthBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'How the amounts above are calculated'**
  String get calcWealthBreakdownTitle;

  /// No description provided for @calcWealthTransLiquidsLine.
  ///
  /// In en, this message translates to:
  /// **'Cash + bank + mobile: {cash} + {bank} + {mobile} = {subtotal}'**
  String calcWealthTransLiquidsLine(
    String cash,
    String bank,
    String mobile,
    String subtotal,
  );

  /// No description provided for @calcWealthTransBusinessLine.
  ///
  /// In en, this message translates to:
  /// **'Business assets (sum of rows): {business}'**
  String calcWealthTransBusinessLine(String business);

  /// No description provided for @calcWealthTransRollupLine.
  ///
  /// In en, this message translates to:
  /// **'Total assets: {liquids} + {business} + {gold} + {silver} = {total}'**
  String calcWealthTransRollupLine(
    String liquids,
    String business,
    String gold,
    String silver,
    String total,
  );

  /// No description provided for @calcWealthTransNisabLine.
  ///
  /// In en, this message translates to:
  /// **'Nisab: {grams} g {metal} × {price}/g = {nisab}'**
  String calcWealthTransNisabLine(
    String grams,
    String metal,
    String price,
    String nisab,
  );

  /// No description provided for @calcWealthTransGoldLine.
  ///
  /// In en, this message translates to:
  /// **'Gold: {grams} g × {karat} ({price}/g) = {value}'**
  String calcWealthTransGoldLine(
    String grams,
    String karat,
    String price,
    String value,
  );

  /// No description provided for @calcWealthTransSilverLine.
  ///
  /// In en, this message translates to:
  /// **'Silver: {grams} g × {rate} ETB/g = {value}'**
  String calcWealthTransSilverLine(String grams, String rate, String value);

  /// No description provided for @calcWealthTransNetLine.
  ///
  /// In en, this message translates to:
  /// **'Net wealth (large amount on the card): total assets − liabilities ({liabilities}) = {net}'**
  String calcWealthTransNetLine(String liabilities, String net);

  /// No description provided for @calcWealthTransDueAbove.
  ///
  /// In en, this message translates to:
  /// **'Because {net} is at or above nisab ({nisab}), Zakat due = {net} × {rate}% = {due}.'**
  String calcWealthTransDueAbove(
    String net,
    String due,
    String nisab,
    String rate,
  );

  /// No description provided for @calcWealthTransDueBelow.
  ///
  /// In en, this message translates to:
  /// **'Because {net} is below nisab ({nisab}), wealth Zakat due = {due}.'**
  String calcWealthTransDueBelow(String net, String nisab, String due);

  /// No description provided for @calcCropWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Crop Weight (kg)'**
  String get calcCropWeightKg;

  /// No description provided for @calcCropModeRainFed.
  ///
  /// In en, this message translates to:
  /// **'Rain-fed'**
  String get calcCropModeRainFed;

  /// No description provided for @calcCropModeIrrigated.
  ///
  /// In en, this message translates to:
  /// **'Irrigated'**
  String get calcCropModeIrrigated;

  /// No description provided for @calcCropModeMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get calcCropModeMixed;

  /// No description provided for @calcRainFedSharePct.
  ///
  /// In en, this message translates to:
  /// **'Rain-fed share %'**
  String get calcRainFedSharePct;

  /// No description provided for @calcIrrigatedSharePct.
  ///
  /// In en, this message translates to:
  /// **'Irrigated share %'**
  String get calcIrrigatedSharePct;

  /// No description provided for @calcGoldK24.
  ///
  /// In en, this message translates to:
  /// **'24k'**
  String get calcGoldK24;

  /// No description provided for @calcGoldK22.
  ///
  /// In en, this message translates to:
  /// **'22k'**
  String get calcGoldK22;

  /// No description provided for @calcGoldK21.
  ///
  /// In en, this message translates to:
  /// **'21k'**
  String get calcGoldK21;

  /// No description provided for @calcGoldK18.
  ///
  /// In en, this message translates to:
  /// **'18k'**
  String get calcGoldK18;

  /// No description provided for @calcGoldK14.
  ///
  /// In en, this message translates to:
  /// **'14k'**
  String get calcGoldK14;

  /// No description provided for @calcMethodologyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Zakat methodology content placeholder.'**
  String get calcMethodologyPlaceholder;

  /// No description provided for @calcCertCropDueLine.
  ///
  /// In en, this message translates to:
  /// **'Crop Zakat due: {kg} kg'**
  String calcCertCropDueLine(String kg);

  /// No description provided for @calcBulletSeparator.
  ///
  /// In en, this message translates to:
  /// **' • '**
  String get calcBulletSeparator;

  /// No description provided for @calcLsSheepGoats.
  ///
  /// In en, this message translates to:
  /// **'Sheep/Goats: {count} sheep'**
  String calcLsSheepGoats(int count);

  /// No description provided for @calcLsCattle.
  ///
  /// In en, this message translates to:
  /// **'Cattle: {tabi} tabi\' + {musinnah} musinnah'**
  String calcLsCattle(int tabi, int musinnah);

  /// No description provided for @calcLsCamels.
  ///
  /// In en, this message translates to:
  /// **'Camels: {description}'**
  String calcLsCamels(String description);

  /// No description provided for @calcLsNone.
  ///
  /// In en, this message translates to:
  /// **'No livestock due under current counts'**
  String get calcLsNone;

  /// No description provided for @calcTransSheep.
  ///
  /// In en, this message translates to:
  /// **'Sheep/Goats threshold: {head} >= {min} => due {due} sheep.'**
  String calcTransSheep(int head, int due, int min);

  /// No description provided for @calcTransCattle.
  ///
  /// In en, this message translates to:
  /// **'Cattle threshold: {head} >= {min} => due {tabi} tabi\', {musinnah} musinnah ({tabiPer}/{musinnahPer} combination).'**
  String calcTransCattle(
    int head,
    int tabi,
    int musinnah,
    int min,
    int tabiPer,
    int musinnahPer,
  );

  /// No description provided for @calcTransCamel.
  ///
  /// In en, this message translates to:
  /// **'Camel threshold: {head} >= {min} => due {due}.'**
  String calcTransCamel(int head, String due, int min);

  /// No description provided for @calcTransAdvisoryLine.
  ///
  /// In en, this message translates to:
  /// **'Advisory: {text}'**
  String calcTransAdvisoryLine(String text);

  /// No description provided for @calcAdvNotPasture.
  ///
  /// In en, this message translates to:
  /// **'Not pasture-fed most of the year: check trade/business treatment with scholars.'**
  String get calcAdvNotPasture;

  /// No description provided for @calcAdvHawl.
  ///
  /// In en, this message translates to:
  /// **'Hawl not completed: many scholars require one lunar year for livestock zakat.'**
  String get calcAdvHawl;

  /// No description provided for @calcAdvWork.
  ///
  /// In en, this message translates to:
  /// **'Work animals are typically exempt from livestock zakat.'**
  String get calcAdvWork;

  /// No description provided for @calcCropTransBelow.
  ///
  /// In en, this message translates to:
  /// **'Harvest {kg}kg is below Nisab ({nisab} kg), so no crop Zakat is due.'**
  String calcCropTransBelow(String kg, String nisab);

  /// No description provided for @calcCropTransMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed irrigation: rain {rain}%, irrigated {irrig}%. Effective rate = {rate}%. Formula: {kg} × {rate2}% = {due}kg.'**
  String calcCropTransMixed(
    String rain,
    String irrig,
    String rate,
    String kg,
    String rate2,
    String due,
  );

  /// No description provided for @calcCropTransRainFed.
  ///
  /// In en, this message translates to:
  /// **'Rain-fed rate {rate}%. Formula: {kg} × {rate2}% = {due}kg.'**
  String calcCropTransRainFed(String rate, String kg, String rate2, String due);

  /// No description provided for @calcCropTransIrrigated.
  ///
  /// In en, this message translates to:
  /// **'Irrigated rate {rate}%. Formula: {kg} × {rate2}% = {due}kg.'**
  String calcCropTransIrrigated(
    String rate,
    String kg,
    String rate2,
    String due,
  );

  /// No description provided for @calcCamelNoDue.
  ///
  /// In en, this message translates to:
  /// **'No due'**
  String get calcCamelNoDue;

  /// No description provided for @calcCamelSheepN.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 sheep} other{{count} sheep}}'**
  String calcCamelSheepN(int count);

  /// No description provided for @profileLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load your profile'**
  String get profileLoadErrorTitle;

  /// No description provided for @profileTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get profileTryAgain;

  /// No description provided for @profileSectionBeneficiaryInsights.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary Insights'**
  String get profileSectionBeneficiaryInsights;

  /// No description provided for @profileSectionPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profileSectionPersonalInformation;

  /// No description provided for @profileSectionSpiritualSettings.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Settings'**
  String get profileSectionSpiritualSettings;

  /// No description provided for @profileSectionCoreActions.
  ///
  /// In en, this message translates to:
  /// **'Core Actions'**
  String get profileSectionCoreActions;

  /// No description provided for @profileSectionSettingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Settings & Security'**
  String get profileSectionSettingsSecurity;

  /// No description provided for @profileSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profileSectionSupport;

  /// No description provided for @profileNoNewNotifications.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get profileNoNewNotifications;

  /// No description provided for @profileVerificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get profileVerificationStatus;

  /// No description provided for @profileApplicationStatus.
  ///
  /// In en, this message translates to:
  /// **'Application Status'**
  String get profileApplicationStatus;

  /// No description provided for @profileLastDisbursement.
  ///
  /// In en, this message translates to:
  /// **'Last Disbursement'**
  String get profileLastDisbursement;

  /// No description provided for @profileTotalAidReceived.
  ///
  /// In en, this message translates to:
  /// **'Total Aid Received'**
  String get profileTotalAidReceived;

  /// No description provided for @profileEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get profileEmailAddress;

  /// No description provided for @profilePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profilePhoneNumber;

  /// No description provided for @profileEditFieldComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit {field} coming soon'**
  String profileEditFieldComingSoon(String field);

  /// No description provided for @profileNisabThresholdAlerts.
  ///
  /// In en, this message translates to:
  /// **'Nisab Threshold Alerts'**
  String get profileNisabThresholdAlerts;

  /// No description provided for @profileNisabThresholdAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify when wealth reaches threshold'**
  String get profileNisabThresholdAlertsSubtitle;

  /// No description provided for @profileChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get profileChangePin;

  /// No description provided for @profileChangePinComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Change PIN coming soon'**
  String get profileChangePinComingSoon;

  /// No description provided for @profileMyZakatHistory.
  ///
  /// In en, this message translates to:
  /// **'My Zakat History'**
  String get profileMyZakatHistory;

  /// No description provided for @profileMyZakatHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View ledger & certificates'**
  String get profileMyZakatHistorySubtitle;

  /// No description provided for @profileMyAwqafEndowments.
  ///
  /// In en, this message translates to:
  /// **'My Awqaf Endowments'**
  String get profileMyAwqafEndowments;

  /// No description provided for @profileMyAwqafEndowmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View schools & wells'**
  String get profileMyAwqafEndowmentsSubtitle;

  /// No description provided for @profileBeneficiaryApplication.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary Application'**
  String get profileBeneficiaryApplication;

  /// No description provided for @profileApplyAsBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Apply as Beneficiary'**
  String get profileApplyAsBeneficiary;

  /// No description provided for @profileBeneficiaryApplicationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Submit or track aid requests'**
  String get profileBeneficiaryApplicationSubtitle;

  /// No description provided for @profileApplyAsBeneficiarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register to receive aid'**
  String get profileApplyAsBeneficiarySubtitle;

  /// No description provided for @profileDonationHistory.
  ///
  /// In en, this message translates to:
  /// **'Donation History'**
  String get profileDonationHistory;

  /// No description provided for @profileDonationHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'See every contribution'**
  String get profileDonationHistorySubtitle;

  /// No description provided for @profileDonationHistoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Donation history coming soon'**
  String get profileDonationHistoryComingSoon;

  /// No description provided for @profileHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get profileHelpCenter;

  /// No description provided for @profileHelpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs and guidance'**
  String get profileHelpCenterSubtitle;

  /// No description provided for @profileHelpCenterComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Help center coming soon'**
  String get profileHelpCenterComingSoon;

  /// No description provided for @profileSupportAndGrievances.
  ///
  /// In en, this message translates to:
  /// **'Support & Grievances'**
  String get profileSupportAndGrievances;

  /// No description provided for @profileSupportAndGrievancesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to our team'**
  String get profileSupportAndGrievancesSubtitle;

  /// No description provided for @profileSupportCenterComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Support center coming soon'**
  String get profileSupportCenterComingSoon;

  /// No description provided for @profileLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOut;

  /// No description provided for @profileLogOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'End your current session'**
  String get profileLogOutSubtitle;

  /// No description provided for @profileLogOutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get profileLogOutDialogTitle;

  /// No description provided for @profileLogOutDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You will be signed out of the app on this device.'**
  String get profileLogOutDialogBody;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your registered phone number or email and your password'**
  String get loginSubtitle;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @loginSecureNote.
  ///
  /// In en, this message translates to:
  /// **'Your sign-in is encrypted and secure'**
  String get loginSecureNote;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordRequired;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileHadithOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Hadith of the Day'**
  String get profileHadithOfTheDay;

  /// No description provided for @profileHadithQuote.
  ///
  /// In en, this message translates to:
  /// **'\"The believer\'s shade on the Day of Resurrection will be his charity.\"'**
  String get profileHadithQuote;

  /// No description provided for @profileHadithSource.
  ///
  /// In en, this message translates to:
  /// **'— At-Tirmidhi'**
  String get profileHadithSource;

  /// No description provided for @impactNationalImpact.
  ///
  /// In en, this message translates to:
  /// **'National Impact'**
  String get impactNationalImpact;

  /// No description provided for @impactNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get impactNotifications;

  /// No description provided for @impactCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load national impact'**
  String get impactCouldNotLoad;

  /// No description provided for @impactGeographicReach.
  ///
  /// In en, this message translates to:
  /// **'Geographic Reach'**
  String get impactGeographicReach;

  /// No description provided for @impactBarakaStories.
  ///
  /// In en, this message translates to:
  /// **'Baraka Stories'**
  String get impactBarakaStories;

  /// No description provided for @impactLiveImpactStream.
  ///
  /// In en, this message translates to:
  /// **'LIVE IMPACT STREAM'**
  String get impactLiveImpactStream;

  /// No description provided for @impactDistributedFunds.
  ///
  /// In en, this message translates to:
  /// **'DISTRIBUTED FUNDS'**
  String get impactDistributedFunds;

  /// No description provided for @impactEtbAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} ETB'**
  String impactEtbAmount(String amount);

  /// No description provided for @impactLivesTouched.
  ///
  /// In en, this message translates to:
  /// **'LIVES TOUCHED'**
  String get impactLivesTouched;

  /// No description provided for @impactActiveProjects.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE PROJECTS'**
  String get impactActiveProjects;

  /// No description provided for @impactTapRegionHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a region to see local impact'**
  String get impactTapRegionHint;

  /// No description provided for @impactSeeYourPersonalBaraka.
  ///
  /// In en, this message translates to:
  /// **'See Your Personal Baraka'**
  String get impactSeeYourPersonalBaraka;

  /// No description provided for @impactTrackStewardship.
  ///
  /// In en, this message translates to:
  /// **'Track every cent of your stewardship.'**
  String get impactTrackStewardship;

  /// No description provided for @impactViewMyHistory.
  ///
  /// In en, this message translates to:
  /// **'View My History'**
  String get impactViewMyHistory;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingTitleFaithAndPurpose.
  ///
  /// In en, this message translates to:
  /// **'Faith with Purpose'**
  String get onboardingTitleFaithAndPurpose;

  /// No description provided for @onboardingSubtitleFaithAndPurpose.
  ///
  /// In en, this message translates to:
  /// **'Welcome to a trusted platform for Zakat and Awqaf stewardship.'**
  String get onboardingSubtitleFaithAndPurpose;

  /// No description provided for @onboardingTitleTransparentGiving.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get onboardingTitleTransparentGiving;

  /// No description provided for @onboardingSubtitleTransparentGiving.
  ///
  /// In en, this message translates to:
  /// **'Calculate your Zakat instantly across wealth, livestock, and crops with clear guidance.'**
  String get onboardingSubtitleTransparentGiving;

  /// No description provided for @onboardingTitleEasyPayments.
  ///
  /// In en, this message translates to:
  /// **'Fast, Simple Payments'**
  String get onboardingTitleEasyPayments;

  /// No description provided for @onboardingSubtitleEasyPayments.
  ///
  /// In en, this message translates to:
  /// **'Pay Zakat quickly with a smooth, secure, mobile-first experience.'**
  String get onboardingSubtitleEasyPayments;

  /// No description provided for @onboardingTitleCompassionInAction.
  ///
  /// In en, this message translates to:
  /// **'Compassion in Action'**
  String get onboardingTitleCompassionInAction;

  /// No description provided for @onboardingSubtitleCompassionInAction.
  ///
  /// In en, this message translates to:
  /// **'Support beneficiaries and projects with clarity, trust, and baraka.'**
  String get onboardingSubtitleCompassionInAction;

  /// No description provided for @donationCurrencySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you like to give?'**
  String get donationCurrencySheetTitle;

  /// No description provided for @donationCurrencySheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose local ETB payment or international card payment.'**
  String get donationCurrencySheetSubtitle;

  /// No description provided for @donationInternationalPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'International payment'**
  String get donationInternationalPaymentTitle;

  /// No description provided for @donationInternationalPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay from anywhere with your card and billing address.'**
  String get donationInternationalPaymentSubtitle;

  /// No description provided for @donationInternationalTitle.
  ///
  /// In en, this message translates to:
  /// **'International Sadaqah'**
  String get donationInternationalTitle;

  /// No description provided for @donationInternationalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support communities from anywhere in the world.'**
  String get donationInternationalSubtitle;

  /// No description provided for @donationAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Donation amount'**
  String get donationAmountLabel;

  /// No description provided for @donationAmountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get donationAmountHint;

  /// No description provided for @donationAmountHelper.
  ///
  /// In en, this message translates to:
  /// **'Amount is settled in Ethiopian Birr (ETB).'**
  String get donationAmountHelper;

  /// No description provided for @donationAnonymousLabel.
  ///
  /// In en, this message translates to:
  /// **'Give anonymously'**
  String get donationAnonymousLabel;

  /// No description provided for @donationAnonymousSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your name will not be shown publicly.'**
  String get donationAnonymousSubtitle;

  /// No description provided for @donationDonorSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get donationDonorSectionTitle;

  /// No description provided for @donationFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get donationFullNameLabel;

  /// No description provided for @donationPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get donationPhoneLabel;

  /// No description provided for @donationEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get donationEmailLabel;

  /// No description provided for @donationBillingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Billing address'**
  String get donationBillingSectionTitle;

  /// No description provided for @donationAddress1Label.
  ///
  /// In en, this message translates to:
  /// **'Address line 1'**
  String get donationAddress1Label;

  /// No description provided for @donationAddress2Label.
  ///
  /// In en, this message translates to:
  /// **'Address line 2 (optional)'**
  String get donationAddress2Label;

  /// No description provided for @donationCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get donationCountryLabel;

  /// No description provided for @donationCountryOther.
  ///
  /// In en, this message translates to:
  /// **'Country name'**
  String get donationCountryOther;

  /// No description provided for @donationAdminAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'State / Province'**
  String get donationAdminAreaLabel;

  /// No description provided for @donationLocalityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get donationLocalityLabel;

  /// No description provided for @donationPostalCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get donationPostalCodeLabel;

  /// No description provided for @donationContinueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get donationContinueToPayment;

  /// No description provided for @donationSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get donationSubmitting;

  /// No description provided for @donationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your Sadaqah.'**
  String get donationSuccess;

  /// No description provided for @donationValidationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number in international format (e.g. +15551234567).'**
  String get donationValidationPhone;

  /// No description provided for @donationPaymentWebViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete payment'**
  String get donationPaymentWebViewTitle;

  /// No description provided for @donationSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get donationSelectCountry;

  /// No description provided for @donationSearchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search countries'**
  String get donationSearchCountry;

  /// No description provided for @donationSelectState.
  ///
  /// In en, this message translates to:
  /// **'Select state / province'**
  String get donationSelectState;

  /// No description provided for @donationSearchState.
  ///
  /// In en, this message translates to:
  /// **'Search by name or abbreviation'**
  String get donationSearchState;

  /// No description provided for @donationNoMatchesFound.
  ///
  /// In en, this message translates to:
  /// **'No matches found'**
  String get donationNoMatchesFound;

  /// No description provided for @changeAppModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change mode'**
  String get changeAppModeTooltip;

  /// No description provided for @switchedToAwqafMode.
  ///
  /// In en, this message translates to:
  /// **'Switched to Awqaf mode'**
  String get switchedToAwqafMode;

  /// No description provided for @switchToAwqaf.
  ///
  /// In en, this message translates to:
  /// **'Switch to Awqaf'**
  String get switchToAwqaf;

  /// No description provided for @switchedToZakatMode.
  ///
  /// In en, this message translates to:
  /// **'Switched to Zakat mode'**
  String get switchedToZakatMode;

  /// No description provided for @switchToZakat.
  ///
  /// In en, this message translates to:
  /// **'Switch to Zakat'**
  String get switchToZakat;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginForgotPasswordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Forgot password coming soon'**
  String get loginForgotPasswordComingSoon;

  /// No description provided for @loginNewToBaraka.
  ///
  /// In en, this message translates to:
  /// **'New to Baraka? '**
  String get loginNewToBaraka;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get loginCreateAccount;

  /// No description provided for @loginCreateAccountComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Create account coming soon'**
  String get loginCreateAccountComingSoon;

  /// No description provided for @profileDisbursementIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose where you want to receive disbursements.'**
  String get profileDisbursementIntro;

  /// No description provided for @profileCoopAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Coop Bank Account Number'**
  String get profileCoopAccountLabel;

  /// No description provided for @profileCoopAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your account number'**
  String get profileCoopAccountHint;

  /// No description provided for @profileCoopAccountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Coop Bank account number.'**
  String get profileCoopAccountRequired;

  /// No description provided for @profileSaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Save Account'**
  String get profileSaveAccount;

  /// No description provided for @faydaIdentityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity verification'**
  String get faydaIdentityVerification;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get commonFinish;

  /// No description provided for @commonTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get commonTakePhoto;

  /// No description provided for @commonChooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get commonChooseGallery;

  /// No description provided for @commonChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get commonChooseFile;

  /// No description provided for @regTitle.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary Registration'**
  String get regTitle;

  /// No description provided for @regMethodFastTrack.
  ///
  /// In en, this message translates to:
  /// **'Fast-Track with Fayda'**
  String get regMethodFastTrack;

  /// No description provided for @regMethodManual.
  ///
  /// In en, this message translates to:
  /// **'Manual Registration'**
  String get regMethodManual;

  /// No description provided for @regMethodInstitution.
  ///
  /// In en, this message translates to:
  /// **'Institution Registration'**
  String get regMethodInstitution;

  /// No description provided for @regMethodFastTrackDesc.
  ///
  /// In en, this message translates to:
  /// **'Securely verify identity with National ID and continue in minutes.'**
  String get regMethodFastTrackDesc;

  /// No description provided for @regMethodManualDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your information and supporting details for trusted review.'**
  String get regMethodManualDesc;

  /// No description provided for @regMethodInstitutionDesc.
  ///
  /// In en, this message translates to:
  /// **'Register your organization and submit required compliance documents.'**
  String get regMethodInstitutionDesc;

  /// No description provided for @regSecureIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure Identity Verification'**
  String get regSecureIdentityTitle;

  /// No description provided for @regChooseMethodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred registration method to begin your journey.'**
  String get regChooseMethodSubtitle;

  /// No description provided for @regFastTrackFaydaTitle.
  ///
  /// In en, this message translates to:
  /// **'Fast-Track with National ID (Fayda)'**
  String get regFastTrackFaydaTitle;

  /// No description provided for @regFastTrackFaydaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Authenticate using your national digital ID.'**
  String get regFastTrackFaydaSubtitle;

  /// No description provided for @regManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual Registration'**
  String get regManualTitle;

  /// No description provided for @regManualSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload supporting documentation for review.'**
  String get regManualSubtitle;

  /// No description provided for @regInstitutionCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Register as Institution'**
  String get regInstitutionCardTitle;

  /// No description provided for @regInstitutionCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Company, NGO, cooperative, or government entity.'**
  String get regInstitutionCardSubtitle;

  /// No description provided for @regRegistrationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Registration code'**
  String get regRegistrationCodeLabel;

  /// No description provided for @regRegistrationCodeHint.
  ///
  /// In en, this message translates to:
  /// **'EZW-A1B2-C3D4'**
  String get regRegistrationCodeHint;

  /// No description provided for @regEncryptedPrivate.
  ///
  /// In en, this message translates to:
  /// **'Encrypted & Private'**
  String get regEncryptedPrivate;

  /// No description provided for @regEncryptedPrivateBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is secured and handled in line with privacy standards.'**
  String get regEncryptedPrivateBody;

  /// No description provided for @regVerificationInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Verification interrupted'**
  String get regVerificationInterrupted;

  /// No description provided for @regReopenVerification.
  ///
  /// In en, this message translates to:
  /// **'Reopen verification'**
  String get regReopenVerification;

  /// No description provided for @regRetryListening.
  ///
  /// In en, this message translates to:
  /// **'Retry listening'**
  String get regRetryListening;

  /// No description provided for @regCameraPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Could not open camera/gallery. Please check permissions.'**
  String get regCameraPermissionError;

  /// No description provided for @regSelectBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Select birthdate'**
  String get regSelectBirthdate;

  /// No description provided for @regManualIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual Identity Registration'**
  String get regManualIdentityTitle;

  /// No description provided for @regFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get regFirstName;

  /// No description provided for @regLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get regLastName;

  /// No description provided for @regGrandfatherName.
  ///
  /// In en, this message translates to:
  /// **'Grandfather\'s Name'**
  String get regGrandfatherName;

  /// No description provided for @regPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get regPhoneNumber;

  /// No description provided for @regPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+251911223344 or 0911223344'**
  String get regPhoneHint;

  /// No description provided for @regEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get regEmail;

  /// No description provided for @regGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get regGender;

  /// No description provided for @regMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get regMale;

  /// No description provided for @regFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get regFemale;

  /// No description provided for @regBeneficiaryCategory.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary Category'**
  String get regBeneficiaryCategory;

  /// No description provided for @regNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get regNotes;

  /// No description provided for @regNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Zakat support applicant'**
  String get regNotesHint;

  /// No description provided for @regUploadProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Picture'**
  String get regUploadProfilePicture;

  /// No description provided for @regVerifyingFaydaBanner.
  ///
  /// In en, this message translates to:
  /// **'Verifying with Fayda… Complete verification in the browser when it opens.'**
  String get regVerifyingFaydaBanner;

  /// No description provided for @regNeedsAssessment.
  ///
  /// In en, this message translates to:
  /// **'Needs Assessment'**
  String get regNeedsAssessment;

  /// No description provided for @regSituationLabel.
  ///
  /// In en, this message translates to:
  /// **'Describe your current situation'**
  String get regSituationLabel;

  /// No description provided for @regSituationHint.
  ///
  /// In en, this message translates to:
  /// **'Explain hardship, dependents, and urgent needs...'**
  String get regSituationHint;

  /// No description provided for @regUploadProof.
  ///
  /// In en, this message translates to:
  /// **'Upload Proof'**
  String get regUploadProof;

  /// No description provided for @regDisbursementSetup.
  ///
  /// In en, this message translates to:
  /// **'Disbursement Setup'**
  String get regDisbursementSetup;

  /// No description provided for @regTelebirrTitle.
  ///
  /// In en, this message translates to:
  /// **'Telebirr Wallet'**
  String get regTelebirrTitle;

  /// No description provided for @regTelebirrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Instant mobile money transfer'**
  String get regTelebirrSubtitle;

  /// No description provided for @regMpesaTitle.
  ///
  /// In en, this message translates to:
  /// **'M-Pesa'**
  String get regMpesaTitle;

  /// No description provided for @regMpesaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Secure mobile payment network'**
  String get regMpesaSubtitle;

  /// No description provided for @regCoopbankTitle.
  ///
  /// In en, this message translates to:
  /// **'Coopbank Account'**
  String get regCoopbankTitle;

  /// No description provided for @regCoopbankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Direct bank deposit'**
  String get regCoopbankSubtitle;

  /// No description provided for @regAccountOrMobile.
  ///
  /// In en, this message translates to:
  /// **'Account or Mobile Number'**
  String get regAccountOrMobile;

  /// No description provided for @regFullLegalName.
  ///
  /// In en, this message translates to:
  /// **'Full Legal Name'**
  String get regFullLegalName;

  /// No description provided for @regAgreementTitle.
  ///
  /// In en, this message translates to:
  /// **'Agreement & Sharia Compliance'**
  String get regAgreementTitle;

  /// No description provided for @regAgreementBody.
  ///
  /// In en, this message translates to:
  /// **'I declare information is truthful and will use aid according to policy.'**
  String get regAgreementBody;

  /// No description provided for @regInstitutionRegistration.
  ///
  /// In en, this message translates to:
  /// **'Institution Registration'**
  String get regInstitutionRegistration;

  /// No description provided for @regInstitutionType.
  ///
  /// In en, this message translates to:
  /// **'Institution Type'**
  String get regInstitutionType;

  /// No description provided for @regLegalName.
  ///
  /// In en, this message translates to:
  /// **'Legal Name'**
  String get regLegalName;

  /// No description provided for @regTradingName.
  ///
  /// In en, this message translates to:
  /// **'Trading Name'**
  String get regTradingName;

  /// No description provided for @regTradeRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Trade Registration Number'**
  String get regTradeRegistrationNumber;

  /// No description provided for @regTin.
  ///
  /// In en, this message translates to:
  /// **'Tax Identification Number (TIN)'**
  String get regTin;

  /// No description provided for @regVatOptional.
  ///
  /// In en, this message translates to:
  /// **'VAT Registration Number (optional)'**
  String get regVatOptional;

  /// No description provided for @regRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get regRegion;

  /// No description provided for @regCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get regCity;

  /// No description provided for @regAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get regAddress;

  /// No description provided for @regNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get regNotesOptional;

  /// No description provided for @regAuthorityDocTitle.
  ///
  /// In en, this message translates to:
  /// **'Authority to act document required'**
  String get regAuthorityDocTitle;

  /// No description provided for @regAuthorityDocBody.
  ///
  /// In en, this message translates to:
  /// **'Enable if someone other than a registered signatory submits.'**
  String get regAuthorityDocBody;

  /// No description provided for @regFilePickError.
  ///
  /// In en, this message translates to:
  /// **'Could not pick file. Please check permissions.'**
  String get regFilePickError;

  /// No description provided for @regUploadKycTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload KYC Documents'**
  String get regUploadKycTitle;

  /// No description provided for @regUploadKycBody.
  ///
  /// In en, this message translates to:
  /// **'Upload each required document. You can finish once all required documents are uploaded.'**
  String get regUploadKycBody;

  /// No description provided for @regReference.
  ///
  /// In en, this message translates to:
  /// **'Reference: {id}'**
  String regReference(Object id);

  /// No description provided for @regNoDocumentsRequired.
  ///
  /// In en, this message translates to:
  /// **'No documents required at this time.'**
  String get regNoDocumentsRequired;

  /// No description provided for @regRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get regRequired;

  /// No description provided for @regOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get regOptional;

  /// No description provided for @regSelectedFile.
  ///
  /// In en, this message translates to:
  /// **'Selected: {name}'**
  String regSelectedFile(Object name);

  /// No description provided for @regUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get regUploaded;

  /// No description provided for @regUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get regUpload;

  /// No description provided for @regCreatePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your Password'**
  String get regCreatePasswordTitle;

  /// No description provided for @regCreatePasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a secure password for your account. You will use it to sign in after registration.'**
  String get regCreatePasswordBody;

  /// No description provided for @regPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get regPassword;

  /// No description provided for @regConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get regConfirmPassword;

  /// No description provided for @regPasswordRules.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters and include uppercase, lowercase, a number, and a special character.'**
  String get regPasswordRules;

  /// No description provided for @regPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password set successfully. Welcome to Mejlis Digital Hub.'**
  String get regPasswordSuccess;

  /// No description provided for @regInstitutionComplete.
  ///
  /// In en, this message translates to:
  /// **'Institution registration complete. Reference: {id}'**
  String regInstitutionComplete(Object id);

  /// No description provided for @regInstitutionCompleteGeneric.
  ///
  /// In en, this message translates to:
  /// **'Institution registration complete.'**
  String get regInstitutionCompleteGeneric;

  /// No description provided for @regCompleteLocal.
  ///
  /// In en, this message translates to:
  /// **'Registration complete. Needs and disbursement details are saved locally.'**
  String get regCompleteLocal;

  /// No description provided for @regContinueWithFayda.
  ///
  /// In en, this message translates to:
  /// **'Continue with Fayda'**
  String get regContinueWithFayda;

  /// No description provided for @regVerifyingFayda.
  ///
  /// In en, this message translates to:
  /// **'Verifying with Fayda…'**
  String get regVerifyingFayda;

  /// No description provided for @regSubmitContinue.
  ///
  /// In en, this message translates to:
  /// **'Submit & Continue'**
  String get regSubmitContinue;

  /// No description provided for @regSetPasswordContinue.
  ///
  /// In en, this message translates to:
  /// **'Set Password & Continue'**
  String get regSetPasswordContinue;

  /// No description provided for @regSetPasswordFinish.
  ///
  /// In en, this message translates to:
  /// **'Set Password & Finish'**
  String get regSetPasswordFinish;

  /// No description provided for @navAwqaf.
  ///
  /// In en, this message translates to:
  /// **'Awqaf'**
  String get navAwqaf;

  /// No description provided for @regVerifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get regVerifyCode;

  /// No description provided for @regCodeBranchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch: {branchName}'**
  String regCodeBranchLabel(String branchName);

  /// No description provided for @regCodeBranchConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please confirm this is your branch before continuing.'**
  String get regCodeBranchConfirm;

  /// No description provided for @regAddressLine.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get regAddressLine;

  /// No description provided for @regKebele.
  ///
  /// In en, this message translates to:
  /// **'Kebele'**
  String get regKebele;

  /// No description provided for @regReligion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get regReligion;

  /// No description provided for @regMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital status'**
  String get regMaritalStatus;

  /// No description provided for @regMaritalSingle.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get regMaritalSingle;

  /// No description provided for @regMaritalMarried.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get regMaritalMarried;

  /// No description provided for @regMaritalWidowed.
  ///
  /// In en, this message translates to:
  /// **'Widowed'**
  String get regMaritalWidowed;

  /// No description provided for @regMaritalDivorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get regMaritalDivorced;

  /// No description provided for @regMaritalSeparated.
  ///
  /// In en, this message translates to:
  /// **'Separated'**
  String get regMaritalSeparated;

  /// No description provided for @regVerifyCodeFirst.
  ///
  /// In en, this message translates to:
  /// **'Enter your registration code and tap Verify. The form opens once the code is accepted.'**
  String get regVerifyCodeFirst;

  /// No description provided for @homeQuickCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get homeQuickCalculate;

  /// No description provided for @homeQuickSadaqah.
  ///
  /// In en, this message translates to:
  /// **'Sadaqah'**
  String get homeQuickSadaqah;

  /// No description provided for @homeQuickApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get homeQuickApply;

  /// No description provided for @homeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'UPCOMING'**
  String get homeUpcoming;

  /// No description provided for @payTitleZakat.
  ///
  /// In en, this message translates to:
  /// **'Complete your Zakat'**
  String get payTitleZakat;

  /// No description provided for @paySubtitleZakat.
  ///
  /// In en, this message translates to:
  /// **'Fulfil your obligation securely through trusted local channels.'**
  String get paySubtitleZakat;

  /// No description provided for @payTotalZakatDue.
  ///
  /// In en, this message translates to:
  /// **'TOTAL ZAKAT DUE'**
  String get payTotalZakatDue;

  /// No description provided for @payCalculatedOverview.
  ///
  /// In en, this message translates to:
  /// **'CALCULATED OVERVIEW'**
  String get payCalculatedOverview;

  /// No description provided for @payAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount to pay (ETB)'**
  String get payAmountLabel;

  /// No description provided for @payAmountHintZakat.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you want to pay'**
  String get payAmountHintZakat;

  /// No description provided for @payAmountHintEtb.
  ///
  /// In en, this message translates to:
  /// **'Enter an ETB amount'**
  String get payAmountHintEtb;

  /// No description provided for @payNaturalUnitsLivestock.
  ///
  /// In en, this message translates to:
  /// **'Zakat on livestock is due in animals. You may pay its ETB value based on current local market prices.'**
  String get payNaturalUnitsLivestock;

  /// No description provided for @payNaturalUnitsCrops.
  ///
  /// In en, this message translates to:
  /// **'Zakat on crops is due in harvest. You may pay its ETB value based on current local market prices.'**
  String get payNaturalUnitsCrops;

  /// No description provided for @payBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary (optional)'**
  String get payBeneficiary;

  /// No description provided for @payProjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary project'**
  String get payProjectLabel;

  /// No description provided for @payGeneralFundZakat.
  ///
  /// In en, this message translates to:
  /// **'General Zakat fund'**
  String get payGeneralFundZakat;

  /// No description provided for @payMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get payMethod;

  /// No description provided for @paySecureSsl.
  ///
  /// In en, this message translates to:
  /// **'256-BIT SSL'**
  String get paySecureSsl;

  /// No description provided for @paySecureBank.
  ///
  /// In en, this message translates to:
  /// **'BANK-GRADE SECURITY'**
  String get paySecureBank;

  /// No description provided for @payImpactTitle.
  ///
  /// In en, this message translates to:
  /// **'Your impact'**
  String get payImpactTitle;

  /// No description provided for @payImpactBody.
  ///
  /// In en, this message translates to:
  /// **'Every contribution is allocated transparently through the commission\'s programmes.'**
  String get payImpactBody;

  /// No description provided for @regStepIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get regStepIdentity;

  /// No description provided for @regStepNeeds.
  ///
  /// In en, this message translates to:
  /// **'Needs'**
  String get regStepNeeds;

  /// No description provided for @regStepVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get regStepVerify;

  /// No description provided for @regStepPayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get regStepPayout;

  /// No description provided for @regStepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get regStepDetails;

  /// No description provided for @regStepPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get regStepPassword;

  /// No description provided for @regStepDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get regStepDocuments;

  /// No description provided for @regEmailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get regEmailOptional;

  /// No description provided for @regSubmittedNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Registration submitted. No sign-in account was created because no email was given.'**
  String get regSubmittedNoAccount;

  /// No description provided for @loginIdentifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email'**
  String get loginIdentifierLabel;

  /// No description provided for @loginIdentifierRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number or email'**
  String get loginIdentifierRequired;

  /// No description provided for @loginIdentifierInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number (e.g. 0911223344) or email'**
  String get loginIdentifierInvalid;

  /// No description provided for @calcCamelBintMakhadN.
  ///
  /// In en, this message translates to:
  /// **'{count} bint makhad'**
  String calcCamelBintMakhadN(int count);

  /// No description provided for @calcCamelBintLabunN.
  ///
  /// In en, this message translates to:
  /// **'{count} bint labun'**
  String calcCamelBintLabunN(int count);

  /// No description provided for @calcCamelHiqqahN.
  ///
  /// In en, this message translates to:
  /// **'{count} hiqqah'**
  String calcCamelHiqqahN(int count);

  /// No description provided for @calcCamelJadhahN.
  ///
  /// In en, this message translates to:
  /// **'{count} jadhah'**
  String calcCamelJadhahN(int count);

  /// No description provided for @calcNisabMetalGold.
  ///
  /// In en, this message translates to:
  /// **'gold (24k)'**
  String get calcNisabMetalGold;

  /// No description provided for @calcNisabMetalSilver.
  ///
  /// In en, this message translates to:
  /// **'silver'**
  String get calcNisabMetalSilver;

  /// No description provided for @calcPricesAsOf.
  ///
  /// In en, this message translates to:
  /// **'Prices as of {date} · {source}'**
  String calcPricesAsOf(String date, String source);

  /// No description provided for @calcPricesAsOfNoSource.
  ///
  /// In en, this message translates to:
  /// **'Prices as of {date}'**
  String calcPricesAsOfNoSource(String date);

  /// No description provided for @calcPricesStale.
  ///
  /// In en, this message translates to:
  /// **'Prices may be out of date.'**
  String get calcPricesStale;

  /// No description provided for @calcPricesSavedCopy.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh prices. Showing the prices saved on this device.'**
  String get calcPricesSavedCopy;

  /// No description provided for @calcConfigErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load today\'s zakat rates'**
  String get calcConfigErrorTitle;

  /// No description provided for @calcConfigErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get calcConfigErrorBody;

  /// No description provided for @calcConfigNotReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Gold and silver prices are not available yet. Please try again later.'**
  String get calcConfigNotReadyBody;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @calcLivestockEstimateLine.
  ///
  /// In en, this message translates to:
  /// **'Estimated market value: {amount}'**
  String calcLivestockEstimateLine(String amount);

  /// No description provided for @calcLivestockEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'Estimated at average market prices per animal. You can change the amount before paying.'**
  String get calcLivestockEstimateNote;

  /// No description provided for @homeLiveCollected.
  ///
  /// In en, this message translates to:
  /// **'LIVE · {amount} collected'**
  String homeLiveCollected(String amount);

  /// No description provided for @homeCollected.
  ///
  /// In en, this message translates to:
  /// **'{amount} collected'**
  String homeCollected(String amount);

  /// No description provided for @homeChangeUp.
  ///
  /// In en, this message translates to:
  /// **'↑ {percent}% vs last month'**
  String homeChangeUp(String percent);

  /// No description provided for @homeChangeDown.
  ///
  /// In en, this message translates to:
  /// **'↓ {percent}% vs last month'**
  String homeChangeDown(String percent);

  /// No description provided for @homeChangeFlat.
  ///
  /// In en, this message translates to:
  /// **'Same as last month'**
  String get homeChangeFlat;

  /// No description provided for @homeBeneficiariesSubtext.
  ///
  /// In en, this message translates to:
  /// **'households'**
  String get homeBeneficiariesSubtext;

  /// No description provided for @fitrStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'OPEN NOW'**
  String get fitrStatusOpen;

  /// No description provided for @fitrStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'CLOSED'**
  String get fitrStatusClosed;

  /// No description provided for @fitrStartsIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Starts today} =1{Starts tomorrow} other{Starts in {days} days}}'**
  String fitrStartsIn(int days);

  /// No description provided for @fitrDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Today is the last day to pay} =1{1 day left to pay} other{{days} days left to pay}}'**
  String fitrDaysLeft(int days);

  /// No description provided for @fitrClosedOn.
  ///
  /// In en, this message translates to:
  /// **'Closed on {date}'**
  String fitrClosedOn(String date);

  /// No description provided for @fitrPerPerson.
  ///
  /// In en, this message translates to:
  /// **'{amount} per person'**
  String fitrPerPerson(String amount);

  /// No description provided for @causesTitle.
  ///
  /// In en, this message translates to:
  /// **'Causes'**
  String get causesTitle;

  /// No description provided for @causesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Projects your zakat supports'**
  String get causesSubtitle;

  /// No description provided for @causesActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get causesActive;

  /// No description provided for @causesClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get causesClosed;

  /// No description provided for @causesAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get causesAllCategories;

  /// No description provided for @causeCategoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get causeCategoryEducation;

  /// No description provided for @causeCategoryWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get causeCategoryWater;

  /// No description provided for @causeCategoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get causeCategoryHealth;

  /// No description provided for @causeCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get causeCategoryFood;

  /// No description provided for @causeCategoryShelter.
  ///
  /// In en, this message translates to:
  /// **'Shelter'**
  String get causeCategoryShelter;

  /// No description provided for @causeCategoryLivelihood.
  ///
  /// In en, this message translates to:
  /// **'Livelihood'**
  String get causeCategoryLivelihood;

  /// No description provided for @causeCategoryEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get causeCategoryEmergency;

  /// No description provided for @causeCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get causeCategoryGeneral;

  /// No description provided for @causeBadgeUrgent.
  ///
  /// In en, this message translates to:
  /// **'URGENT'**
  String get causeBadgeUrgent;

  /// No description provided for @causeBadgeEssential.
  ///
  /// In en, this message translates to:
  /// **'ESSENTIAL'**
  String get causeBadgeEssential;

  /// No description provided for @causeRaisedOfGoal.
  ///
  /// In en, this message translates to:
  /// **'{raised} raised of {goal}'**
  String causeRaisedOfGoal(String raised, String goal);

  /// No description provided for @causeRaised.
  ///
  /// In en, this message translates to:
  /// **'{raised} raised'**
  String causeRaised(String raised);

  /// No description provided for @causeEndsOn.
  ///
  /// In en, this message translates to:
  /// **'Ends {date}'**
  String causeEndsOn(String date);

  /// No description provided for @causeEndedOn.
  ///
  /// In en, this message translates to:
  /// **'Ended {date}'**
  String causeEndedOn(String date);

  /// No description provided for @causesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No causes to show yet.'**
  String get causesEmpty;

  /// No description provided for @causesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load causes.'**
  String get causesLoadError;

  /// No description provided for @causeNotFound.
  ///
  /// In en, this message translates to:
  /// **'This cause is no longer available.'**
  String get causeNotFound;

  /// No description provided for @causeAbout.
  ///
  /// In en, this message translates to:
  /// **'About this cause'**
  String get causeAbout;

  /// No description provided for @payProjectsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading projects…'**
  String get payProjectsLoading;

  /// No description provided for @impactAsOf.
  ///
  /// In en, this message translates to:
  /// **'As of {date}'**
  String impactAsOf(String date);

  /// No description provided for @impactBeneficiariesByAsnaf.
  ///
  /// In en, this message translates to:
  /// **'Beneficiaries by category'**
  String get impactBeneficiariesByAsnaf;

  /// No description provided for @impactRegionBeneficiaries.
  ///
  /// In en, this message translates to:
  /// **'{count} beneficiaries'**
  String impactRegionBeneficiaries(String count);

  /// No description provided for @impactRegionProjects.
  ///
  /// In en, this message translates to:
  /// **'{count} projects'**
  String impactRegionProjects(String count);

  /// No description provided for @impactShowNational.
  ///
  /// In en, this message translates to:
  /// **'Show national'**
  String get impactShowNational;

  /// No description provided for @impactStoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'This story is no longer available.'**
  String get impactStoryNotFound;

  /// No description provided for @impactStoryLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this story.'**
  String get impactStoryLoadError;

  /// No description provided for @impactPublishedOn.
  ///
  /// In en, this message translates to:
  /// **'Published {date}'**
  String impactPublishedOn(String date);

  /// No description provided for @payNotAllowedBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary accounts receive zakat and can\'t pay it. Sign out to pay as a guest.'**
  String get payNotAllowedBeneficiary;

  /// No description provided for @payEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount.'**
  String get payEnterAmount;

  /// No description provided for @payAmountOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount between {min} and {max}.'**
  String payAmountOutOfRange(String min, String max);

  /// No description provided for @payAccountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Coop Bank account number'**
  String get payAccountNumberLabel;

  /// No description provided for @payAccountNumberHelper.
  ///
  /// In en, this message translates to:
  /// **'The account you pay from. We\'ll show the account holder\'s name for you to confirm.'**
  String get payAccountNumberHelper;

  /// No description provided for @payAccountNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid account number (6–20 digits).'**
  String get payAccountNumberInvalid;

  /// No description provided for @payNetworkError.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get payNetworkError;

  /// No description provided for @payMethodsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading payment methods…'**
  String get payMethodsLoading;

  /// No description provided for @payMethodsError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load payment methods.'**
  String get payMethodsError;

  /// No description provided for @payNoMethods.
  ///
  /// In en, this message translates to:
  /// **'No payment method is available right now.'**
  String get payNoMethods;

  /// No description provided for @payMethodUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available yet'**
  String get payMethodUnavailable;

  /// No description provided for @payCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this payment?'**
  String get payCancelConfirmTitle;

  /// No description provided for @payCancelConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'No money has been taken. You can start again at any time.'**
  String get payCancelConfirmBody;

  /// No description provided for @payKeepPaying.
  ///
  /// In en, this message translates to:
  /// **'Keep paying'**
  String get payKeepPaying;

  /// No description provided for @payCancelPayment.
  ///
  /// In en, this message translates to:
  /// **'Cancel payment'**
  String get payCancelPayment;

  /// No description provided for @payForCause.
  ///
  /// In en, this message translates to:
  /// **'For: {cause}'**
  String payForCause(String cause);

  /// No description provided for @payAccountHolder.
  ///
  /// In en, this message translates to:
  /// **'Account holder'**
  String get payAccountHolder;

  /// No description provided for @payAccountNumberShort.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get payAccountNumberShort;

  /// No description provided for @payConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Is this your account?'**
  String get payConfirmTitle;

  /// No description provided for @payConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'If it is, Coop Bank will send a confirmation code to the phone registered on this account.'**
  String get payConfirmBody;

  /// No description provided for @payYesSendCode.
  ///
  /// In en, this message translates to:
  /// **'Yes, send code'**
  String get payYesSendCode;

  /// No description provided for @payNotMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Not my account'**
  String get payNotMyAccount;

  /// No description provided for @payOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the confirmation code'**
  String get payOtpTitle;

  /// No description provided for @payOtpBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to the phone registered on your Coop Bank account.'**
  String get payOtpBody;

  /// No description provided for @payOtpLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirmation code'**
  String get payOtpLabel;

  /// No description provided for @payOtpAttemptsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 attempt left} other{{count} attempts left}}'**
  String payOtpAttemptsLeft(int count);

  /// No description provided for @payResendCode.
  ///
  /// In en, this message translates to:
  /// **'Send a new code'**
  String get payResendCode;

  /// No description provided for @payPayAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payPayAmount(String amount);

  /// No description provided for @payProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'We are confirming your payment'**
  String get payProcessingTitle;

  /// No description provided for @payProcessingBody.
  ///
  /// In en, this message translates to:
  /// **'Coop Bank hasn\'t answered yet. This page updates by itself; please don\'t pay again.'**
  String get payProcessingBody;

  /// No description provided for @payCheckAgain.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get payCheckAgain;

  /// No description provided for @paySucceededTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get paySucceededTitle;

  /// No description provided for @paySucceededBody.
  ///
  /// In en, this message translates to:
  /// **'Your zakat of {amount} has been paid. May Allah accept it from you.'**
  String paySucceededBody(String amount);

  /// No description provided for @payReference.
  ///
  /// In en, this message translates to:
  /// **'Bank reference: {reference}'**
  String payReference(String reference);

  /// No description provided for @payViewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View certificate'**
  String get payViewCertificate;

  /// No description provided for @payDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get payDone;

  /// No description provided for @payCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled'**
  String get payCancelledTitle;

  /// No description provided for @payExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment expired'**
  String get payExpiredTitle;

  /// No description provided for @payExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'It wasn\'t finished within 15 minutes. No money was taken; please start again.'**
  String get payExpiredBody;

  /// No description provided for @payFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment not completed'**
  String get payFailedTitle;

  /// No description provided for @payNoMoneyTaken.
  ///
  /// In en, this message translates to:
  /// **'No money was taken.'**
  String get payNoMoneyTaken;

  /// No description provided for @payStartAgain.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get payStartAgain;

  /// No description provided for @certTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat certificate'**
  String get certTitle;

  /// No description provided for @certNumber.
  ///
  /// In en, this message translates to:
  /// **'Certificate {id}'**
  String certNumber(String id);

  /// No description provided for @certSharePdf.
  ///
  /// In en, this message translates to:
  /// **'Download / share PDF'**
  String get certSharePdf;

  /// No description provided for @certPdfError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download the certificate.'**
  String get certPdfError;

  /// No description provided for @certLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the certificate.'**
  String get certLoadError;

  /// No description provided for @certNotFound.
  ///
  /// In en, this message translates to:
  /// **'Certificate not found.'**
  String get certNotFound;

  /// No description provided for @certPayer.
  ///
  /// In en, this message translates to:
  /// **'Payer'**
  String get certPayer;

  /// No description provided for @certType.
  ///
  /// In en, this message translates to:
  /// **'Zakat type'**
  String get certType;

  /// No description provided for @certCause.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get certCause;

  /// No description provided for @certNaturalUnits.
  ///
  /// In en, this message translates to:
  /// **'Calculated due'**
  String get certNaturalUnits;

  /// No description provided for @certMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get certMethod;

  /// No description provided for @certReference.
  ///
  /// In en, this message translates to:
  /// **'Bank reference'**
  String get certReference;

  /// No description provided for @certPaidAt.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get certPaidAt;

  /// No description provided for @certIssuedAt.
  ///
  /// In en, this message translates to:
  /// **'Issued'**
  String get certIssuedAt;

  /// No description provided for @certHijriDate.
  ///
  /// In en, this message translates to:
  /// **'Hijri date'**
  String get certHijriDate;

  /// No description provided for @certVerifyHint.
  ///
  /// In en, this message translates to:
  /// **'The QR code on the PDF lets anyone verify this certificate.'**
  String get certVerifyHint;

  /// No description provided for @zakatTypeWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get zakatTypeWealth;

  /// No description provided for @zakatTypeLivestock.
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get zakatTypeLivestock;

  /// No description provided for @zakatTypeCrops.
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get zakatTypeCrops;

  /// No description provided for @zakatTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General zakat'**
  String get zakatTypeGeneral;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'My zakat payments'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments yet.'**
  String get historyEmpty;

  /// No description provided for @historyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your payments.'**
  String get historyLoadError;

  /// No description provided for @payStatusSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get payStatusSucceeded;

  /// No description provided for @payStatusPending.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get payStatusPending;

  /// No description provided for @payStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get payStatusFailed;

  /// No description provided for @payStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get payStatusCancelled;

  /// No description provided for @payStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get payStatusExpired;

  /// No description provided for @fitrPayButton.
  ///
  /// In en, this message translates to:
  /// **'Pay Zakat al-Fitr'**
  String get fitrPayButton;

  /// No description provided for @fitrHouseholdTitle.
  ///
  /// In en, this message translates to:
  /// **'How many people are you paying for?'**
  String get fitrHouseholdTitle;

  /// No description provided for @fitrHouseholdOf.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}}'**
  String fitrHouseholdOf(int count);

  /// No description provided for @fitrTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String fitrTotal(String amount);

  /// No description provided for @profileCaseStatus.
  ///
  /// In en, this message translates to:
  /// **'Case'**
  String get profileCaseStatus;

  /// No description provided for @caseStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get caseStatusSubmitted;

  /// No description provided for @caseStatusVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get caseStatusVerified;

  /// No description provided for @caseStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get caseStatusApproved;

  /// No description provided for @caseStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active — receiving support'**
  String get caseStatusActive;

  /// No description provided for @caseStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get caseStatusClosed;

  /// No description provided for @impactComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Impact data is coming soon'**
  String get impactComingSoonTitle;

  /// No description provided for @impactComingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'This page will show how zakat reaches communities across Ethiopia.'**
  String get impactComingSoonBody;

  /// No description provided for @payFinishWithin.
  ///
  /// In en, this message translates to:
  /// **'Finish within {time}'**
  String payFinishWithin(String time);

  /// No description provided for @payOtpExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Code expires in {time}'**
  String payOtpExpiresIn(String time);

  /// No description provided for @payOtpExpiredLocal.
  ///
  /// In en, this message translates to:
  /// **'The code has expired. Send a new one.'**
  String get payOtpExpiredLocal;

  /// No description provided for @unfinishedPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Unfinished payment'**
  String get unfinishedPaymentTitle;

  /// No description provided for @unfinishedPaymentContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get unfinishedPaymentContinue;

  /// No description provided for @payCheckStatus.
  ///
  /// In en, this message translates to:
  /// **'Check status'**
  String get payCheckStatus;

  /// No description provided for @recentPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent payments on this device'**
  String get recentPaymentsTitle;

  /// No description provided for @recentPaymentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Resume an unfinished payment or open a certificate.'**
  String get recentPaymentsSubtitle;

  /// No description provided for @recentPaymentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments on this device yet.'**
  String get recentPaymentsEmpty;

  /// No description provided for @payOpenError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open this payment.'**
  String get payOpenError;

  /// No description provided for @profileSectionPayoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Payout Account'**
  String get profileSectionPayoutAccount;

  /// No description provided for @profileRoleBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary'**
  String get profileRoleBeneficiary;

  /// No description provided for @profileRoleDonor.
  ///
  /// In en, this message translates to:
  /// **'Donor'**
  String get profileRoleDonor;

  /// No description provided for @profileVerificationVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get profileVerificationVerified;

  /// No description provided for @profileVerificationPending.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get profileVerificationPending;

  /// No description provided for @profileVerificationRejected.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get profileVerificationRejected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'ar', 'en', 'om', 'so'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'om':
      return AppLocalizationsOm();
    case 'so':
      return AppLocalizationsSo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
