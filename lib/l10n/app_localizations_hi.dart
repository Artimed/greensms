// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'ग्रीन SMS';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get back => 'वापस';

  @override
  String get allow => 'अनुमति दें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get onboardingSubtitle => 'SMS बैंकिंग ऑपरेशनों के लिए विज़ुअल सहायक';

  @override
  String get onboardingFeatureLocal =>
      'स्थानीय रूप से काम करता है, इंटरनेट आवश्यक नहीं';

  @override
  String get onboardingFeatureSms => 'केवल अंतिम 10 SMS संदेश पढ़ता है';

  @override
  String get onboardingFeaturePrivacy => 'डेटा बाहर कहीं भेजा नहीं जाता';

  @override
  String get onboardingFeatureQr =>
      'QR का उपयोग केवल फोन नंबर साझा करने के लिए होता है';

  @override
  String get onboardingButton => 'अनुमतियाँ माँगें और जारी रखें';

  @override
  String get accounts => 'खाते';

  @override
  String get noAccountsYet => 'अभी तक कोई पहचाना गया खाता नहीं है।';

  @override
  String get latestSms => 'नवीनतम SMS';

  @override
  String get smsNotLoaded => 'SMS अभी लोड नहीं हुए।';

  @override
  String get qrModeTitle => 'QR मोड';

  @override
  String get qrModeSubtitle => 'फुल-स्क्रीन कैमरा खोलें';

  @override
  String get smsDetailsTitle => 'SMS विवरण';

  @override
  String smsDetailsSender(String sender) {
    return 'प्रेषक: $sender';
  }

  @override
  String smsDetailsTime(String time) {
    return 'समय: $time';
  }

  @override
  String smsDetailsLast4(String last4) {
    return 'कार्ड: $last4';
  }

  @override
  String get smsDetailsLast4NotFound => 'नहीं मिला';

  @override
  String smsDetailsAmount(String amount) {
    return 'राशि: $amount';
  }

  @override
  String smsDetailsBalance(String balance) {
    return 'शेष: $balance';
  }

  @override
  String smsDetailsReference(String reference) {
    return 'Ref: $reference';
  }

  @override
  String smsDetailsType(String type) {
    return 'प्रकार: $type';
  }

  @override
  String get transferRulesTooltip => 'ट्रांसफर नियम';

  @override
  String get accountsLabel => 'खाते';

  @override
  String get refreshSmsButton => 'SMS रीफ़्रेश करें';

  @override
  String get dailyLimitNotSet => 'दैनिक सीमा सेट नहीं है';

  @override
  String get setLimitInSettings => 'सेटिंग्स में सीमा सेट करें';

  @override
  String get dailyTransferLimit => 'दैनिक ट्रांसफर सीमा';

  @override
  String get usedToday => 'आज उपयोग किया गया';

  @override
  String get remaining => 'शेष';

  @override
  String get limitExceeded => 'सीमा पार हो गई';

  @override
  String get limitWarning80 => 'दैनिक सीमा का 80% से अधिक उपयोग हो चुका है';

  @override
  String get limitExceededBlocked =>
      'दैनिक सीमा पार हो गई। QR ट्रांसफर अवरुद्ध हैं।';

  @override
  String accountBalanceLabel(String balance) {
    return 'शेष: $balance';
  }

  @override
  String get parsedLabel => 'पार्स किया गया';

  @override
  String get rawLabel => 'रॉ';

  @override
  String get devicePhoneTitle => 'डिवाइस फोन';

  @override
  String get devicePhoneDesc =>
      'आपके नंबर के साथ QR बनाने के लिए उपयोग किया जाता है';

  @override
  String get phoneNumberLabel => 'फोन नंबर';

  @override
  String get dailyLimitDesc =>
      'इस ऐप के माध्यम से अधिकतम दैनिक ट्रांसफर राशि। मध्यरात्रि में रीसेट होती है। सीमा हटाने के लिए खाली छोड़ें।';

  @override
  String get limitLabel => 'सीमा';

  @override
  String get limitHint => 'उदा.: 50000';

  @override
  String get removeLimitButton => 'सीमा हटाएँ';

  @override
  String get themeTitle => 'दिखावट';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get bankRoutingTitle => 'देश और बैंक';

  @override
  String get bankRoutingDesc =>
      'पहले देश चुनें। अगर एक से अधिक बैंक हों, तो भुगतान कमांड के लिए बैंक चुनें।';

  @override
  String get countryLabel => 'देश';

  @override
  String get bankLabel => 'बैंक';

  @override
  String get bankAutoSelectedHint =>
      'इस देश के लिए केवल एक बैंक उपलब्ध है, वह अपने-आप चुना गया है।';

  @override
  String get referenceOnlyBadge => 'reference only';

  @override
  String get bankReferenceOnlyHint =>
      'For this country, the bank is available as a reference source for limits and rules only. Direct payment commands are not currently verified.';

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageRussian => 'रूसी';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageKazakh => 'कज़ाख';

  @override
  String get languageUzbek => 'उज़्बेक';

  @override
  String get languageTagalog => 'टागालोग';

  @override
  String get languageIndonesian => 'इंडोनेशियाई';

  @override
  String get permissionsTitle => 'अनुमतियाँ';

  @override
  String get readSmsTitle => 'SMS पढ़ें';

  @override
  String get readSmsDesc => 'आने वाले SMS पढ़ने और डेटा अपडेट करने के लिए';

  @override
  String get directSmsTitle => 'सीधा SMS भेजना';

  @override
  String get directSmsDesc => 'मैसेजिंग ऐप खोले बिना सीधे SMS भेजें';

  @override
  String get directSmsPermissionRequired =>
      'SEND_SMS अनुमति चाहिए। इसे सिस्टम ऐप सेटिंग्स में दें।';

  @override
  String get directSmsEnabledSnack => 'सीधा SMS भेजना चालू किया गया';

  @override
  String get directSmsDisabledSnack => 'सीधा SMS भेजना बंद किया गया';

  @override
  String get openSettingsButton => 'सेटिंग्स';

  @override
  String get permissionsManageInSystem =>
      'अनुमतियाँ बंद करना सिस्टम ऐप सेटिंग्स में किया जाता है।';

  @override
  String get cameraTitle => 'कैमरा';

  @override
  String get cameraDesc => 'QR स्कैन करने के लिए';

  @override
  String get clearLocalDataTitle => 'स्थानीय डेटा साफ़ करें';

  @override
  String get clearLocalDataDesc => 'SMS, खाते, QR प्रोफ़ाइल और इतिहास';

  @override
  String get aboutTitle => 'ऐप के बारे में';

  @override
  String get aboutVersion => 'ग्रीन SMS v1.0\nस्थानीय ऐप, इंटरनेट आवश्यक नहीं';

  @override
  String get snackLimitRemoved => 'सीमा हटाई गई';

  @override
  String snackLimitSet(String amount) {
    return 'सीमा सेट की गई: $amount';
  }

  @override
  String get snackPhoneSaved => 'फोन सहेजा गया';

  @override
  String get snackDataCleared => 'स्थानीय डेटा साफ़ किया गया';

  @override
  String get clearDataDialogTitle => 'डेटा साफ़ करें?';

  @override
  String get clearDataDialogContent =>
      'SMS, खाते, QR प्रोफ़ाइल और इतिहास हटाए जाएँगे।';

  @override
  String get cameraPermissionNeeded => 'कैमरा एक्सेस आवश्यक है';

  @override
  String get scanHint => 'कैमरे को QR कोड की ओर रखें';

  @override
  String get scanButton => 'स्कैन करें';

  @override
  String get phoneTransferButton => 'फोन से';

  @override
  String get limitWarningTitle => 'दैनिक सीमा पार';

  @override
  String limitWarningContent(String amount, String remaining) {
    return 'ट्रांसफर राशि: $amount\nशेष सीमा: $remaining\n\nट्रांसफर दैनिक सीमा से अधिक है। फिर भी जारी रखें?';
  }

  @override
  String get sendAnywayButton => 'फिर भी भेजें';

  @override
  String get createSmsDialogTitle => 'SMS बनाएँ?';

  @override
  String createSmsPhone(String phone) {
    return 'फोन: $phone';
  }

  @override
  String createSmsText(String text) {
    return 'पाठ: $text';
  }

  @override
  String get qrNotRecognized =>
      'QR को आंतरिक प्रारूप के रूप में पहचाना नहीं गया।';

  @override
  String get transferCancelledLimit => 'ट्रांसफर रद्द — सीमा पार।';

  @override
  String get smsSentSuccess =>
      'SMS तैयार हो गया। मैसेजिंग ऐप में भेजना पुष्टि करें।';

  @override
  String get scanningContinues => 'स्कैनिंग जारी है।';

  @override
  String get noQrInImage => 'चयनित छवि में QR कोड नहीं मिला।';

  @override
  String get qrFoundNoData => 'QR मिला, लेकिन डेटा नहीं है।';

  @override
  String get setPhoneFirst => 'पहले सेटिंग्स में डिवाइस फोन सेट करें।';

  @override
  String get setAccountFirst => 'पहले सेटिंग्स में खाता नंबर सेट करें।';

  @override
  String get chooseChannelTitle => 'ट्रांसफर चैनल चुनें';

  @override
  String get scanningActive => 'स्कैनिंग सक्रिय है।';

  @override
  String get phoneQrTitle => 'फोन QR';

  @override
  String phoneLabel(String phone) {
    return 'फोन: $phone';
  }

  @override
  String get qrGenerationTitle => 'QR जनरेशन';

  @override
  String get noProfile => 'कोई प्रोफ़ाइल नहीं';

  @override
  String get profileLabel => 'प्रोफ़ाइल';

  @override
  String get profileNameLabel => 'प्रोफ़ाइल नाम';

  @override
  String get recipientPhone => 'प्राप्तकर्ता का फोन';

  @override
  String get phoneTransferInputTitle => 'QR के बिना ट्रांसफर';

  @override
  String get enterPhoneError => 'फोन नंबर दर्ज करें';

  @override
  String get amountOptional => 'राशि (वैकल्पिक)';

  @override
  String get amountRequiredLabel => 'ट्रांसफर राशि (अनिवार्य)';

  @override
  String get enterAmountError => 'ट्रांसफर राशि दर्ज करें';

  @override
  String get sourceLast4Optional => 'स्रोत कार्ड/खाता last4 (वैकल्पिक)';

  @override
  String get sourceLast4Hint => 'उदाहरण: 1234';

  @override
  String get invalidLast4Error => 'ठीक 4 अंक दर्ज करें';

  @override
  String get sourceAccountOptionalSection => 'स्रोत खाता (वैकल्पिक)';

  @override
  String get sberAmountRequired => '900 पर ट्रांसफर के लिए राशि आवश्यक है।';

  @override
  String get smsTarget900 => 'नंबर: 900';

  @override
  String get noteOptional => 'नोट (वैकल्पिक)';

  @override
  String get myQrButton => 'मेरा QR';

  @override
  String get qrAmountButton => 'राशि वाला QR';

  @override
  String get showQrButton => 'QR दिखाएँ';

  @override
  String get saveProfileButton => 'प्रोफ़ाइल सहेजें';

  @override
  String get composeSmsButton => 'SMS लिखें';

  @override
  String get qrHintPhoneOnly =>
      'यह QR प्राप्तकर्ता को दिखाएँ — भेजने से पहले राशि और स्रोत खाता वह अपने तरफ से भरेगा';

  @override
  String get qrHint =>
      'यह QR प्राप्तकर्ता को दिखाएँ — वह स्कैन करके ट्रांसफर करेगा';

  @override
  String get profileSaved => 'प्रोफ़ाइल सहेजी गई';

  @override
  String qrError(Object error) {
    return 'QR त्रुटि: $error';
  }

  @override
  String get transferLimitsTitle => 'ट्रांसफर सीमा और नियम';

  @override
  String get openSberSiteTooltip => 'स्बेरबैंक वेबसाइट खोलें';

  @override
  String get infoActualBanner =>
      'जानकारी इस ऐप संस्करण के अनुसार वर्तमान है। सीमाएँ और शर्तें बदल सकती हैं — sberbank.ru या 900 पर जाँचें।';

  @override
  String get smsCommandsTitle => 'SMS कमांड (नंबर 900 पर)';

  @override
  String get limitsTitle => 'ट्रांसफर सीमाएँ';

  @override
  String get notificationFormatsTitle => 'स्बेरबैंक SMS नोटिफिकेशन प्रारूप';

  @override
  String get importantRulesTitle => 'महत्वपूर्ण नियम';

  @override
  String get feesTitle => 'शुल्क';

  @override
  String get cannotOpenBrowser => 'ब्राउज़र नहीं खुल सका';

  @override
  String get number900Copied => 'नंबर 900 कॉपी किया गया';

  @override
  String copiedCommand(String command) {
    return 'कॉपी किया गया: $command';
  }

  @override
  String get officialSberSite => 'आधिकारिक स्बेरबैंक वेबसाइट';

  @override
  String get officialSiteButton => 'आधिकारिक वेबसाइट';

  @override
  String get helpContact900 => 'सहायता: 900 से संपर्क करें';

  @override
  String get disclaimerText =>
      'यह ऐप स्बेरबैंक का आधिकारिक उत्पाद नहीं है। यह केवल SMS पढ़ने और कमांड बनाने में मदद करता है — सभी ट्रांसफर आपके मोबाइल ऑपरेटर के माध्यम से मानक SMS कमांड से किए जाते हैं।';

  @override
  String get personalLimitBanner =>
      'अपनी व्यक्तिगत सीमा जानने के लिए — 900 पर SMS «ЛИМИТ» भेजें। आपकी टैरिफ योजना और लेनदेन इतिहास के अनुसार सीमाएँ अलग हो सकती हैं।';

  @override
  String get phoneCopied => 'फोन नंबर कॉपी किया गया';

  @override
  String get copyPhoneButton => 'फोन कॉपी करें';

  @override
  String noteLabel(String note) {
    return 'नोट: $note';
  }

  @override
  String qrNotRecognizedWithRaw(String raw) {
    return 'QR को आंतरिक प्रारूप के रूप में नहीं पहचाना गया: $raw';
  }

  @override
  String get cmdTransferMain => 'ПЕРЕВОД [phone] [amount]';

  @override
  String get cmdTransferMainDesc =>
      'मुख्य कार्ड से फोन नंबर पर ट्रांसफर।\nउदाहरण: ПЕРЕВОД 79161234567 1000';

  @override
  String get cmdTransferWithCard => 'ПЕРЕВОД [phone] [amount] [last4]';

  @override
  String get cmdTransferWithCardDesc =>
      'विशिष्ट कार्ड से ट्रांसफर।\nउदाहरण: ПЕРЕВОД 79161234567 500 1234';

  @override
  String get cmdBalance => 'БАЛАНС';

  @override
  String get cmdBalanceDesc => 'मुख्य कार्ड का बैलेंस।';

  @override
  String get cmdBalanceCard => 'БАЛАНС [last4]';

  @override
  String get cmdBalanceCardDesc => 'विशिष्ट कार्ड का बैलेंस।';

  @override
  String get cmdHistory => 'ИСТОРИЯ';

  @override
  String get cmdHistoryDesc => 'मुख्य कार्ड के पिछले 5 लेनदेन।';

  @override
  String get cmdBlock => 'БЛОКИРОВКА [last4]';

  @override
  String get cmdBlockDesc => 'अस्थायी कार्ड ब्लॉक।';

  @override
  String get cmdLimit => 'ЛИМИТ';

  @override
  String get cmdLimitDesc =>
      'SMS के माध्यम से अपनी वर्तमान ट्रांसफर सीमाएँ देखें।';

  @override
  String get limitEconomyPerTxLabel => 'मोबाइल बैंक \"इकोनॉमी\" — प्रति लेनदेन';

  @override
  String get limitEconomyPerTxValue => '8,000 ₽';

  @override
  String get limitEconomyPerDayLabel => 'मोबाइल बैंक \"इकोनॉमी\" — प्रति दिन';

  @override
  String get limitEconomyPerDayValue => '8,000 ₽';

  @override
  String get limitFullPerTxLabel => 'मोबाइल बैंक \"फुल\" — प्रति लेनदेन';

  @override
  String get limitFullPerTxValue => '50,000 ₽ तक';

  @override
  String get limitFullPerDayLabel => 'मोबाइल बैंक \"फुल\" — प्रति दिन';

  @override
  String get limitFullPerDayValue => '500,000 ₽ तक';

  @override
  String get limitCardToCardLabel => 'कार्ड से कार्ड (ऑनलाइन)';

  @override
  String get limitCardToCardValue => '150,000 ₽ तक';

  @override
  String get exampleIncomingLabel => 'प्राप्ति';

  @override
  String get exampleIncomingText =>
      'SBERBANK प्राप्ति 10000 RUB कार्ड *1234 शेष: 25000 RUB';

  @override
  String get examplePurchaseLabel => 'खरीद';

  @override
  String get examplePurchaseText =>
      'SBERBANK खरीद 1500 RUB कार्ड *1234 STORE NAME शेष: 23500 RUB';

  @override
  String get exampleTransferLabel => 'ट्रांसफर';

  @override
  String get exampleTransferText =>
      'कार्ड *1234 से 5000 RUB ट्रांसफर पूरा। शेष: 18500 RUB.';

  @override
  String get exampleCashWithdrawalLabel => 'नकद निकासी';

  @override
  String get exampleCashWithdrawalText =>
      'नकद निकासी 3000 RUB. कार्ड *1234. शेष: 15500 RUB.';

  @override
  String get ruleRecipientClient =>
      'प्राप्तकर्ता स्बेरबैंक का ग्राहक होना चाहिए और मोबाइल बैंक सक्षम होना चाहिए।';

  @override
  String get rulePhoneLinked =>
      'फोन नंबर प्राप्तकर्ता के कार्ड से लिंक होना चाहिए।';

  @override
  String get ruleSmsIrreversible =>
      'SMS ट्रांसफर वापस नहीं किया जा सकता — पुष्टि से पहले नंबर जाँचें।';

  @override
  String get ruleSpecifyLast4 =>
      'यदि आपके पास कई कार्ड हैं, त्रुटियों से बचने के लिए स्रोत कार्ड का last4 बताएं।';

  @override
  String get ruleEconomyVsFull =>
      '\"इकोनॉमी\" टैरिफ (मुफ़्त) — 8,000 ₽/दिन सीमा। \"फुल\" टैरिफ (सशुल्क) — 100,000 ₽/दिन तक।';

  @override
  String get ruleResetAtMidnight =>
      'दैनिक सीमा मॉस्को समय 00:00 पर रीसेट होती है।';

  @override
  String get feeEconomyLabel => '\"इकोनॉमी\" टैरिफ — ट्रांसफर शुल्क';

  @override
  String get feeEconomyValue => '1% (न्यूनतम 30 ₽)';

  @override
  String get feeFullLabel => '\"फुल\" टैरिफ — ट्रांसफर शुल्क';

  @override
  String get feeFullValue => 'निःशुल्क';

  @override
  String get feeSubscriptionLabel => '\"फुल\" टैरिफ सदस्यता';

  @override
  String get feeSubscriptionValue => '60 ₽/माह';

  @override
  String get opIncoming => 'प्राप्ति';

  @override
  String get opOutgoing => 'व्यय';

  @override
  String get opTransfer => 'ट्रांसफर';

  @override
  String get opUnknown => 'अज्ञात';

  @override
  String smsTargetLabel(String number) {
    return 'To: $number';
  }

  @override
  String get amountRequiredForTransfer =>
      'Amount is required for this transfer.';

  @override
  String get ussdDialogTitle => 'Open USSD?';

  @override
  String get openDialerButton => 'Open Dialer';

  @override
  String get ussdSentHint => 'USSD dialed. Confirm the transfer in the dialer.';

  @override
  String get bankNotAvailable =>
      'Bank commands not configured for your region.';

  @override
  String get transferSmsCommandTitle => 'SMS transfer command';

  @override
  String get transferUssdCommandTitle => 'USSD transfer command';

  @override
  String sendToLabel(String number) {
    return 'Send to: $number';
  }

  @override
  String get exampleLabelShort => 'Example';

  @override
  String bankLimitsContactBanner(String bankName) {
    return 'Transfer limits and fees depend on your plan. Contact $bankName for up-to-date information.';
  }

  @override
  String get notificationExamplesTitle => 'SMS notification examples';

  @override
  String get noBankSelectedBanner =>
      'No bank selected. Choose a country and bank in Settings.';

  @override
  String helpContactNumber(String number) {
    return 'Help: contact $number';
  }

  @override
  String bankDisclaimerGeneric(String bankName) {
    return 'This app is not affiliated with $bankName. Transfers use standard SMS or USSD commands through your mobile carrier.';
  }

  @override
  String get infoActualBannerGeneric =>
      'Information is based on publicly available data. Limits and conditions may change — check with your bank.';

  @override
  String get officialDataTitle => 'Official data';

  @override
  String get officialStatusLabel => 'Source status';

  @override
  String get officialChannelLabel => 'Panel channel';

  @override
  String get officialLastVerifiedLabel => 'Verified on';

  @override
  String get officialStatusVerifiedPublic => 'Verified by public source';

  @override
  String get officialStatusLimitedPublic => 'Public source is limited';

  @override
  String get officialStatusManualVerificationRequired =>
      'Manual verification required';

  @override
  String get officialStatusUnknown => 'Not specified';

  @override
  String get officialWarningLimited =>
      'Official public limits and rules for this exact channel are only partially confirmed. Treat the values as reference and verify with the bank.';

  @override
  String get officialWarningManual =>
      'This bank or channel does not have enough current public official confirmation. The values are shown for reference only.';

  @override
  String get commandChannelUnavailableBanner =>
      'A direct SMS or USSD command channel is not currently verified for this bank. The info panel is shown as a reference to official public data.';

  @override
  String get directTransferButton => 'Transfer';

  @override
  String createSmsAccount(String account) {
    return 'Account: $account';
  }

  @override
  String get recipientAccount => 'Recipient account';

  @override
  String get enterAccountError => 'Enter an account number';

  @override
  String get routeLabel => 'Transfer channel';

  @override
  String get routeSmsPhone => 'SMS by phone';

  @override
  String get routeSmsAccount => 'SMS by account';

  @override
  String get routeUssdPhone => 'USSD by phone';

  @override
  String get routeUssdAccount => 'USSD by account';

  @override
  String get accountQrTitle => 'Account QR';

  @override
  String get qrHintAccountOnly =>
      'Show this QR to the sender — they will use your account in their bank flow before sending';

  @override
  String get yourAccountTitle => 'आपका खाता';

  @override
  String get yourAccountDesc =>
      'आपके खाता नंबर के साथ QR बनाने के लिए उपयोग किया जाता है';

  @override
  String get accountNumberLabel => 'खाता संख्या';

  @override
  String get snackAccountSaved => 'खाता सहेजा गया';

  @override
  String get selectBankFirstHint =>
      'कॉन्फ़िगर करने के लिए ऊपर बैंक चुनें और सहेजें';
}
