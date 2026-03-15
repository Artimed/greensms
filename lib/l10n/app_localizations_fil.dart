// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appName => 'Green SMS';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get save => 'I-save';

  @override
  String get back => 'Bumalik';

  @override
  String get allow => 'Payagan';

  @override
  String get confirm => 'Kumpirmahin';

  @override
  String get clear => 'Linisin';

  @override
  String get settingsTitle => 'Mga Setting';

  @override
  String get onboardingSubtitle =>
      'Visual assistant para sa SMS banking operations';

  @override
  String get onboardingFeatureLocal =>
      'Gumagana nang lokal, hindi kailangan ng internet';

  @override
  String get onboardingFeatureSms => 'Binabasa lang ang huling 10 SMS';

  @override
  String get onboardingFeaturePrivacy => 'Hindi ipinapadala sa labas ang data';

  @override
  String get onboardingFeatureQr =>
      'Ginagamit lang ang QR para ibahagi ang numero ng telepono';

  @override
  String get onboardingButton => 'Humingi ng permiso at magpatuloy';

  @override
  String get accounts => 'Mga account';

  @override
  String get noAccountsYet => 'Wala pang nakilalang account.';

  @override
  String get latestSms => 'Pinakabagong SMS';

  @override
  String get smsNotLoaded => 'Hindi pa na-load ang SMS.';

  @override
  String get qrModeTitle => 'Mode ng QR';

  @override
  String get qrModeSubtitle => 'Buksan ang full-screen camera';

  @override
  String get smsDetailsTitle => 'Detalye ng SMS';

  @override
  String smsDetailsSender(String sender) {
    return 'Nagpadala: $sender';
  }

  @override
  String smsDetailsTime(String time) {
    return 'Oras: $time';
  }

  @override
  String smsDetailsLast4(String last4) {
    return 'Kard: $last4';
  }

  @override
  String get smsDetailsLast4NotFound => 'hindi nahanap';

  @override
  String smsDetailsAmount(String amount) {
    return 'Halaga: $amount';
  }

  @override
  String smsDetailsBalance(String balance) {
    return 'Balanse: $balance';
  }

  @override
  String smsDetailsReference(String reference) {
    return 'Ref: $reference';
  }

  @override
  String smsDetailsType(String type) {
    return 'Uri: $type';
  }

  @override
  String get transferRulesTooltip => 'Mga tuntunin ng transfer';

  @override
  String get accountsLabel => 'Mga account';

  @override
  String get refreshSmsButton => 'I-refresh ang SMS';

  @override
  String get dailyLimitNotSet => 'Hindi pa nakatakda ang daily limit';

  @override
  String get setLimitInSettings => 'Itakda ang limit sa settings';

  @override
  String get dailyTransferLimit => 'Arawang limit sa transfer';

  @override
  String get usedToday => 'Nagamit ngayon';

  @override
  String get remaining => 'Natitira';

  @override
  String get limitExceeded => 'Lumampas sa limit';

  @override
  String get limitWarning80 => 'Mahigit 80% ng daily limit ang nagamit';

  @override
  String get limitExceededBlocked =>
      'Lumampas sa daily limit. Naka-block ang QR transfers.';

  @override
  String accountBalanceLabel(String balance) {
    return 'Balanse: $balance';
  }

  @override
  String get parsedLabel => 'na-parse';

  @override
  String get rawLabel => 'orihinal';

  @override
  String get devicePhoneTitle => 'Telepono ng device';

  @override
  String get devicePhoneDesc =>
      'Ginagamit para gumawa ng QR gamit ang iyong numero';

  @override
  String get phoneNumberLabel => 'Numero ng telepono';

  @override
  String get dailyLimitDesc =>
      'Pinakamataas na daily transfer sa app na ito. Nare-reset sa hatinggabi. Iwanang blangko para alisin ang limit.';

  @override
  String get limitLabel => 'Limitasyon';

  @override
  String get limitHint => 'hal. 50000';

  @override
  String get removeLimitButton => 'Alisin ang limit';

  @override
  String get themeTitle => 'Hitsura';

  @override
  String get languageTitle => 'Wika';

  @override
  String get bankRoutingTitle => 'Bansa at bangko';

  @override
  String get bankRoutingDesc =>
      'Piliin muna ang bansa. Kung higit sa isa ang bangko, pumili ng bangko para sa payment commands.';

  @override
  String get countryLabel => 'Bansa';

  @override
  String get bankLabel => 'Bangko';

  @override
  String get bankAutoSelectedHint =>
      'Isang bangko lang ang available para sa bansang ito, auto-selected na ito.';

  @override
  String get referenceOnlyBadge => 'reference only';

  @override
  String get bankReferenceOnlyHint =>
      'For this country, the bank is available as a reference source for limits and rules only. Direct payment commands are not currently verified.';

  @override
  String get languageEnglish => 'Ingles';

  @override
  String get languageRussian => 'Ruso';

  @override
  String get languageHindi => 'Wikang Hindi';

  @override
  String get languageKazakh => 'Wikang Kazakh';

  @override
  String get languageUzbek => 'Wikang Uzbek';

  @override
  String get languageTagalog => 'Tagalog';

  @override
  String get languageIndonesian => 'Wikang Indonesian';

  @override
  String get permissionsTitle => 'Mga permiso';

  @override
  String get readSmsTitle => 'Basahin ang SMS';

  @override
  String get readSmsDesc =>
      'Kailangan para mabasa ang mga papasok na SMS at ma-update ang data.';

  @override
  String get directSmsTitle => 'Direktang pagpapadala ng SMS';

  @override
  String get directSmsDesc =>
      'Magpadala ng SMS nang direkta nang hindi binubuksan ang messaging app';

  @override
  String get directSmsPermissionRequired =>
      'Kailangan ang pahintulot na SEND_SMS. Ibigay ito sa system app settings.';

  @override
  String get directSmsEnabledSnack =>
      'Naka-enable ang direktang pagpapadala ng SMS';

  @override
  String get directSmsDisabledSnack =>
      'Naka-disable ang direktang pagpapadala ng SMS';

  @override
  String get openSettingsButton => 'Mga setting';

  @override
  String get permissionsManageInSystem =>
      'Sa system app settings lang puwedeng i-disable ang permiso.';

  @override
  String get cameraTitle => 'Kamera';

  @override
  String get cameraDesc => 'Para sa QR scanning';

  @override
  String get clearLocalDataTitle => 'I-clear ang lokal na data';

  @override
  String get clearLocalDataDesc => 'SMS, accounts, QR profiles, at history';

  @override
  String get aboutTitle => 'Tungkol sa app';

  @override
  String get aboutVersion => 'Green SMS v1.0\nLokal na app, walang internet';

  @override
  String get snackLimitRemoved => 'Inalis ang limit';

  @override
  String snackLimitSet(String amount) {
    return 'Naitakda ang limit: $amount';
  }

  @override
  String get snackPhoneSaved => 'Na-save ang telepono';

  @override
  String get snackDataCleared => 'Na-clear ang lokal na data';

  @override
  String get clearDataDialogTitle => 'I-clear ang data?';

  @override
  String get clearDataDialogContent =>
      'Mabubura ang SMS, accounts, QR profiles, at history.';

  @override
  String get cameraPermissionNeeded => 'Kailangan ang access sa camera';

  @override
  String get scanHint => 'Itutok ang camera sa QR code';

  @override
  String get scanButton => 'I-scan';

  @override
  String get phoneTransferButton => 'Sa telepono';

  @override
  String get limitWarningTitle => 'Lumampas sa daily limit';

  @override
  String limitWarningContent(String amount, String remaining) {
    return 'Halaga ng transfer: $amount\nNatitirang limit: $remaining\n\nLumalagpas ang transfer sa daily limit. Ituloy pa rin?';
  }

  @override
  String get sendAnywayButton => 'Ituloy pa rin';

  @override
  String get createSmsDialogTitle => 'Gumawa ng SMS?';

  @override
  String createSmsPhone(String phone) {
    return 'Telepono: $phone';
  }

  @override
  String createSmsText(String text) {
    return 'Teksto: $text';
  }

  @override
  String get qrNotRecognized => 'Hindi nakilala ang QR bilang internal format.';

  @override
  String get transferCancelledLimit =>
      'Kinansela ang transfer — lampas sa limit.';

  @override
  String get smsSentSuccess =>
      'Nabuo ang SMS. Kumpirmahin ang pagpapadala sa messaging app.';

  @override
  String get scanningContinues => 'Tuloy ang pag-scan.';

  @override
  String get noQrInImage => 'Walang QR code sa napiling larawan.';

  @override
  String get qrFoundNoData => 'May nahanap na QR pero walang data.';

  @override
  String get setPhoneFirst => 'Itakda muna ang telepono ng device sa settings.';

  @override
  String get setAccountFirst =>
      'Itakda muna ang numero ng account sa settings.';

  @override
  String get chooseChannelTitle => 'Pumili ng channel ng transfer';

  @override
  String get scanningActive => 'Aktibo ang pag-scan.';

  @override
  String get phoneQrTitle => 'QR ng Telepono';

  @override
  String phoneLabel(String phone) {
    return 'Telepono: $phone';
  }

  @override
  String get qrGenerationTitle => 'Pagbuo ng QR';

  @override
  String get noProfile => 'Walang profile';

  @override
  String get profileLabel => 'Profil';

  @override
  String get profileNameLabel => 'Pangalan ng profile';

  @override
  String get recipientPhone => 'Telepono ng tatanggap';

  @override
  String get phoneTransferInputTitle => 'Transfer na walang QR';

  @override
  String get enterPhoneError => 'Maglagay ng numero ng telepono';

  @override
  String get amountOptional => 'Halaga (opsyonal)';

  @override
  String get amountRequiredLabel => 'Halaga ng transfer (kailangan)';

  @override
  String get enterAmountError => 'Ilagay ang halaga ng transfer';

  @override
  String get sourceLast4Optional =>
      'Pinanggalingang card/account last4 (opsyonal)';

  @override
  String get sourceLast4Hint => 'Halimbawa: 1234';

  @override
  String get invalidLast4Error => 'Maglagay ng eksaktong 4 na digit';

  @override
  String get sourceAccountOptionalSection => 'Source account (opsyonal)';

  @override
  String get sberAmountRequired =>
      'Kailangan ang halaga para sa transfer sa 900.';

  @override
  String get smsTarget900 => 'Numero: 900';

  @override
  String get noteOptional => 'Tala (opsyonal)';

  @override
  String get myQrButton => 'My QR';

  @override
  String get qrAmountButton => 'QR na may halaga';

  @override
  String get showQrButton => 'Ipakita ang QR';

  @override
  String get saveProfileButton => 'I-save ang profile';

  @override
  String get composeSmsButton => 'Bumuo ng SMS';

  @override
  String get qrHintPhoneOnly =>
      'Ipakita ang QR na ito sa tatanggap — siya ang maglalagay ng halaga at source account bago magpadala';

  @override
  String get qrHint =>
      'Ipakita ang QR na ito sa tatanggap — i-scan niya ito at gagawa ng transfer';

  @override
  String get profileSaved => 'Na-save ang profile';

  @override
  String qrError(Object error) {
    return 'Error sa QR: $error';
  }

  @override
  String get transferLimitsTitle => 'Mga limit at tuntunin ng transfer';

  @override
  String get openSberSiteTooltip => 'Buksan ang website ng Sberbank';

  @override
  String get infoActualBanner =>
      'Ang impormasyong ito ay para sa kasalukuyang bersyon ng app. Maaaring magbago ang limits at kondisyon — tingnan sa sberbank.ru o tumawag sa 900.';

  @override
  String get smsCommandsTitle => 'SMS commands (sa numerong 900)';

  @override
  String get limitsTitle => 'Mga limit ng transfer';

  @override
  String get notificationFormatsTitle =>
      'Mga format ng SMS notification ng Sberbank';

  @override
  String get importantRulesTitle => 'Mahalagang tuntunin';

  @override
  String get feesTitle => 'Mga bayarin';

  @override
  String get cannotOpenBrowser => 'Hindi mabuksan ang browser';

  @override
  String get number900Copied => 'Nakopya ang numerong 900';

  @override
  String copiedCommand(String command) {
    return 'Nakopya: $command';
  }

  @override
  String get officialSberSite => 'Opisyal na website ng Sberbank';

  @override
  String get officialSiteButton => 'Opisyal na website';

  @override
  String get helpContact900 => 'Tulong: makipag-ugnayan sa 900';

  @override
  String get disclaimerText =>
      'Hindi opisyal na produkto ng Sberbank ang app na ito. Tinutulungan lang nito ang pagbasa ng SMS at pagbuo ng commands — lahat ng transfer ay ginagawa sa standard SMS commands sa pamamagitan ng iyong mobile carrier.';

  @override
  String get personalLimitBanner =>
      'Para malaman ang personal mong limit — magpadala ng SMS «ЛИМИТ» sa 900. Maaaring mag-iba ang limit ayon sa iyong tariff at history ng transaksyon.';

  @override
  String get phoneCopied => 'Nakopya ang numero ng telepono';

  @override
  String get copyPhoneButton => 'Kopyahin ang telepono';

  @override
  String noteLabel(String note) {
    return 'Tala: $note';
  }

  @override
  String qrNotRecognizedWithRaw(String raw) {
    return 'Hindi nakilala ang QR bilang internal format: $raw';
  }

  @override
  String get cmdTransferMain => 'ПЕРЕВОД [phone] [amount]';

  @override
  String get cmdTransferMainDesc =>
      'Transfer sa numero ng telepono mula sa pangunahing card.\nHalimbawa: ПЕРЕВОД 79161234567 1000';

  @override
  String get cmdTransferWithCard => 'ПЕРЕВОД [phone] [amount] [last4]';

  @override
  String get cmdTransferWithCardDesc =>
      'Transfer mula sa partikular na card.\nHalimbawa: ПЕРЕВОД 79161234567 500 1234';

  @override
  String get cmdBalance => 'БАЛАНС';

  @override
  String get cmdBalanceDesc => 'Balanse ng pangunahing card.';

  @override
  String get cmdBalanceCard => 'БАЛАНС [last4]';

  @override
  String get cmdBalanceCardDesc => 'Balanse ng partikular na card.';

  @override
  String get cmdHistory => 'ИСТОРИЯ';

  @override
  String get cmdHistoryDesc => 'Huling 5 transaksyon sa pangunahing card.';

  @override
  String get cmdBlock => 'БЛОКИРОВКА [last4]';

  @override
  String get cmdBlockDesc => 'Pansamantalang pag-block ng card.';

  @override
  String get cmdLimit => 'ЛИМИТ';

  @override
  String get cmdLimitDesc =>
      'Tingnan ang kasalukuyang transfer limits sa pamamagitan ng SMS.';

  @override
  String get limitEconomyPerTxLabel =>
      'Mobile Bank \"Economy\" — bawat transaksyon';

  @override
  String get limitEconomyPerTxValue => '8,000 ₽';

  @override
  String get limitEconomyPerDayLabel => 'Mobile Bank \"Economy\" — bawat araw';

  @override
  String get limitEconomyPerDayValue => '8,000 ₽';

  @override
  String get limitFullPerTxLabel => 'Mobile Bank \"Full\" — bawat transaksyon';

  @override
  String get limitFullPerTxValue => 'hanggang 50,000 ₽';

  @override
  String get limitFullPerDayLabel => 'Mobile Bank \"Full\" — bawat araw';

  @override
  String get limitFullPerDayValue => 'hanggang 500,000 ₽';

  @override
  String get limitCardToCardLabel => 'Kard sa kard (online)';

  @override
  String get limitCardToCardValue => 'hanggang 150,000 ₽';

  @override
  String get exampleIncomingLabel => 'Pagpasok';

  @override
  String get exampleIncomingText =>
      'SBERBANK Pagpasok 10000 RUB Card *1234 Balanse: 25000 RUB';

  @override
  String get examplePurchaseLabel => 'Pagbili';

  @override
  String get examplePurchaseText =>
      'SBERBANK Pagbili 1500 RUB Card *1234 PANGALAN NG TINDAHAN Balanse: 23500 RUB';

  @override
  String get exampleTransferLabel => 'Paglipat';

  @override
  String get exampleTransferText =>
      'Transfer 5000 RUB mula sa card *1234 naisagawa. Balanse: 18500 RUB.';

  @override
  String get exampleCashWithdrawalLabel => 'Pag-withdraw ng cash';

  @override
  String get exampleCashWithdrawalText =>
      'Cash withdrawal 3000 RUB. Card *1234. Balanse: 15500 RUB.';

  @override
  String get ruleRecipientClient =>
      'Dapat kliyente ng Sberbank ang tatanggap at naka-enable ang Mobile Bank.';

  @override
  String get rulePhoneLinked =>
      'Dapat naka-link ang numero ng telepono sa card ng tatanggap.';

  @override
  String get ruleSmsIrreversible =>
      'Hindi naibabalik ang SMS transfer — suriin ang numero bago kumpirmahin.';

  @override
  String get ruleSpecifyLast4 =>
      'Kung marami kang card, ilagay ang last4 ng source card para maiwasan ang error.';

  @override
  String get ruleEconomyVsFull =>
      'Tariff na \"Economy\" (libre) — limit na 8,000 ₽/araw. Tariff na \"Full\" (bayad) — hanggang 100,000 ₽/araw.';

  @override
  String get ruleResetAtMidnight =>
      'Nare-reset ang daily limit sa 00:00 oras ng Moscow.';

  @override
  String get feeEconomyLabel => 'Tariff na \"Economy\" — bayad sa transfer';

  @override
  String get feeEconomyValue => '1% (hindi bababa sa 30 ₽)';

  @override
  String get feeFullLabel => 'Tariff na \"Full\" — bayad sa transfer';

  @override
  String get feeFullValue => 'Libre';

  @override
  String get feeSubscriptionLabel => 'Subscription ng \"Full\" tariff';

  @override
  String get feeSubscriptionValue => '60 ₽/buwan';

  @override
  String get opIncoming => 'papasok';

  @override
  String get opOutgoing => 'palabas';

  @override
  String get opTransfer => 'paglipat';

  @override
  String get opUnknown => 'hindi alam';

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
  String get yourAccountTitle => 'Ang iyong account';

  @override
  String get yourAccountDesc =>
      'Ginagamit para gumawa ng QR gamit ang iyong account number';

  @override
  String get accountNumberLabel => 'Numero ng account';

  @override
  String get snackAccountSaved => 'Nai-save ang account';

  @override
  String get selectBankFirstHint =>
      'Pumili at i-save ang bangko sa itaas para i-configure';
}
