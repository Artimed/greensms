// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appName => 'Green SMS';

  @override
  String get cancel => 'Болдырмау';

  @override
  String get save => 'Сақтау';

  @override
  String get back => 'Артқа';

  @override
  String get allow => 'Рұқсат беру';

  @override
  String get confirm => 'Растау';

  @override
  String get clear => 'Тазалау';

  @override
  String get settingsTitle => 'Параметрлер';

  @override
  String get onboardingSubtitle =>
      'SMS банкинг операцияларына арналған визуалды көмекші';

  @override
  String get onboardingFeatureLocal =>
      'Жергілікті жұмыс істейді, интернет қажет емес';

  @override
  String get onboardingFeatureSms => 'Тек соңғы 10 SMS хабарламаны оқиды';

  @override
  String get onboardingFeaturePrivacy => 'Деректер сыртқа жіберілмейді';

  @override
  String get onboardingFeatureQr =>
      'QR тек телефон нөмірін бөлісу үшін қолданылады';

  @override
  String get onboardingButton => 'Рұқсат сұрап, жалғастыру';

  @override
  String get accounts => 'Шоттар';

  @override
  String get noAccountsYet => 'Әлі танылған шоттар жоқ.';

  @override
  String get latestSms => 'Соңғы SMS';

  @override
  String get smsNotLoaded => 'SMS әлі жүктелмеді.';

  @override
  String get qrModeTitle => 'QR режимі';

  @override
  String get qrModeSubtitle => 'Толық экран камерасын ашу';

  @override
  String get smsDetailsTitle => 'SMS мәліметтері';

  @override
  String smsDetailsSender(String sender) {
    return 'Жіберуші: $sender';
  }

  @override
  String smsDetailsTime(String time) {
    return 'Уақыты: $time';
  }

  @override
  String smsDetailsLast4(String last4) {
    return 'Карта: $last4';
  }

  @override
  String get smsDetailsLast4NotFound => 'табылмады';

  @override
  String smsDetailsAmount(String amount) {
    return 'Сома: $amount';
  }

  @override
  String smsDetailsBalance(String balance) {
    return 'Қалдық: $balance';
  }

  @override
  String smsDetailsReference(String reference) {
    return 'Ref: $reference';
  }

  @override
  String smsDetailsType(String type) {
    return 'Түрі: $type';
  }

  @override
  String get transferRulesTooltip => 'Аудару ережелері';

  @override
  String get accountsLabel => 'Шоттар';

  @override
  String get refreshSmsButton => 'SMS жаңарту';

  @override
  String get dailyLimitNotSet => 'Күндік лимит орнатылмаған';

  @override
  String get setLimitInSettings => 'Лимитті параметрлерде орнатыңыз';

  @override
  String get dailyTransferLimit => 'Күндік аудару лимиті';

  @override
  String get usedToday => 'Бүгін пайдаланылған';

  @override
  String get remaining => 'Қалғаны';

  @override
  String get limitExceeded => 'Лимит асқан';

  @override
  String get limitWarning80 => 'Күндік лимиттің 80%-дан астамы пайдаланылды';

  @override
  String get limitExceededBlocked =>
      'Күндік лимит асқан. QR арқылы аударым бұғатталды.';

  @override
  String accountBalanceLabel(String balance) {
    return 'Қалдық: $balance';
  }

  @override
  String get parsedLabel => 'талданған';

  @override
  String get rawLabel => 'шикі';

  @override
  String get devicePhoneTitle => 'Құрылғы телефоны';

  @override
  String get devicePhoneDesc => 'Нөміріңізбен QR жасау үшін қолданылады';

  @override
  String get phoneNumberLabel => 'Телефон нөмірі';

  @override
  String get dailyLimitDesc =>
      'Осы қолданба арқылы бір күндегі максималды аудару сомасы. Түн ортасында жаңартылады. Лимитті алып тастау үшін бос қалдырыңыз.';

  @override
  String get limitLabel => 'Лимит';

  @override
  String get limitHint => 'мысалы: 50000';

  @override
  String get removeLimitButton => 'Лимитті алып тастау';

  @override
  String get themeTitle => 'Көрініс';

  @override
  String get languageTitle => 'Тіл';

  @override
  String get bankRoutingTitle => 'Ел және банк';

  @override
  String get bankRoutingDesc =>
      'Алдымен елді таңдаңыз. Егер бірнеше банк болса, төлем командасы үшін банкті таңдаңыз.';

  @override
  String get countryLabel => 'Ел';

  @override
  String get bankLabel => 'Банк';

  @override
  String get bankAutoSelectedHint =>
      'Бұл ел үшін бір ғана банк қолжетімді, ол автоматты түрде таңдалды.';

  @override
  String get referenceOnlyBadge => 'reference only';

  @override
  String get bankReferenceOnlyHint =>
      'For this country, the bank is available as a reference source for limits and rules only. Direct payment commands are not currently verified.';

  @override
  String get languageEnglish => 'Ағылшын';

  @override
  String get languageRussian => 'Орыс';

  @override
  String get languageHindi => 'Хинди';

  @override
  String get languageKazakh => 'Қазақ';

  @override
  String get languageUzbek => 'Өзбек';

  @override
  String get languageTagalog => 'Тагалог';

  @override
  String get languageIndonesian => 'Индонезия';

  @override
  String get permissionsTitle => 'Рұқсаттар';

  @override
  String get readSmsTitle => 'SMS оқу';

  @override
  String get readSmsDesc =>
      'Кіріс SMS-терді оқып, деректерді жаңарту үшін керек.';

  @override
  String get directSmsTitle => 'SMS-ті тікелей жіберу';

  @override
  String get directSmsDesc =>
      'Хабарлама қолданбасын ашпай SMS-ті тікелей жіберу';

  @override
  String get directSmsPermissionRequired =>
      'SEND_SMS рұқсаты қажет. Оны қолданбаның жүйелік баптауларында беріңіз.';

  @override
  String get directSmsEnabledSnack => 'SMS-ті тікелей жіберу қосылды';

  @override
  String get directSmsDisabledSnack => 'SMS-ті тікелей жіберу өшірілді';

  @override
  String get openSettingsButton => 'Баптаулар';

  @override
  String get permissionsManageInSystem =>
      'Рұқсаттарды өшіру қолданбаның жүйелік баптауларында жасалады.';

  @override
  String get cameraTitle => 'Камера';

  @override
  String get cameraDesc => 'QR сканерлеу үшін';

  @override
  String get clearLocalDataTitle => 'Жергілікті деректерді тазалау';

  @override
  String get clearLocalDataDesc => 'SMS, шоттар, QR профильдері және тарих';

  @override
  String get aboutTitle => 'Қосымша туралы';

  @override
  String get aboutVersion =>
      'Green SMS v1.0\nЖергілікті қосымша, интернет қажет емес';

  @override
  String get snackLimitRemoved => 'Лимит алынды';

  @override
  String snackLimitSet(String amount) {
    return 'Лимит орнатылды: $amount';
  }

  @override
  String get snackPhoneSaved => 'Телефон сақталды';

  @override
  String get snackDataCleared => 'Жергілікті деректер тазартылды';

  @override
  String get clearDataDialogTitle => 'Деректерді тазалау?';

  @override
  String get clearDataDialogContent =>
      'SMS, шоттар, QR профильдері және тарих өшіріледі.';

  @override
  String get cameraPermissionNeeded => 'Камераға рұқсат қажет';

  @override
  String get scanHint => 'Камераны QR кодқа бағыттаңыз';

  @override
  String get scanButton => 'Сканерлеу';

  @override
  String get phoneTransferButton => 'Телефонмен';

  @override
  String get limitWarningTitle => 'Күндік лимит асқан';

  @override
  String limitWarningContent(String amount, String remaining) {
    return 'Аудару сомасы: $amount\nҚалған лимит: $remaining\n\nАудару күндік лимиттен асады. Сонда да жалғастыру керек пе?';
  }

  @override
  String get sendAnywayButton => 'Сонда да жіберу';

  @override
  String get createSmsDialogTitle => 'SMS құру?';

  @override
  String createSmsPhone(String phone) {
    return 'Телефон: $phone';
  }

  @override
  String createSmsText(String text) {
    return 'Мәтін: $text';
  }

  @override
  String get qrNotRecognized => 'QR ішкі формат ретінде танылмады.';

  @override
  String get transferCancelledLimit => 'Аудару тоқтатылды — лимит асқан.';

  @override
  String get smsSentSuccess =>
      'SMS құрылды. Хабарлама қолданбасында жіберуді растаңыз.';

  @override
  String get scanningContinues => 'Сканерлеу жалғасуда.';

  @override
  String get noQrInImage => 'Таңдалған суреттен QR код табылмады.';

  @override
  String get qrFoundNoData => 'QR табылды, бірақ дерек жоқ.';

  @override
  String get setPhoneFirst =>
      'Алдымен параметрлерде құрылғы телефонын орнатыңыз.';

  @override
  String get setAccountFirst => 'Алдымен параметрлерде шот нөмірін орнатыңыз.';

  @override
  String get chooseChannelTitle => 'Аударым арнасын таңдаңыз';

  @override
  String get scanningActive => 'Сканерлеу белсенді.';

  @override
  String get phoneQrTitle => 'Телефон QR';

  @override
  String phoneLabel(String phone) {
    return 'Телефон: $phone';
  }

  @override
  String get qrGenerationTitle => 'QR генерациясы';

  @override
  String get noProfile => 'Профиль жоқ';

  @override
  String get profileLabel => 'Профиль';

  @override
  String get profileNameLabel => 'Профиль атауы';

  @override
  String get recipientPhone => 'Алушы телефоны';

  @override
  String get phoneTransferInputTitle => 'QR-сыз аудару';

  @override
  String get enterPhoneError => 'Телефон нөмірін енгізіңіз';

  @override
  String get amountOptional => 'Сома (міндетті емес)';

  @override
  String get amountRequiredLabel => 'Аударым сомасы (міндетті)';

  @override
  String get enterAmountError => 'Аударым сомасын енгізіңіз';

  @override
  String get sourceLast4Optional => 'Шығыс картасы/шоты last4 (міндетті емес)';

  @override
  String get sourceLast4Hint => 'Мысалы: 1234';

  @override
  String get invalidLast4Error => 'Дәл 4 сан енгізіңіз';

  @override
  String get sourceAccountOptionalSection => 'Шығыс шоты (міндетті емес)';

  @override
  String get sberAmountRequired => '900 арқылы аударым үшін сома қажет.';

  @override
  String get smsTarget900 => 'Нөмір: 900';

  @override
  String get noteOptional => 'Ескертпе (міндетті емес)';

  @override
  String get myQrButton => 'Менің QR';

  @override
  String get qrAmountButton => 'Сомасы бар QR';

  @override
  String get showQrButton => 'QR көрсету';

  @override
  String get saveProfileButton => 'Профильді сақтау';

  @override
  String get composeSmsButton => 'SMS құрастыру';

  @override
  String get qrHintPhoneOnly =>
      'Осы QR-ды алушыға көрсетіңіз — жіберер алдында соманы және шығыс шотын өзі енгізеді';

  @override
  String get qrHint =>
      'Осы QR-ды алушыға көрсетіңіз — ол сканерлеп аудару жасайды';

  @override
  String get profileSaved => 'Профиль сақталды';

  @override
  String qrError(Object error) {
    return 'QR қатесі: $error';
  }

  @override
  String get transferLimitsTitle => 'Аудару лимиттері мен ережелері';

  @override
  String get openSberSiteTooltip => 'Sberbank сайтын ашу';

  @override
  String get infoActualBanner =>
      'Бұл ақпарат қолданбаның осы нұсқасына өзекті. Лимиттер мен шарттар өзгеруі мүмкін — sberbank.ru сайтынан немесе 900 нөмірі арқылы тексеріңіз.';

  @override
  String get smsCommandsTitle => 'SMS командалары (900 нөміріне)';

  @override
  String get limitsTitle => 'Аудару лимиттері';

  @override
  String get notificationFormatsTitle => 'Sberbank SMS хабарлама форматтары';

  @override
  String get importantRulesTitle => 'Маңызды ережелер';

  @override
  String get feesTitle => 'Комиссиялар';

  @override
  String get cannotOpenBrowser => 'Браузерді ашу мүмкін болмады';

  @override
  String get number900Copied => '900 нөмірі көшірілді';

  @override
  String copiedCommand(String command) {
    return 'Көшірілді: $command';
  }

  @override
  String get officialSberSite => 'Sberbank ресми сайты';

  @override
  String get officialSiteButton => 'Ресми сайт';

  @override
  String get helpContact900 => 'Көмек: 900 нөміріне хабарласу';

  @override
  String get disclaimerText =>
      'Бұл қолданба Sberbank-тың ресми өнімі емес. Ол тек SMS оқуға және командаларды құрастыруға көмектеседі — барлық аударымдар ұялы оператор арқылы стандартты SMS командаларымен орындалады.';

  @override
  String get personalLimitBanner =>
      'Жеке лимитті тексеру үшін — 900 нөміріне «ЛИМИТ» SMS жіберіңіз. Лимиттер тарифіңізге және операция тарихына қарай өзгеруі мүмкін.';

  @override
  String get phoneCopied => 'Телефон нөмірі көшірілді';

  @override
  String get copyPhoneButton => 'Телефонды көшіру';

  @override
  String noteLabel(String note) {
    return 'Ескертпе: $note';
  }

  @override
  String qrNotRecognizedWithRaw(String raw) {
    return 'QR ішкі формат ретінде танылмады: $raw';
  }

  @override
  String get cmdTransferMain => 'ПЕРЕВОД [phone] [amount]';

  @override
  String get cmdTransferMainDesc =>
      'Негізгі картадан телефон нөміріне аудару.\nМысал: ПЕРЕВОД 79161234567 1000';

  @override
  String get cmdTransferWithCard => 'ПЕРЕВОД [phone] [amount] [last4]';

  @override
  String get cmdTransferWithCardDesc =>
      'Белгілі бір картадан аудару.\nМысал: ПЕРЕВОД 79161234567 500 1234';

  @override
  String get cmdBalance => 'БАЛАНС';

  @override
  String get cmdBalanceDesc => 'Негізгі картаның балансы.';

  @override
  String get cmdBalanceCard => 'БАЛАНС [last4]';

  @override
  String get cmdBalanceCardDesc => 'Белгілі бір картаның балансы.';

  @override
  String get cmdHistory => 'ИСТОРИЯ';

  @override
  String get cmdHistoryDesc => 'Негізгі карта бойынша соңғы 5 операция.';

  @override
  String get cmdBlock => 'БЛОКИРОВКА [last4]';

  @override
  String get cmdBlockDesc => 'Картаны уақытша бұғаттау.';

  @override
  String get cmdLimit => 'ЛИМИТ';

  @override
  String get cmdLimitDesc => 'SMS арқылы ағымдағы аудару лимиттерін тексеру.';

  @override
  String get limitEconomyPerTxLabel =>
      '\"Economy\" Mobile Bank — бір операцияға';

  @override
  String get limitEconomyPerTxValue => '8 000 ₽';

  @override
  String get limitEconomyPerDayLabel => '\"Economy\" Mobile Bank — күніне';

  @override
  String get limitEconomyPerDayValue => '8 000 ₽';

  @override
  String get limitFullPerTxLabel => '\"Full\" Mobile Bank — бір операцияға';

  @override
  String get limitFullPerTxValue => '50 000 ₽ дейін';

  @override
  String get limitFullPerDayLabel => '\"Full\" Mobile Bank — күніне';

  @override
  String get limitFullPerDayValue => '500 000 ₽ дейін';

  @override
  String get limitCardToCardLabel => 'Картадан картаға (онлайн)';

  @override
  String get limitCardToCardValue => '150 000 ₽ дейін';

  @override
  String get exampleIncomingLabel => 'Түсу';

  @override
  String get exampleIncomingText =>
      'SBERBANK Түсу 10000 RUB Карта *1234 Қалдық: 25000 RUB';

  @override
  String get examplePurchaseLabel => 'Сатып алу';

  @override
  String get examplePurchaseText =>
      'SBERBANK Сатып алу 1500 RUB Карта *1234 ДҮКЕН АТАУЫ Қалдық: 23500 RUB';

  @override
  String get exampleTransferLabel => 'Аудару';

  @override
  String get exampleTransferText =>
      'Карта *1234-тен 5000 RUB аударылды. Қалдық: 18500 RUB.';

  @override
  String get exampleCashWithdrawalLabel => 'Қолма-қол алу';

  @override
  String get exampleCashWithdrawalText =>
      'Қолма-қол алу 3000 RUB. Карта *1234. Қалдық: 15500 RUB.';

  @override
  String get ruleRecipientClient =>
      'Алушы Sberbank клиенті болуы және Mobile Bank қосулы болуы тиіс.';

  @override
  String get rulePhoneLinked =>
      'Телефон нөмірі алушы картасына байланыстырылуы тиіс.';

  @override
  String get ruleSmsIrreversible =>
      'SMS аударымы қайтарылмайды — растау алдында алушы нөмірін тексеріңіз.';

  @override
  String get ruleSpecifyLast4 =>
      'Егер бірнеше карта болса, қателіктерді болдырмау үшін бастапқы картаның last4 мәнін көрсетіңіз.';

  @override
  String get ruleEconomyVsFull =>
      '\"Economy\" тарифі (тегін) — 8 000 ₽/күн лимит. \"Full\" тарифі (ақылы) — 100 000 ₽/күн дейін.';

  @override
  String get ruleResetAtMidnight =>
      'Күндік лимит Мәскеу уақытымен 00:00-де жаңартылады.';

  @override
  String get feeEconomyLabel => '\"Economy\" тарифі — аудару комиссиясы';

  @override
  String get feeEconomyValue => '1% (мин. 30 ₽)';

  @override
  String get feeFullLabel => '\"Full\" тарифі — аудару комиссиясы';

  @override
  String get feeFullValue => 'Тегін';

  @override
  String get feeSubscriptionLabel => '\"Full\" тарифі жазылымы';

  @override
  String get feeSubscriptionValue => '60 ₽/ай';

  @override
  String get opIncoming => 'түсу';

  @override
  String get opOutgoing => 'шығыс';

  @override
  String get opTransfer => 'аудару';

  @override
  String get opUnknown => 'белгісіз';

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
  String get yourAccountTitle => 'Шотыңыз';

  @override
  String get yourAccountDesc => 'Шот нөміріңізбен QR жасау үшін қолданылады';

  @override
  String get accountNumberLabel => 'Шот нөмірі';

  @override
  String get snackAccountSaved => 'Шот сақталды';

  @override
  String get selectBankFirstHint =>
      'Баптау үшін жоғарыда банкті таңдап сақтаңыз';
}
