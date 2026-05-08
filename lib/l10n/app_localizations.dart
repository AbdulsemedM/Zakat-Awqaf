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
  /// **'Zakat and Awqaf Commission'**
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
  /// **'Urgent Beneficiary Needs'**
  String get urgentBeneficiaryNeeds;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
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
  /// **'Pay Zakat to this cause'**
  String get payZakatCause;

  /// No description provided for @zakatAlFitr.
  ///
  /// In en, this message translates to:
  /// **'Zakat Al-Fitr'**
  String get zakatAlFitr;

  /// No description provided for @zakatDueDays.
  ///
  /// In en, this message translates to:
  /// **'Due in approximately 22 days.'**
  String get zakatDueDays;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminder;

  /// No description provided for @needQuickWayGive.
  ///
  /// In en, this message translates to:
  /// **'Need a quick way to give?'**
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
  /// **'About Ethiopian Zakat and Awqaf Commission'**
  String get aboutCommission;

  /// No description provided for @aboutCommissionBody.
  ///
  /// In en, this message translates to:
  /// **'The Ethiopian Zakat and Awqaf Commission coordinates zakat collection and awqaf development to uplift vulnerable communities through transparent, Shariah-aligned programs.'**
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

  /// No description provided for @missingCertificateDetails.
  ///
  /// In en, this message translates to:
  /// **'Missing certificate details.'**
  String get missingCertificateDetails;

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
  /// **'Zakat is due if your net wealth exceeds the threshold. Nisab is based on 85g of platform 24k gold price.'**
  String get calcStep1NisabBody;

  /// No description provided for @calcNisabGoldFormula.
  ///
  /// In en, this message translates to:
  /// **'{grams} × {price} = {total}'**
  String calcNisabGoldFormula(String grams, String price, String total);

  /// No description provided for @calcNisabThresholdBanner.
  ///
  /// In en, this message translates to:
  /// **'Nisab threshold (platform rate, 85g gold equivalent): {amount}'**
  String calcNisabThresholdBanner(String amount);

  /// No description provided for @calcUsdEtb.
  ///
  /// In en, this message translates to:
  /// **'USD/ETB'**
  String get calcUsdEtb;

  /// No description provided for @calcFxLive.
  ///
  /// In en, this message translates to:
  /// **'Using live exchange rate'**
  String get calcFxLive;

  /// No description provided for @calcFxCache.
  ///
  /// In en, this message translates to:
  /// **'Using cached exchange rate'**
  String get calcFxCache;

  /// No description provided for @calcFxFallback.
  ///
  /// In en, this message translates to:
  /// **'Using fallback exchange rate'**
  String get calcFxFallback;

  /// No description provided for @calcTimestampUnavailable.
  ///
  /// In en, this message translates to:
  /// **'timestamp unavailable'**
  String get calcTimestampUnavailable;

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
  /// **'Nisab thresholds: Sheep/Goats 40, Cattle 30, Camels 5. Cattle uses 30/40 combinations; camels follow tier ranges.'**
  String get calcStep1LivestockNisabNote;

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
  /// **'Crop Zakat is due at harvest. Nisab is 653kg. Rate is 10% (rain-fed), 5% (irrigated), or weighted for mixed.'**
  String get calcStep1CropBody;

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
  /// **'Nisab: 653kg. Rates: rain-fed 10%, irrigated 5%, mixed = weighted split. Zakat is due at harvest (no annual hawl for crops).'**
  String get calcHowCropZakatWorksBody;

  /// No description provided for @calcHowCropZakatNote.
  ///
  /// In en, this message translates to:
  /// **'Note: App applies these rules broadly for simplicity. Scholarly positions differ on crop-type scope and expense deductions; consult qualified scholars for specific cases.'**
  String get calcHowCropZakatNote;

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

  /// No description provided for @calcPayBlockedWealth.
  ///
  /// In en, this message translates to:
  /// **'No wealth Zakat is due (below nisab or zero ETB due). Adjust your inputs.'**
  String get calcPayBlockedWealth;

  /// No description provided for @calcPayBlockedLivestock.
  ///
  /// In en, this message translates to:
  /// **'No livestock Zakat is due for your current counts.'**
  String get calcPayBlockedLivestock;

  /// No description provided for @calcPayBlockedCrops.
  ///
  /// In en, this message translates to:
  /// **'Crop Zakat is not due yet (below harvest nisab or zero kg due).'**
  String get calcPayBlockedCrops;

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
  /// **'Sheep/Goats threshold: {head} >= 40 => due {due} sheep.'**
  String calcTransSheep(int head, int due);

  /// No description provided for @calcTransCattle.
  ///
  /// In en, this message translates to:
  /// **'Cattle threshold: {head} >= 30 => due {tabi} tabi\', {musinnah} musinnah (30/40 combination).'**
  String calcTransCattle(int head, int tabi, int musinnah);

  /// No description provided for @calcTransCamel.
  ///
  /// In en, this message translates to:
  /// **'Camel threshold: {head} >= 5 => due {due}.'**
  String calcTransCamel(int head, String due);

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

  /// No description provided for @calcCamel1BintMakhad.
  ///
  /// In en, this message translates to:
  /// **'1 bint makhad'**
  String get calcCamel1BintMakhad;

  /// No description provided for @calcCamel1BintLabun.
  ///
  /// In en, this message translates to:
  /// **'1 bint labun'**
  String get calcCamel1BintLabun;

  /// No description provided for @calcCamel1Hiqqah.
  ///
  /// In en, this message translates to:
  /// **'1 hiqqah'**
  String get calcCamel1Hiqqah;

  /// No description provided for @calcCamel1Jadhah.
  ///
  /// In en, this message translates to:
  /// **'1 jadhah'**
  String get calcCamel1Jadhah;

  /// No description provided for @calcCamel2BintLabun.
  ///
  /// In en, this message translates to:
  /// **'2 bint labun'**
  String get calcCamel2BintLabun;

  /// No description provided for @calcCamel2Hiqqah.
  ///
  /// In en, this message translates to:
  /// **'2 hiqqah'**
  String get calcCamel2Hiqqah;

  /// No description provided for @calcCamelCombo.
  ///
  /// In en, this message translates to:
  /// **'{hiqqah} hiqqah + {bintLabun} bint labun'**
  String calcCamelCombo(int hiqqah, int bintLabun);

  /// No description provided for @calcCamelApproxBintLabun.
  ///
  /// In en, this message translates to:
  /// **'{count} bint labun (approximate combo)'**
  String calcCamelApproxBintLabun(int count);

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

  /// No description provided for @profileSectionImpactDashboard.
  ///
  /// In en, this message translates to:
  /// **'Impact Dashboard'**
  String get profileSectionImpactDashboard;

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

  /// No description provided for @profileFaydaVerified.
  ///
  /// In en, this message translates to:
  /// **'Fayda Verified'**
  String get profileFaydaVerified;

  /// No description provided for @profileNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get profileNotVerified;

  /// No description provided for @profileTotalZakatPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Zakat Paid'**
  String get profileTotalZakatPaid;

  /// No description provided for @profileFySummary.
  ///
  /// In en, this message translates to:
  /// **'FY 2023 Summary'**
  String get profileFySummary;

  /// No description provided for @profileActiveEndowments.
  ///
  /// In en, this message translates to:
  /// **'Active Endowments'**
  String get profileActiveEndowments;

  /// No description provided for @profileSustainableImpact.
  ///
  /// In en, this message translates to:
  /// **'Sustainable impact'**
  String get profileSustainableImpact;

  /// No description provided for @profileBeneficiariesHelped.
  ///
  /// In en, this message translates to:
  /// **'Beneficiaries Helped'**
  String get profileBeneficiariesHelped;

  /// No description provided for @profileAcrossPrograms.
  ///
  /// In en, this message translates to:
  /// **'Across programs'**
  String get profileAcrossPrograms;

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

  /// No description provided for @profileZakatHistoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Zakat history coming soon'**
  String get profileZakatHistoryComingSoon;

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

  /// No description provided for @impactActiveAwqafProjects.
  ///
  /// In en, this message translates to:
  /// **'Active Awqaf Projects'**
  String get impactActiveAwqafProjects;

  /// No description provided for @impactAllProjectsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'All projects coming soon'**
  String get impactAllProjectsComingSoon;

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

  /// No description provided for @impactRegionImpactComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{region} impact coming soon'**
  String impactRegionImpactComingSoon(String region);

  /// No description provided for @impactStoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{name} story coming soon'**
  String impactStoryComingSoon(String name);

  /// No description provided for @impactProjectDetailsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{title} details coming soon'**
  String impactProjectDetailsComingSoon(String title);

  /// No description provided for @impactPercentFunded.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Funded'**
  String impactPercentFunded(String percent);

  /// No description provided for @impactEtbLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} ETB Left'**
  String impactEtbLeft(String amount);

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
