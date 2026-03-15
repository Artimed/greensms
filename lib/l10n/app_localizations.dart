import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_id.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_vi.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('bn'),
    Locale('en'),
    Locale('fil'),
    Locale('hi'),
    Locale('hy'),
    Locale('id'),
    Locale('kk'),
    Locale('ru'),
    Locale('tl'),
    Locale('ur'),
    Locale('uz'),
    Locale('vi'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Green SMS'**
  String get appName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visual assistant for SMS banking operations'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingFeatureLocal.
  ///
  /// In en, this message translates to:
  /// **'Works locally, no internet required'**
  String get onboardingFeatureLocal;

  /// No description provided for @onboardingFeatureSms.
  ///
  /// In en, this message translates to:
  /// **'Reads only the last 10 SMS messages'**
  String get onboardingFeatureSms;

  /// No description provided for @onboardingFeaturePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data is never sent externally'**
  String get onboardingFeaturePrivacy;

  /// No description provided for @onboardingFeatureQr.
  ///
  /// In en, this message translates to:
  /// **'QR is used only to share a phone number'**
  String get onboardingFeatureQr;

  /// No description provided for @onboardingButton.
  ///
  /// In en, this message translates to:
  /// **'Request permissions and continue'**
  String get onboardingButton;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @noAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No recognized accounts yet.'**
  String get noAccountsYet;

  /// No description provided for @latestSms.
  ///
  /// In en, this message translates to:
  /// **'Latest SMS'**
  String get latestSms;

  /// No description provided for @smsNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'SMS not loaded yet.'**
  String get smsNotLoaded;

  /// No description provided for @qrModeTitle.
  ///
  /// In en, this message translates to:
  /// **'QR Mode'**
  String get qrModeTitle;

  /// No description provided for @qrModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open full-screen camera'**
  String get qrModeSubtitle;

  /// No description provided for @smsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'SMS Details'**
  String get smsDetailsTitle;

  /// No description provided for @smsDetailsSender.
  ///
  /// In en, this message translates to:
  /// **'Sender: {sender}'**
  String smsDetailsSender(String sender);

  /// No description provided for @smsDetailsTime.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String smsDetailsTime(String time);

  /// No description provided for @smsDetailsLast4.
  ///
  /// In en, this message translates to:
  /// **'Card: {last4}'**
  String smsDetailsLast4(String last4);

  /// No description provided for @smsDetailsLast4NotFound.
  ///
  /// In en, this message translates to:
  /// **'not found'**
  String get smsDetailsLast4NotFound;

  /// No description provided for @smsDetailsAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount}'**
  String smsDetailsAmount(String amount);

  /// No description provided for @smsDetailsBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance: {balance}'**
  String smsDetailsBalance(String balance);

  /// No description provided for @smsDetailsReference.
  ///
  /// In en, this message translates to:
  /// **'Ref: {reference}'**
  String smsDetailsReference(String reference);

  /// No description provided for @smsDetailsType.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String smsDetailsType(String type);

  /// No description provided for @transferRulesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Transfer rules'**
  String get transferRulesTooltip;

  /// No description provided for @accountsLabel.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsLabel;

  /// No description provided for @refreshSmsButton.
  ///
  /// In en, this message translates to:
  /// **'Refresh SMS'**
  String get refreshSmsButton;

  /// No description provided for @dailyLimitNotSet.
  ///
  /// In en, this message translates to:
  /// **'Daily limit not set'**
  String get dailyLimitNotSet;

  /// No description provided for @setLimitInSettings.
  ///
  /// In en, this message translates to:
  /// **'Set limit in settings'**
  String get setLimitInSettings;

  /// No description provided for @dailyTransferLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily transfer limit'**
  String get dailyTransferLimit;

  /// No description provided for @usedToday.
  ///
  /// In en, this message translates to:
  /// **'Used today'**
  String get usedToday;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @limitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Limit exceeded'**
  String get limitExceeded;

  /// No description provided for @limitWarning80.
  ///
  /// In en, this message translates to:
  /// **'More than 80% of daily limit used'**
  String get limitWarning80;

  /// No description provided for @limitExceededBlocked.
  ///
  /// In en, this message translates to:
  /// **'Daily limit exceeded. QR transfers are blocked.'**
  String get limitExceededBlocked;

  /// No description provided for @accountBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance: {balance}'**
  String accountBalanceLabel(String balance);

  /// No description provided for @parsedLabel.
  ///
  /// In en, this message translates to:
  /// **'parsed'**
  String get parsedLabel;

  /// No description provided for @rawLabel.
  ///
  /// In en, this message translates to:
  /// **'raw'**
  String get rawLabel;

  /// No description provided for @devicePhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Device phone'**
  String get devicePhoneTitle;

  /// No description provided for @devicePhoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Used to generate QR with your number'**
  String get devicePhoneDesc;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @dailyLimitDesc.
  ///
  /// In en, this message translates to:
  /// **'Maximum daily transfer amount through this app. Resets at midnight. Leave empty to remove the limit.'**
  String get dailyLimitDesc;

  /// No description provided for @limitLabel.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limitLabel;

  /// No description provided for @limitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50000'**
  String get limitHint;

  /// No description provided for @removeLimitButton.
  ///
  /// In en, this message translates to:
  /// **'Remove limit'**
  String get removeLimitButton;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeTitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @bankRoutingTitle.
  ///
  /// In en, this message translates to:
  /// **'Country and bank'**
  String get bankRoutingTitle;

  /// No description provided for @bankRoutingDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose country first. If there are multiple banks, select the bank for payment commands.'**
  String get bankRoutingDesc;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @bankLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bankLabel;

  /// No description provided for @bankAutoSelectedHint.
  ///
  /// In en, this message translates to:
  /// **'Only one bank is available for this country, selected automatically.'**
  String get bankAutoSelectedHint;

  /// No description provided for @referenceOnlyBadge.
  ///
  /// In en, this message translates to:
  /// **'reference only'**
  String get referenceOnlyBadge;

  /// No description provided for @bankReferenceOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'For this country, the bank is available as a reference source for limits and rules only. Direct payment commands are not currently verified.'**
  String get bankReferenceOnlyHint;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageKazakh.
  ///
  /// In en, this message translates to:
  /// **'Kazakh'**
  String get languageKazakh;

  /// No description provided for @languageUzbek.
  ///
  /// In en, this message translates to:
  /// **'Uzbek'**
  String get languageUzbek;

  /// No description provided for @languageTagalog.
  ///
  /// In en, this message translates to:
  /// **'Tagalog'**
  String get languageTagalog;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get languageIndonesian;

  /// No description provided for @permissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissionsTitle;

  /// No description provided for @readSmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Read SMS'**
  String get readSmsTitle;

  /// No description provided for @readSmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Allows reading incoming SMS for transaction parsing'**
  String get readSmsDesc;

  /// No description provided for @directSmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Direct SMS sending'**
  String get directSmsTitle;

  /// No description provided for @directSmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Send SMS directly from app without opening messaging app'**
  String get directSmsDesc;

  /// No description provided for @directSmsPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'SEND_SMS permission is required. Grant it in system app settings.'**
  String get directSmsPermissionRequired;

  /// No description provided for @directSmsEnabledSnack.
  ///
  /// In en, this message translates to:
  /// **'Direct SMS sending enabled'**
  String get directSmsEnabledSnack;

  /// No description provided for @directSmsDisabledSnack.
  ///
  /// In en, this message translates to:
  /// **'Direct SMS sending disabled'**
  String get directSmsDisabledSnack;

  /// No description provided for @openSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get openSettingsButton;

  /// No description provided for @permissionsManageInSystem.
  ///
  /// In en, this message translates to:
  /// **'You can disable permissions in system app settings.'**
  String get permissionsManageInSystem;

  /// No description provided for @cameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraTitle;

  /// No description provided for @cameraDesc.
  ///
  /// In en, this message translates to:
  /// **'For scanning QR'**
  String get cameraDesc;

  /// No description provided for @clearLocalDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear local data'**
  String get clearLocalDataTitle;

  /// No description provided for @clearLocalDataDesc.
  ///
  /// In en, this message translates to:
  /// **'SMS, accounts, QR profiles and history'**
  String get clearLocalDataDesc;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Green SMS v1.0\nLocal app, no internet required'**
  String get aboutVersion;

  /// No description provided for @snackLimitRemoved.
  ///
  /// In en, this message translates to:
  /// **'Limit removed'**
  String get snackLimitRemoved;

  /// No description provided for @snackLimitSet.
  ///
  /// In en, this message translates to:
  /// **'Limit set: {amount}'**
  String snackLimitSet(String amount);

  /// No description provided for @snackPhoneSaved.
  ///
  /// In en, this message translates to:
  /// **'Phone saved'**
  String get snackPhoneSaved;

  /// No description provided for @snackDataCleared.
  ///
  /// In en, this message translates to:
  /// **'Local data cleared'**
  String get snackDataCleared;

  /// No description provided for @clearDataDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear data?'**
  String get clearDataDialogTitle;

  /// No description provided for @clearDataDialogContent.
  ///
  /// In en, this message translates to:
  /// **'SMS, accounts, QR profiles and history will be deleted.'**
  String get clearDataDialogContent;

  /// No description provided for @cameraPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Camera access required'**
  String get cameraPermissionNeeded;

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'Point camera at QR code'**
  String get scanHint;

  /// No description provided for @scanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanButton;

  /// No description provided for @phoneTransferButton.
  ///
  /// In en, this message translates to:
  /// **'By phone'**
  String get phoneTransferButton;

  /// No description provided for @limitWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily limit exceeded'**
  String get limitWarningTitle;

  /// No description provided for @limitWarningContent.
  ///
  /// In en, this message translates to:
  /// **'Transfer amount: {amount}\nLimit remaining: {remaining}\n\nTransfer exceeds daily limit. Proceed anyway?'**
  String limitWarningContent(String amount, String remaining);

  /// No description provided for @sendAnywayButton.
  ///
  /// In en, this message translates to:
  /// **'Send anyway'**
  String get sendAnywayButton;

  /// No description provided for @createSmsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Create SMS?'**
  String get createSmsDialogTitle;

  /// No description provided for @createSmsPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String createSmsPhone(String phone);

  /// No description provided for @createSmsText.
  ///
  /// In en, this message translates to:
  /// **'Text: {text}'**
  String createSmsText(String text);

  /// No description provided for @qrNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'QR not recognized as internal format.'**
  String get qrNotRecognized;

  /// No description provided for @transferCancelledLimit.
  ///
  /// In en, this message translates to:
  /// **'Transfer cancelled — limit exceeded.'**
  String get transferCancelledLimit;

  /// No description provided for @smsSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'SMS created. Confirm sending in the messaging app.'**
  String get smsSentSuccess;

  /// No description provided for @scanningContinues.
  ///
  /// In en, this message translates to:
  /// **'Scanning continues.'**
  String get scanningContinues;

  /// No description provided for @noQrInImage.
  ///
  /// In en, this message translates to:
  /// **'No QR code found in the selected image.'**
  String get noQrInImage;

  /// No description provided for @qrFoundNoData.
  ///
  /// In en, this message translates to:
  /// **'QR found but no data.'**
  String get qrFoundNoData;

  /// No description provided for @setPhoneFirst.
  ///
  /// In en, this message translates to:
  /// **'First set the device phone in settings.'**
  String get setPhoneFirst;

  /// No description provided for @setAccountFirst.
  ///
  /// In en, this message translates to:
  /// **'First set your account number in Settings.'**
  String get setAccountFirst;

  /// No description provided for @chooseChannelTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose transfer channel'**
  String get chooseChannelTitle;

  /// No description provided for @scanningActive.
  ///
  /// In en, this message translates to:
  /// **'Scanning active.'**
  String get scanningActive;

  /// No description provided for @phoneQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone QR'**
  String get phoneQrTitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String phoneLabel(String phone);

  /// No description provided for @qrGenerationTitle.
  ///
  /// In en, this message translates to:
  /// **'QR Generation'**
  String get qrGenerationTitle;

  /// No description provided for @noProfile.
  ///
  /// In en, this message translates to:
  /// **'No profile'**
  String get noProfile;

  /// No description provided for @profileLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileLabel;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get profileNameLabel;

  /// No description provided for @recipientPhone.
  ///
  /// In en, this message translates to:
  /// **'Recipient phone'**
  String get recipientPhone;

  /// No description provided for @phoneTransferInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer without QR'**
  String get phoneTransferInputTitle;

  /// No description provided for @enterPhoneError.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number'**
  String get enterPhoneError;

  /// No description provided for @amountOptional.
  ///
  /// In en, this message translates to:
  /// **'Amount (optional)'**
  String get amountOptional;

  /// No description provided for @amountRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer amount (required)'**
  String get amountRequiredLabel;

  /// No description provided for @enterAmountError.
  ///
  /// In en, this message translates to:
  /// **'Enter transfer amount'**
  String get enterAmountError;

  /// No description provided for @sourceLast4Optional.
  ///
  /// In en, this message translates to:
  /// **'Source card/account last4 (optional)'**
  String get sourceLast4Optional;

  /// No description provided for @sourceLast4Hint.
  ///
  /// In en, this message translates to:
  /// **'Example: 1234'**
  String get sourceLast4Hint;

  /// No description provided for @invalidLast4Error.
  ///
  /// In en, this message translates to:
  /// **'Enter exactly 4 digits'**
  String get invalidLast4Error;

  /// No description provided for @sourceAccountOptionalSection.
  ///
  /// In en, this message translates to:
  /// **'Source account (optional)'**
  String get sourceAccountOptionalSection;

  /// No description provided for @sberAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required for transfer via 900.'**
  String get sberAmountRequired;

  /// No description provided for @smsTarget900.
  ///
  /// In en, this message translates to:
  /// **'To: 900'**
  String get smsTarget900;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @myQrButton.
  ///
  /// In en, this message translates to:
  /// **'My QR'**
  String get myQrButton;

  /// No description provided for @qrAmountButton.
  ///
  /// In en, this message translates to:
  /// **'QR with amount'**
  String get qrAmountButton;

  /// No description provided for @showQrButton.
  ///
  /// In en, this message translates to:
  /// **'Show QR'**
  String get showQrButton;

  /// No description provided for @saveProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfileButton;

  /// No description provided for @composeSmsButton.
  ///
  /// In en, this message translates to:
  /// **'Compose SMS'**
  String get composeSmsButton;

  /// No description provided for @qrHintPhoneOnly.
  ///
  /// In en, this message translates to:
  /// **'Show this QR to the recipient — they will enter amount and source account before sending'**
  String get qrHintPhoneOnly;

  /// No description provided for @qrHint.
  ///
  /// In en, this message translates to:
  /// **'Show this QR to the recipient — they will scan and make the transfer'**
  String get qrHint;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @qrError.
  ///
  /// In en, this message translates to:
  /// **'QR error: {error}'**
  String qrError(Object error);

  /// No description provided for @transferLimitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer limits and rules'**
  String get transferLimitsTitle;

  /// No description provided for @openSberSiteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open Sberbank website'**
  String get openSberSiteTooltip;

  /// No description provided for @infoActualBanner.
  ///
  /// In en, this message translates to:
  /// **'Information is current as of this app version. Limits and conditions may change — check at sberbank.ru or call 900.'**
  String get infoActualBanner;

  /// No description provided for @smsCommandsTitle.
  ///
  /// In en, this message translates to:
  /// **'SMS commands (to number 900)'**
  String get smsCommandsTitle;

  /// No description provided for @limitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer limits'**
  String get limitsTitle;

  /// No description provided for @notificationFormatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sberbank SMS notification formats'**
  String get notificationFormatsTitle;

  /// No description provided for @importantRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Important rules'**
  String get importantRulesTitle;

  /// No description provided for @feesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get feesTitle;

  /// No description provided for @cannotOpenBrowser.
  ///
  /// In en, this message translates to:
  /// **'Could not open browser'**
  String get cannotOpenBrowser;

  /// No description provided for @number900Copied.
  ///
  /// In en, this message translates to:
  /// **'Number 900 copied'**
  String get number900Copied;

  /// No description provided for @copiedCommand.
  ///
  /// In en, this message translates to:
  /// **'Copied: {command}'**
  String copiedCommand(String command);

  /// No description provided for @officialSberSite.
  ///
  /// In en, this message translates to:
  /// **'Official Sberbank website'**
  String get officialSberSite;

  /// No description provided for @officialSiteButton.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get officialSiteButton;

  /// No description provided for @helpContact900.
  ///
  /// In en, this message translates to:
  /// **'Help: contact 900'**
  String get helpContact900;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'This app is not an official Sberbank product. It only helps read SMS and compose commands — all transfers are made via standard SMS commands through your mobile carrier.'**
  String get disclaimerText;

  /// No description provided for @personalLimitBanner.
  ///
  /// In en, this message translates to:
  /// **'To check your personal limit — send SMS «ЛИМИТ» to 900. Limits may vary depending on your tariff and transaction history.'**
  String get personalLimitBanner;

  /// No description provided for @phoneCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied'**
  String get phoneCopied;

  /// No description provided for @copyPhoneButton.
  ///
  /// In en, this message translates to:
  /// **'Copy phone'**
  String get copyPhoneButton;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String noteLabel(String note);

  /// No description provided for @qrNotRecognizedWithRaw.
  ///
  /// In en, this message translates to:
  /// **'QR is not recognized as internal format: {raw}'**
  String qrNotRecognizedWithRaw(String raw);

  /// No description provided for @cmdTransferMain.
  ///
  /// In en, this message translates to:
  /// **'ПЕРЕВОД [phone] [amount]'**
  String get cmdTransferMain;

  /// No description provided for @cmdTransferMainDesc.
  ///
  /// In en, this message translates to:
  /// **'Transfer to a phone number from the main card.\nExample: ПЕРЕВОД 79161234567 1000'**
  String get cmdTransferMainDesc;

  /// No description provided for @cmdTransferWithCard.
  ///
  /// In en, this message translates to:
  /// **'ПЕРЕВОД [phone] [amount] [last4]'**
  String get cmdTransferWithCard;

  /// No description provided for @cmdTransferWithCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Transfer from a specific card.\nExample: ПЕРЕВОД 79161234567 500 1234'**
  String get cmdTransferWithCardDesc;

  /// No description provided for @cmdBalance.
  ///
  /// In en, this message translates to:
  /// **'БАЛАНС'**
  String get cmdBalance;

  /// No description provided for @cmdBalanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Main card balance.'**
  String get cmdBalanceDesc;

  /// No description provided for @cmdBalanceCard.
  ///
  /// In en, this message translates to:
  /// **'БАЛАНС [last4]'**
  String get cmdBalanceCard;

  /// No description provided for @cmdBalanceCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Specific card balance.'**
  String get cmdBalanceCardDesc;

  /// No description provided for @cmdHistory.
  ///
  /// In en, this message translates to:
  /// **'ИСТОРИЯ'**
  String get cmdHistory;

  /// No description provided for @cmdHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Last 5 transactions on the main card.'**
  String get cmdHistoryDesc;

  /// No description provided for @cmdBlock.
  ///
  /// In en, this message translates to:
  /// **'БЛОКИРОВКА [last4]'**
  String get cmdBlock;

  /// No description provided for @cmdBlockDesc.
  ///
  /// In en, this message translates to:
  /// **'Temporary card block.'**
  String get cmdBlockDesc;

  /// No description provided for @cmdLimit.
  ///
  /// In en, this message translates to:
  /// **'ЛИМИТ'**
  String get cmdLimit;

  /// No description provided for @cmdLimitDesc.
  ///
  /// In en, this message translates to:
  /// **'Check your current transfer limits via SMS.'**
  String get cmdLimitDesc;

  /// No description provided for @limitEconomyPerTxLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Bank \"Economy\" — per transaction'**
  String get limitEconomyPerTxLabel;

  /// No description provided for @limitEconomyPerTxValue.
  ///
  /// In en, this message translates to:
  /// **'8,000 ₽'**
  String get limitEconomyPerTxValue;

  /// No description provided for @limitEconomyPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Bank \"Economy\" — per day'**
  String get limitEconomyPerDayLabel;

  /// No description provided for @limitEconomyPerDayValue.
  ///
  /// In en, this message translates to:
  /// **'8,000 ₽'**
  String get limitEconomyPerDayValue;

  /// No description provided for @limitFullPerTxLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Bank \"Full\" — per transaction'**
  String get limitFullPerTxLabel;

  /// No description provided for @limitFullPerTxValue.
  ///
  /// In en, this message translates to:
  /// **'up to 50,000 ₽'**
  String get limitFullPerTxValue;

  /// No description provided for @limitFullPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Bank \"Full\" — per day'**
  String get limitFullPerDayLabel;

  /// No description provided for @limitFullPerDayValue.
  ///
  /// In en, this message translates to:
  /// **'up to 500,000 ₽'**
  String get limitFullPerDayValue;

  /// No description provided for @limitCardToCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Card to card (online)'**
  String get limitCardToCardLabel;

  /// No description provided for @limitCardToCardValue.
  ///
  /// In en, this message translates to:
  /// **'up to 150,000 ₽'**
  String get limitCardToCardValue;

  /// No description provided for @exampleIncomingLabel.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get exampleIncomingLabel;

  /// No description provided for @exampleIncomingText.
  ///
  /// In en, this message translates to:
  /// **'SBERBANK Incoming 10000 RUB Card *1234 Balance: 25000 RUB'**
  String get exampleIncomingText;

  /// No description provided for @examplePurchaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get examplePurchaseLabel;

  /// No description provided for @examplePurchaseText.
  ///
  /// In en, this message translates to:
  /// **'SBERBANK Purchase 1500 RUB Card *1234 STORE NAME Balance: 23500 RUB'**
  String get examplePurchaseText;

  /// No description provided for @exampleTransferLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get exampleTransferLabel;

  /// No description provided for @exampleTransferText.
  ///
  /// In en, this message translates to:
  /// **'Transfer 5000 RUB from card *1234 completed. Balance: 18500 RUB.'**
  String get exampleTransferText;

  /// No description provided for @exampleCashWithdrawalLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash withdrawal'**
  String get exampleCashWithdrawalLabel;

  /// No description provided for @exampleCashWithdrawalText.
  ///
  /// In en, this message translates to:
  /// **'Cash withdrawal 3000 RUB. Card *1234. Balance: 15500 RUB.'**
  String get exampleCashWithdrawalText;

  /// No description provided for @ruleRecipientClient.
  ///
  /// In en, this message translates to:
  /// **'Recipient must be a Sberbank client and have Mobile Bank enabled.'**
  String get ruleRecipientClient;

  /// No description provided for @rulePhoneLinked.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be linked to recipient\'s card.'**
  String get rulePhoneLinked;

  /// No description provided for @ruleSmsIrreversible.
  ///
  /// In en, this message translates to:
  /// **'SMS transfer cannot be reversed — verify recipient number before confirmation.'**
  String get ruleSmsIrreversible;

  /// No description provided for @ruleSpecifyLast4.
  ///
  /// In en, this message translates to:
  /// **'If you have multiple cards, specify source card last4 to avoid mistakes.'**
  String get ruleSpecifyLast4;

  /// No description provided for @ruleEconomyVsFull.
  ///
  /// In en, this message translates to:
  /// **'\"Economy\" tariff (free) — 8,000 ₽/day limit. \"Full\" tariff (paid) — up to 500,000 ₽/day.'**
  String get ruleEconomyVsFull;

  /// No description provided for @ruleResetAtMidnight.
  ///
  /// In en, this message translates to:
  /// **'Daily limit resets at 00:00 Moscow time.'**
  String get ruleResetAtMidnight;

  /// No description provided for @feeEconomyLabel.
  ///
  /// In en, this message translates to:
  /// **'\"Economy\" tariff — transfer fee'**
  String get feeEconomyLabel;

  /// No description provided for @feeEconomyValue.
  ///
  /// In en, this message translates to:
  /// **'1% (min. 30 ₽)'**
  String get feeEconomyValue;

  /// No description provided for @feeFullLabel.
  ///
  /// In en, this message translates to:
  /// **'\"Full\" tariff — transfer fee'**
  String get feeFullLabel;

  /// No description provided for @feeFullValue.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get feeFullValue;

  /// No description provided for @feeSubscriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'\"Full\" tariff subscription'**
  String get feeSubscriptionLabel;

  /// No description provided for @feeSubscriptionValue.
  ///
  /// In en, this message translates to:
  /// **'60 ₽/month'**
  String get feeSubscriptionValue;

  /// No description provided for @opIncoming.
  ///
  /// In en, this message translates to:
  /// **'incoming'**
  String get opIncoming;

  /// No description provided for @opOutgoing.
  ///
  /// In en, this message translates to:
  /// **'outgoing'**
  String get opOutgoing;

  /// No description provided for @opTransfer.
  ///
  /// In en, this message translates to:
  /// **'transfer'**
  String get opTransfer;

  /// No description provided for @opUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get opUnknown;

  /// No description provided for @smsTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'To: {number}'**
  String smsTargetLabel(String number);

  /// No description provided for @amountRequiredForTransfer.
  ///
  /// In en, this message translates to:
  /// **'Amount is required for this transfer.'**
  String get amountRequiredForTransfer;

  /// No description provided for @ussdDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Open USSD?'**
  String get ussdDialogTitle;

  /// No description provided for @openDialerButton.
  ///
  /// In en, this message translates to:
  /// **'Open Dialer'**
  String get openDialerButton;

  /// No description provided for @ussdSentHint.
  ///
  /// In en, this message translates to:
  /// **'USSD dialed. Confirm the transfer in the dialer.'**
  String get ussdSentHint;

  /// No description provided for @bankNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Bank commands not configured for your region.'**
  String get bankNotAvailable;

  /// No description provided for @transferSmsCommandTitle.
  ///
  /// In en, this message translates to:
  /// **'SMS transfer command'**
  String get transferSmsCommandTitle;

  /// No description provided for @transferUssdCommandTitle.
  ///
  /// In en, this message translates to:
  /// **'USSD transfer command'**
  String get transferUssdCommandTitle;

  /// No description provided for @sendToLabel.
  ///
  /// In en, this message translates to:
  /// **'Send to: {number}'**
  String sendToLabel(String number);

  /// No description provided for @exampleLabelShort.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get exampleLabelShort;

  /// No description provided for @bankLimitsContactBanner.
  ///
  /// In en, this message translates to:
  /// **'Transfer limits and fees depend on your plan. Contact {bankName} for up-to-date information.'**
  String bankLimitsContactBanner(String bankName);

  /// No description provided for @notificationExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'SMS notification examples'**
  String get notificationExamplesTitle;

  /// No description provided for @noBankSelectedBanner.
  ///
  /// In en, this message translates to:
  /// **'No bank selected. Choose a country and bank in Settings.'**
  String get noBankSelectedBanner;

  /// No description provided for @helpContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Help: contact {number}'**
  String helpContactNumber(String number);

  /// No description provided for @bankDisclaimerGeneric.
  ///
  /// In en, this message translates to:
  /// **'This app is not affiliated with {bankName}. Transfers use standard SMS or USSD commands through your mobile carrier.'**
  String bankDisclaimerGeneric(String bankName);

  /// No description provided for @infoActualBannerGeneric.
  ///
  /// In en, this message translates to:
  /// **'Information is based on publicly available data. Limits and conditions may change — check with your bank.'**
  String get infoActualBannerGeneric;

  /// No description provided for @officialDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Official data'**
  String get officialDataTitle;

  /// No description provided for @officialStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Source status'**
  String get officialStatusLabel;

  /// No description provided for @officialChannelLabel.
  ///
  /// In en, this message translates to:
  /// **'Panel channel'**
  String get officialChannelLabel;

  /// No description provided for @officialLastVerifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified on'**
  String get officialLastVerifiedLabel;

  /// No description provided for @officialStatusVerifiedPublic.
  ///
  /// In en, this message translates to:
  /// **'Verified by public source'**
  String get officialStatusVerifiedPublic;

  /// No description provided for @officialStatusLimitedPublic.
  ///
  /// In en, this message translates to:
  /// **'Public source is limited'**
  String get officialStatusLimitedPublic;

  /// No description provided for @officialStatusManualVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Manual verification required'**
  String get officialStatusManualVerificationRequired;

  /// No description provided for @officialStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get officialStatusUnknown;

  /// No description provided for @officialWarningLimited.
  ///
  /// In en, this message translates to:
  /// **'Official public limits and rules for this exact channel are only partially confirmed. Treat the values as reference and verify with the bank.'**
  String get officialWarningLimited;

  /// No description provided for @officialWarningManual.
  ///
  /// In en, this message translates to:
  /// **'This bank or channel does not have enough current public official confirmation. The values are shown for reference only.'**
  String get officialWarningManual;

  /// No description provided for @commandChannelUnavailableBanner.
  ///
  /// In en, this message translates to:
  /// **'A direct SMS or USSD command channel is not currently verified for this bank. The info panel is shown as a reference to official public data.'**
  String get commandChannelUnavailableBanner;

  /// No description provided for @directTransferButton.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get directTransferButton;

  /// No description provided for @createSmsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account: {account}'**
  String createSmsAccount(String account);

  /// No description provided for @recipientAccount.
  ///
  /// In en, this message translates to:
  /// **'Recipient account'**
  String get recipientAccount;

  /// No description provided for @enterAccountError.
  ///
  /// In en, this message translates to:
  /// **'Enter an account number'**
  String get enterAccountError;

  /// No description provided for @routeLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer channel'**
  String get routeLabel;

  /// No description provided for @routeSmsPhone.
  ///
  /// In en, this message translates to:
  /// **'SMS by phone'**
  String get routeSmsPhone;

  /// No description provided for @routeSmsAccount.
  ///
  /// In en, this message translates to:
  /// **'SMS by account'**
  String get routeSmsAccount;

  /// No description provided for @routeUssdPhone.
  ///
  /// In en, this message translates to:
  /// **'USSD by phone'**
  String get routeUssdPhone;

  /// No description provided for @routeUssdAccount.
  ///
  /// In en, this message translates to:
  /// **'USSD by account'**
  String get routeUssdAccount;

  /// No description provided for @accountQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Account QR'**
  String get accountQrTitle;

  /// No description provided for @qrHintAccountOnly.
  ///
  /// In en, this message translates to:
  /// **'Show this QR to the sender — they will use your account in their bank flow before sending'**
  String get qrHintAccountOnly;

  /// No description provided for @yourAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get yourAccountTitle;

  /// No description provided for @yourAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Used to generate QR with your account number'**
  String get yourAccountDesc;

  /// No description provided for @accountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get accountNumberLabel;

  /// No description provided for @snackAccountSaved.
  ///
  /// In en, this message translates to:
  /// **'Account saved'**
  String get snackAccountSaved;

  /// No description provided for @selectBankFirstHint.
  ///
  /// In en, this message translates to:
  /// **'Select and save bank above to configure'**
  String get selectBankFirstHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'fil',
    'hi',
    'hy',
    'id',
    'kk',
    'ru',
    'tl',
    'ur',
    'uz',
    'vi',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'fil':
      return AppLocalizationsFil();
    case 'hi':
      return AppLocalizationsHi();
    case 'hy':
      return AppLocalizationsHy();
    case 'id':
      return AppLocalizationsId();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
    case 'tl':
      return AppLocalizationsTl();
    case 'ur':
      return AppLocalizationsUr();
    case 'uz':
      return AppLocalizationsUz();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
