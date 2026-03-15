// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Green SMS';

  @override
  String get cancel => 'Hủy';

  @override
  String get save => 'Lưu';

  @override
  String get back => 'Quay lại';

  @override
  String get allow => 'Cho phép';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get clear => 'Xóa';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get onboardingSubtitle =>
      'Trợ lý trực quan cho các thao tác ngân hàng qua SMS';

  @override
  String get onboardingFeatureLocal => 'Hoạt động cục bộ, không cần internet';

  @override
  String get onboardingFeatureSms => 'Chỉ đọc 10 SMS gần nhất';

  @override
  String get onboardingFeaturePrivacy => 'Dữ liệu không được gửi ra bên ngoài';

  @override
  String get onboardingFeatureQr => 'QR chỉ dùng để chia sẻ số điện thoại';

  @override
  String get onboardingButton => 'Cấp quyền và tiếp tục';

  @override
  String get accounts => 'Tài khoản';

  @override
  String get noAccountsYet => 'Chưa có tài khoản nào được nhận diện.';

  @override
  String get latestSms => 'SMS mới nhất';

  @override
  String get smsNotLoaded => 'Chưa tải SMS.';

  @override
  String get qrModeTitle => 'Chế độ QR';

  @override
  String get qrModeSubtitle => 'Mở camera toàn màn hình';

  @override
  String get smsDetailsTitle => 'SMS Details';

  @override
  String smsDetailsSender(String sender) {
    return 'Sender: $sender';
  }

  @override
  String smsDetailsTime(String time) {
    return 'Time: $time';
  }

  @override
  String smsDetailsLast4(String last4) {
    return 'Card: $last4';
  }

  @override
  String get smsDetailsLast4NotFound => 'not found';

  @override
  String smsDetailsAmount(String amount) {
    return 'Amount: $amount';
  }

  @override
  String smsDetailsBalance(String balance) {
    return 'Balance: $balance';
  }

  @override
  String smsDetailsReference(String reference) {
    return 'Ref: $reference';
  }

  @override
  String smsDetailsType(String type) {
    return 'Type: $type';
  }

  @override
  String get transferRulesTooltip => 'Transfer rules';

  @override
  String get accountsLabel => 'Accounts';

  @override
  String get refreshSmsButton => 'Refresh SMS';

  @override
  String get dailyLimitNotSet => 'Daily limit not set';

  @override
  String get setLimitInSettings => 'Set limit in settings';

  @override
  String get dailyTransferLimit => 'Giới hạn chuyển tiền hằng ngày';

  @override
  String get usedToday => 'Used today';

  @override
  String get remaining => 'Remaining';

  @override
  String get limitExceeded => 'Limit exceeded';

  @override
  String get limitWarning80 => 'More than 80% of daily limit used';

  @override
  String get limitExceededBlocked =>
      'Daily limit exceeded. QR transfers are blocked.';

  @override
  String accountBalanceLabel(String balance) {
    return 'Balance: $balance';
  }

  @override
  String get parsedLabel => 'parsed';

  @override
  String get rawLabel => 'raw';

  @override
  String get devicePhoneTitle => 'Số điện thoại thiết bị';

  @override
  String get devicePhoneDesc => 'Dùng để tạo QR với số của bạn';

  @override
  String get phoneNumberLabel => 'Số điện thoại';

  @override
  String get dailyLimitDesc =>
      'Maximum daily transfer amount through this app. Resets at midnight. Leave empty to remove the limit.';

  @override
  String get limitLabel => 'Giới hạn';

  @override
  String get limitHint => 'e.g. 50000';

  @override
  String get removeLimitButton => 'Remove limit';

  @override
  String get themeTitle => 'Giao diện';

  @override
  String get languageTitle => 'Ngôn ngữ';

  @override
  String get bankRoutingTitle => 'Quốc gia và ngân hàng';

  @override
  String get bankRoutingDesc =>
      'Choose country first. If there are multiple banks, select the bank for payment commands.';

  @override
  String get countryLabel => 'Quốc gia';

  @override
  String get bankLabel => 'Ngân hàng';

  @override
  String get bankAutoSelectedHint =>
      'Only one bank is available for this country, selected automatically.';

  @override
  String get referenceOnlyBadge => 'reference only';

  @override
  String get bankReferenceOnlyHint =>
      'For this country, the bank is available as a reference source for limits and rules only. Direct payment commands are not currently verified.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageKazakh => 'Kazakh';

  @override
  String get languageUzbek => 'Uzbek';

  @override
  String get languageTagalog => 'Tagalog';

  @override
  String get languageIndonesian => 'Indonesian';

  @override
  String get permissionsTitle => 'Quyền truy cập';

  @override
  String get readSmsTitle => 'Đọc SMS';

  @override
  String get readSmsDesc =>
      'Allows reading incoming SMS for transaction parsing';

  @override
  String get directSmsTitle => 'Gửi SMS trực tiếp';

  @override
  String get directSmsDesc =>
      'Send SMS directly from app without opening messaging app';

  @override
  String get directSmsPermissionRequired =>
      'SEND_SMS permission is required. Grant it in system app settings.';

  @override
  String get directSmsEnabledSnack => 'Direct SMS sending enabled';

  @override
  String get directSmsDisabledSnack => 'Direct SMS sending disabled';

  @override
  String get openSettingsButton => 'Settings';

  @override
  String get permissionsManageInSystem =>
      'You can disable permissions in system app settings.';

  @override
  String get cameraTitle => 'Máy ảnh';

  @override
  String get cameraDesc => 'For scanning QR';

  @override
  String get clearLocalDataTitle => 'Xóa dữ liệu cục bộ';

  @override
  String get clearLocalDataDesc => 'SMS, accounts, QR profiles and history';

  @override
  String get aboutTitle => 'Giới thiệu';

  @override
  String get aboutVersion =>
      'Green SMS v1.0\nỨng dụng cục bộ, không cần internet';

  @override
  String get snackLimitRemoved => 'Limit removed';

  @override
  String snackLimitSet(String amount) {
    return 'Limit set: $amount';
  }

  @override
  String get snackPhoneSaved => 'Phone saved';

  @override
  String get snackDataCleared => 'Local data cleared';

  @override
  String get clearDataDialogTitle => 'Clear data?';

  @override
  String get clearDataDialogContent =>
      'SMS, accounts, QR profiles and history will be deleted.';

  @override
  String get cameraPermissionNeeded => 'Camera access required';

  @override
  String get scanHint => 'Point camera at QR code';

  @override
  String get scanButton => 'Scan';

  @override
  String get phoneTransferButton => 'By phone';

  @override
  String get limitWarningTitle => 'Daily limit exceeded';

  @override
  String limitWarningContent(String amount, String remaining) {
    return 'Transfer amount: $amount\nLimit remaining: $remaining\n\nTransfer exceeds daily limit. Proceed anyway?';
  }

  @override
  String get sendAnywayButton => 'Send anyway';

  @override
  String get createSmsDialogTitle => 'Create SMS?';

  @override
  String createSmsPhone(String phone) {
    return 'Phone: $phone';
  }

  @override
  String createSmsText(String text) {
    return 'Text: $text';
  }

  @override
  String get qrNotRecognized => 'QR not recognized as internal format.';

  @override
  String get transferCancelledLimit => 'Transfer cancelled — limit exceeded.';

  @override
  String get smsSentSuccess =>
      'SMS created. Confirm sending in the messaging app.';

  @override
  String get scanningContinues => 'Scanning continues.';

  @override
  String get noQrInImage => 'No QR code found in the selected image.';

  @override
  String get qrFoundNoData => 'QR found but no data.';

  @override
  String get setPhoneFirst => 'First set the device phone in settings.';

  @override
  String get setAccountFirst =>
      'Vui lòng đặt số tài khoản trong Cài đặt trước.';

  @override
  String get chooseChannelTitle => 'Chọn kênh chuyển khoản';

  @override
  String get scanningActive => 'Scanning active.';

  @override
  String get phoneQrTitle => 'Phone QR';

  @override
  String phoneLabel(String phone) {
    return 'Phone: $phone';
  }

  @override
  String get qrGenerationTitle => 'QR Generation';

  @override
  String get noProfile => 'No profile';

  @override
  String get profileLabel => 'Profile';

  @override
  String get profileNameLabel => 'Profile name';

  @override
  String get recipientPhone => 'Recipient phone';

  @override
  String get phoneTransferInputTitle => 'Transfer without QR';

  @override
  String get enterPhoneError => 'Enter a phone number';

  @override
  String get amountOptional => 'Amount (optional)';

  @override
  String get amountRequiredLabel => 'Transfer amount (required)';

  @override
  String get enterAmountError => 'Enter transfer amount';

  @override
  String get sourceLast4Optional => 'Source card/account last4 (optional)';

  @override
  String get sourceLast4Hint => 'Example: 1234';

  @override
  String get invalidLast4Error => 'Enter exactly 4 digits';

  @override
  String get sourceAccountOptionalSection => 'Source account (optional)';

  @override
  String get sberAmountRequired => 'Amount is required for transfer via 900.';

  @override
  String get smsTarget900 => 'To: 900';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get myQrButton => 'My QR';

  @override
  String get qrAmountButton => 'QR with amount';

  @override
  String get showQrButton => 'Show QR';

  @override
  String get saveProfileButton => 'Save profile';

  @override
  String get composeSmsButton => 'Compose SMS';

  @override
  String get qrHintPhoneOnly =>
      'Show this QR to the recipient — they will enter amount and source account before sending';

  @override
  String get qrHint =>
      'Show this QR to the recipient — they will scan and make the transfer';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String qrError(Object error) {
    return 'QR error: $error';
  }

  @override
  String get transferLimitsTitle => 'Transfer limits and rules';

  @override
  String get openSberSiteTooltip => 'Open Sberbank website';

  @override
  String get infoActualBanner =>
      'Information is current as of this app version. Limits and conditions may change — check at sberbank.ru or call 900.';

  @override
  String get smsCommandsTitle => 'SMS commands (to number 900)';

  @override
  String get limitsTitle => 'Giới hạn chuyển tiền';

  @override
  String get notificationFormatsTitle => 'Sberbank SMS notification formats';

  @override
  String get importantRulesTitle => 'Important rules';

  @override
  String get feesTitle => 'Fees';

  @override
  String get cannotOpenBrowser => 'Could not open browser';

  @override
  String get number900Copied => 'Number 900 copied';

  @override
  String copiedCommand(String command) {
    return 'Copied: $command';
  }

  @override
  String get officialSberSite => 'Official Sberbank website';

  @override
  String get officialSiteButton => 'Official website';

  @override
  String get helpContact900 => 'Help: contact 900';

  @override
  String get disclaimerText =>
      'This app is not an official Sberbank product. It only helps read SMS and compose commands — all transfers are made via standard SMS commands through your mobile carrier.';

  @override
  String get personalLimitBanner =>
      'To check your personal limit — send SMS «ЛИМИТ» to 900. Limits may vary depending on your tariff and transaction history.';

  @override
  String get phoneCopied => 'Phone number copied';

  @override
  String get copyPhoneButton => 'Copy phone';

  @override
  String noteLabel(String note) {
    return 'Note: $note';
  }

  @override
  String qrNotRecognizedWithRaw(String raw) {
    return 'QR is not recognized as internal format: $raw';
  }

  @override
  String get cmdTransferMain => 'ПЕРЕВОД [phone] [amount]';

  @override
  String get cmdTransferMainDesc =>
      'Transfer to a phone number from the main card.\nExample: ПЕРЕВОД 79161234567 1000';

  @override
  String get cmdTransferWithCard => 'ПЕРЕВОД [phone] [amount] [last4]';

  @override
  String get cmdTransferWithCardDesc =>
      'Transfer from a specific card.\nExample: ПЕРЕВОД 79161234567 500 1234';

  @override
  String get cmdBalance => 'БАЛАНС';

  @override
  String get cmdBalanceDesc => 'Main card balance.';

  @override
  String get cmdBalanceCard => 'БАЛАНС [last4]';

  @override
  String get cmdBalanceCardDesc => 'Specific card balance.';

  @override
  String get cmdHistory => 'ИСТОРИЯ';

  @override
  String get cmdHistoryDesc => 'Last 5 transactions on the main card.';

  @override
  String get cmdBlock => 'БЛОКИРОВКА [last4]';

  @override
  String get cmdBlockDesc => 'Temporary card block.';

  @override
  String get cmdLimit => 'ЛИМИТ';

  @override
  String get cmdLimitDesc => 'Check your current transfer limits via SMS.';

  @override
  String get limitEconomyPerTxLabel =>
      'Mobile Bank \"Economy\" — per transaction';

  @override
  String get limitEconomyPerTxValue => '8,000 ₽';

  @override
  String get limitEconomyPerDayLabel => 'Mobile Bank \"Economy\" — per day';

  @override
  String get limitEconomyPerDayValue => '8,000 ₽';

  @override
  String get limitFullPerTxLabel => 'Mobile Bank \"Full\" — per transaction';

  @override
  String get limitFullPerTxValue => 'up to 50,000 ₽';

  @override
  String get limitFullPerDayLabel => 'Mobile Bank \"Full\" — per day';

  @override
  String get limitFullPerDayValue => 'up to 500,000 ₽';

  @override
  String get limitCardToCardLabel => 'Card to card (online)';

  @override
  String get limitCardToCardValue => 'up to 150,000 ₽';

  @override
  String get exampleIncomingLabel => 'Incoming';

  @override
  String get exampleIncomingText =>
      'SBERBANK Incoming 10000 RUB Card *1234 Balance: 25000 RUB';

  @override
  String get examplePurchaseLabel => 'Purchase';

  @override
  String get examplePurchaseText =>
      'SBERBANK Purchase 1500 RUB Card *1234 STORE NAME Balance: 23500 RUB';

  @override
  String get exampleTransferLabel => 'Transfer';

  @override
  String get exampleTransferText =>
      'Transfer 5000 RUB from card *1234 completed. Balance: 18500 RUB.';

  @override
  String get exampleCashWithdrawalLabel => 'Cash withdrawal';

  @override
  String get exampleCashWithdrawalText =>
      'Cash withdrawal 3000 RUB. Card *1234. Balance: 15500 RUB.';

  @override
  String get ruleRecipientClient =>
      'Recipient must be a Sberbank client and have Mobile Bank enabled.';

  @override
  String get rulePhoneLinked =>
      'Phone number must be linked to recipient\'s card.';

  @override
  String get ruleSmsIrreversible =>
      'SMS transfer cannot be reversed — verify recipient number before confirmation.';

  @override
  String get ruleSpecifyLast4 =>
      'If you have multiple cards, specify source card last4 to avoid mistakes.';

  @override
  String get ruleEconomyVsFull =>
      '\"Economy\" tariff (free) — 8,000 ₽/day limit. \"Full\" tariff (paid) — up to 100,000 ₽/day.';

  @override
  String get ruleResetAtMidnight => 'Daily limit resets at 00:00 Moscow time.';

  @override
  String get feeEconomyLabel => '\"Economy\" tariff — transfer fee';

  @override
  String get feeEconomyValue => '1% (min. 30 ₽)';

  @override
  String get feeFullLabel => '\"Full\" tariff — transfer fee';

  @override
  String get feeFullValue => 'Free';

  @override
  String get feeSubscriptionLabel => '\"Full\" tariff subscription';

  @override
  String get feeSubscriptionValue => '60 ₽/month';

  @override
  String get opIncoming => 'incoming';

  @override
  String get opOutgoing => 'outgoing';

  @override
  String get opTransfer => 'transfer';

  @override
  String get opUnknown => 'unknown';

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
  String get yourAccountTitle => 'Tài khoản của bạn';

  @override
  String get yourAccountDesc => 'Dùng để tạo mã QR với số tài khoản của bạn';

  @override
  String get accountNumberLabel => 'Số tài khoản';

  @override
  String get snackAccountSaved => 'Đã lưu tài khoản';

  @override
  String get selectBankFirstHint => 'Chọn và lưu ngân hàng ở trên để cấu hình';
}
