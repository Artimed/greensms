// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'Green SMS';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get save => 'Saqlash';

  @override
  String get back => 'Orqaga';

  @override
  String get allow => 'Ruxsat berish';

  @override
  String get confirm => 'Tasdiqlash';

  @override
  String get clear => 'Tozalash';

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get onboardingSubtitle =>
      'SMS banking amallari uchun vizual yordamchi';

  @override
  String get onboardingFeatureLocal =>
      'Mahalliy ishlaydi, internet talab qilinmaydi';

  @override
  String get onboardingFeatureSms => 'Faqat oxirgi 10 ta SMSni o‘qiydi';

  @override
  String get onboardingFeaturePrivacy => 'Ma’lumotlar tashqariga yuborilmaydi';

  @override
  String get onboardingFeatureQr =>
      'QR faqat telefon raqamini ulashish uchun ishlatiladi';

  @override
  String get onboardingButton => 'Ruxsat so‘rab davom etish';

  @override
  String get accounts => 'Hisoblar';

  @override
  String get noAccountsYet => 'Hali tanilgan hisoblar yo‘q.';

  @override
  String get latestSms => 'So‘nggi SMS';

  @override
  String get smsNotLoaded => 'SMS hali yuklanmadi.';

  @override
  String get qrModeTitle => 'QR rejimi';

  @override
  String get qrModeSubtitle => 'To‘liq ekran kamerani ochish';

  @override
  String get smsDetailsTitle => 'SMS tafsilotlari';

  @override
  String smsDetailsSender(String sender) {
    return 'Yuboruvchi: $sender';
  }

  @override
  String smsDetailsTime(String time) {
    return 'Vaqt: $time';
  }

  @override
  String smsDetailsLast4(String last4) {
    return 'Karta: $last4';
  }

  @override
  String get smsDetailsLast4NotFound => 'topilmadi';

  @override
  String smsDetailsAmount(String amount) {
    return 'Miqdor: $amount';
  }

  @override
  String smsDetailsBalance(String balance) {
    return 'Balans: $balance';
  }

  @override
  String smsDetailsReference(String reference) {
    return 'Ref: $reference';
  }

  @override
  String smsDetailsType(String type) {
    return 'Turi: $type';
  }

  @override
  String get transferRulesTooltip => 'O‘tkazma qoidalari';

  @override
  String get accountsLabel => 'Hisoblar';

  @override
  String get refreshSmsButton => 'SMS yangilash';

  @override
  String get dailyLimitNotSet => 'Kunlik limit o‘rnatilmagan';

  @override
  String get setLimitInSettings => 'Limitni sozlamalarda o‘rnating';

  @override
  String get dailyTransferLimit => 'Kunlik o‘tkazma limiti';

  @override
  String get usedToday => 'Bugun ishlatilgan';

  @override
  String get remaining => 'Qolgan';

  @override
  String get limitExceeded => 'Limit oshib ketdi';

  @override
  String get limitWarning80 => 'Kunlik limitning 80% dan ko‘pi ishlatilgan';

  @override
  String get limitExceededBlocked =>
      'Kunlik limit oshib ketdi. QR orqali o‘tkazmalar bloklangan.';

  @override
  String accountBalanceLabel(String balance) {
    return 'Balans: $balance';
  }

  @override
  String get parsedLabel => 'tahlil qilingan';

  @override
  String get rawLabel => 'xom';

  @override
  String get devicePhoneTitle => 'Qurilma telefoni';

  @override
  String get devicePhoneDesc =>
      'Sizning raqamingiz bilan QR yaratish uchun ishlatiladi';

  @override
  String get phoneNumberLabel => 'Telefon raqami';

  @override
  String get dailyLimitDesc =>
      'Ushbu ilova orqali kunlik maksimal o‘tkazma summasi. Yarim tunda yangilanadi. Limitni olib tashlash uchun bo‘sh qoldiring.';

  @override
  String get limitLabel => 'Cheklov';

  @override
  String get limitHint => 'masalan: 50000';

  @override
  String get removeLimitButton => 'Limitni olib tashlash';

  @override
  String get themeTitle => 'Ko‘rinish';

  @override
  String get languageTitle => 'Til';

  @override
  String get bankRoutingTitle => 'Mamlakat va bank';

  @override
  String get bankRoutingDesc =>
      'Avval mamlakatni tanlang. Agar bir nechta bank bo‘lsa, to‘lov buyruqlari uchun bankni tanlang.';

  @override
  String get countryLabel => 'Mamlakat';

  @override
  String get bankLabel => 'Bank';

  @override
  String get bankAutoSelectedHint =>
      'Bu mamlakat uchun faqat bitta bank mavjud, u avtomatik tanlandi.';

  @override
  String get referenceOnlyBadge => 'reference only';

  @override
  String get bankReferenceOnlyHint =>
      'For this country, the bank is available as a reference source for limits and rules only. Direct payment commands are not currently verified.';

  @override
  String get languageEnglish => 'Ingliz';

  @override
  String get languageRussian => 'Rus';

  @override
  String get languageHindi => 'Hind';

  @override
  String get languageKazakh => 'Qozoq';

  @override
  String get languageUzbek => 'O‘zbek';

  @override
  String get languageTagalog => 'Tagalog tili';

  @override
  String get languageIndonesian => 'Indonez';

  @override
  String get permissionsTitle => 'Ruxsatlar';

  @override
  String get readSmsTitle => 'SMS o‘qish';

  @override
  String get readSmsDesc =>
      'Kirish SMSlarini o‘qish va ma’lumotlarni yangilash uchun kerak.';

  @override
  String get directSmsTitle => 'SMSni to‘g‘ridan-to‘g‘ri yuborish';

  @override
  String get directSmsDesc =>
      'Xabar ilovasini ochmasdan SMSni to‘g‘ridan-to‘g‘ri yuborish';

  @override
  String get directSmsPermissionRequired =>
      'SEND_SMS ruxsati kerak. Uni tizim ilova sozlamalarida bering.';

  @override
  String get directSmsEnabledSnack =>
      'SMSni to‘g‘ridan-to‘g‘ri yuborish yoqildi';

  @override
  String get directSmsDisabledSnack =>
      'SMSni to‘g‘ridan-to‘g‘ri yuborish o‘chirildi';

  @override
  String get openSettingsButton => 'Sozlamalar';

  @override
  String get permissionsManageInSystem =>
      'Ruxsatlarni o‘chirish ilovaning tizim sozlamalarida amalga oshiriladi.';

  @override
  String get cameraTitle => 'Kamera';

  @override
  String get cameraDesc => 'QR skanerlash uchun';

  @override
  String get clearLocalDataTitle => 'Mahalliy ma’lumotlarni tozalash';

  @override
  String get clearLocalDataDesc => 'SMS, hisoblar, QR profillar va tarix';

  @override
  String get aboutTitle => 'Ilova haqida';

  @override
  String get aboutVersion => 'Green SMS v1.0\nMahalliy ilova, internetsiz';

  @override
  String get snackLimitRemoved => 'Limit olib tashlandi';

  @override
  String snackLimitSet(String amount) {
    return 'Limit o‘rnatildi: $amount';
  }

  @override
  String get snackPhoneSaved => 'Telefon saqlandi';

  @override
  String get snackDataCleared => 'Mahalliy ma’lumotlar tozalandi';

  @override
  String get clearDataDialogTitle => 'Ma’lumotlarni tozalash?';

  @override
  String get clearDataDialogContent =>
      'SMS, hisoblar, QR profillar va tarix o‘chiriladi.';

  @override
  String get cameraPermissionNeeded => 'Kameraga ruxsat kerak';

  @override
  String get scanHint => 'Kamerani QR kodga qarating';

  @override
  String get scanButton => 'Skanerlash';

  @override
  String get phoneTransferButton => 'Telefon orqali';

  @override
  String get limitWarningTitle => 'Kunlik limit oshdi';

  @override
  String limitWarningContent(String amount, String remaining) {
    return 'O‘tkazma summasi: $amount\nQolgan limit: $remaining\n\nO‘tkazma kunlik limitdan oshadi. Baribir davom etilsinmi?';
  }

  @override
  String get sendAnywayButton => 'Baribir yuborish';

  @override
  String get createSmsDialogTitle => 'SMS yaratilsinmi?';

  @override
  String createSmsPhone(String phone) {
    return 'Telefon: $phone';
  }

  @override
  String createSmsText(String text) {
    return 'Matn: $text';
  }

  @override
  String get qrNotRecognized => 'QR ichki format sifatida tanilmadi.';

  @override
  String get transferCancelledLimit => 'O‘tkazma bekor qilindi — limit oshdi.';

  @override
  String get smsSentSuccess =>
      'SMS yaratildi. Yuborishni xabarlar ilovasida tasdiqlang.';

  @override
  String get scanningContinues => 'Skanerlash davom etmoqda.';

  @override
  String get noQrInImage => 'Tanlangan rasmda QR kod topilmadi.';

  @override
  String get qrFoundNoData => 'QR topildi, lekin ma’lumot yo‘q.';

  @override
  String get setPhoneFirst => 'Avval sozlamalarda qurilma telefonini kiriting.';

  @override
  String get setAccountFirst => 'Avval sozlamalarda hisob raqamini kiriting.';

  @override
  String get chooseChannelTitle => 'Pul o\'tkazma kanalini tanlang';

  @override
  String get scanningActive => 'Skanerlash faol.';

  @override
  String get phoneQrTitle => 'Telefon QR';

  @override
  String phoneLabel(String phone) {
    return 'Telefon: $phone';
  }

  @override
  String get qrGenerationTitle => 'QR yaratish';

  @override
  String get noProfile => 'Profil yo‘q';

  @override
  String get profileLabel => 'Profil';

  @override
  String get profileNameLabel => 'Profil nomi';

  @override
  String get recipientPhone => 'Qabul qiluvchi telefoni';

  @override
  String get phoneTransferInputTitle => 'QRsiz o\'tkazma';

  @override
  String get enterPhoneError => 'Telefon raqamini kiriting';

  @override
  String get amountOptional => 'Miqdor (ixtiyoriy)';

  @override
  String get amountRequiredLabel => 'O\'tkazma summasi (majburiy)';

  @override
  String get enterAmountError => 'O\'tkazma summasini kiriting';

  @override
  String get sourceLast4Optional => 'Manba karta/hisob last4 (ixtiyoriy)';

  @override
  String get sourceLast4Hint => 'Masalan: 1234';

  @override
  String get invalidLast4Error => 'Aniq 4 ta raqam kiriting';

  @override
  String get sourceAccountOptionalSection => 'Manba hisobi (ixtiyoriy)';

  @override
  String get sberAmountRequired => '900 orqali o\'tkazma uchun summa kerak.';

  @override
  String get smsTarget900 => 'Raqam: 900';

  @override
  String get noteOptional => 'Izoh (ixtiyoriy)';

  @override
  String get myQrButton => 'Mening QR';

  @override
  String get qrAmountButton => 'Summali QR';

  @override
  String get showQrButton => 'QR ko‘rsatish';

  @override
  String get saveProfileButton => 'Profilni saqlash';

  @override
  String get composeSmsButton => 'SMS tuzish';

  @override
  String get qrHintPhoneOnly =>
      'Ushbu QRni qabul qiluvchiga ko‘rsating — yuborishdan oldin summa va manba hisobini u o‘zi kiritadi';

  @override
  String get qrHint =>
      'Ushbu QRni qabul qiluvchiga ko‘rsating — u skanerlab o‘tkazma qiladi';

  @override
  String get profileSaved => 'Profil saqlandi';

  @override
  String qrError(Object error) {
    return 'QR xatosi: $error';
  }

  @override
  String get transferLimitsTitle => 'O‘tkazma limitlari va qoidalari';

  @override
  String get openSberSiteTooltip => 'Sberbank saytini ochish';

  @override
  String get infoActualBanner =>
      'Ma’lumot ushbu ilova versiyasi uchun dolzarb. Limit va shartlar o‘zgarishi mumkin — sberbank.ru sayti yoki 900 raqami orqali tekshiring.';

  @override
  String get smsCommandsTitle => 'SMS buyruqlari (900 raqamiga)';

  @override
  String get limitsTitle => 'O‘tkazma limitlari';

  @override
  String get notificationFormatsTitle => 'Sberbank SMS xabarnoma formatlari';

  @override
  String get importantRulesTitle => 'Muhim qoidalar';

  @override
  String get feesTitle => 'Komissiyalar';

  @override
  String get cannotOpenBrowser => 'Brauzerni ochib bo‘lmadi';

  @override
  String get number900Copied => '900 raqami nusxalandi';

  @override
  String copiedCommand(String command) {
    return 'Nusxalandi: $command';
  }

  @override
  String get officialSberSite => 'Sberbank rasmiy sayti';

  @override
  String get officialSiteButton => 'Rasmiy veb-sayt';

  @override
  String get helpContact900 => 'Yordam: 900 ga murojaat qiling';

  @override
  String get disclaimerText =>
      'Ushbu ilova Sberbankning rasmiy mahsuloti emas. Ilova faqat SMS o‘qish va buyruq tuzishga yordam beradi — barcha o‘tkazmalar mobil operator orqali standart SMS buyruqlar bilan bajariladi.';

  @override
  String get personalLimitBanner =>
      'Shaxsiy limitingizni tekshirish uchun — 900 raqamiga «ЛИМИТ» SMS yuboring. Limitlar tarif va tranzaksiya tarixiga qarab farq qilishi mumkin.';

  @override
  String get phoneCopied => 'Telefon raqami nusxalandi';

  @override
  String get copyPhoneButton => 'Telefonni nusxalash';

  @override
  String noteLabel(String note) {
    return 'Izoh: $note';
  }

  @override
  String qrNotRecognizedWithRaw(String raw) {
    return 'QR ichki format sifatida tanilmadi: $raw';
  }

  @override
  String get cmdTransferMain => 'ПЕРЕВОД [phone] [amount]';

  @override
  String get cmdTransferMainDesc =>
      'Asosiy kartadan telefon raqamiga o‘tkazma.\nMisol: ПЕРЕВОД 79161234567 1000';

  @override
  String get cmdTransferWithCard => 'ПЕРЕВОД [phone] [amount] [last4]';

  @override
  String get cmdTransferWithCardDesc =>
      'Muayyan kartadan o‘tkazma.\nMisol: ПЕРЕВОД 79161234567 500 1234';

  @override
  String get cmdBalance => 'БАЛАНС';

  @override
  String get cmdBalanceDesc => 'Asosiy karta balansi.';

  @override
  String get cmdBalanceCard => 'БАЛАНС [last4]';

  @override
  String get cmdBalanceCardDesc => 'Muayyan karta balansi.';

  @override
  String get cmdHistory => 'ИСТОРИЯ';

  @override
  String get cmdHistoryDesc => 'Asosiy kartadagi so‘nggi 5 ta operatsiya.';

  @override
  String get cmdBlock => 'БЛОКИРОВКА [last4]';

  @override
  String get cmdBlockDesc => 'Kartani vaqtincha bloklash.';

  @override
  String get cmdLimit => 'ЛИМИТ';

  @override
  String get cmdLimitDesc =>
      'SMS orqali joriy o‘tkazma limitlarini tekshirish.';

  @override
  String get limitEconomyPerTxLabel =>
      '\"Economy\" Mobile Bank — har bir operatsiya uchun';

  @override
  String get limitEconomyPerTxValue => '8 000 ₽';

  @override
  String get limitEconomyPerDayLabel => '\"Economy\" Mobile Bank — kuniga';

  @override
  String get limitEconomyPerDayValue => '8 000 ₽';

  @override
  String get limitFullPerTxLabel =>
      '\"Full\" Mobile Bank — har bir operatsiya uchun';

  @override
  String get limitFullPerTxValue => '50 000 ₽ gacha';

  @override
  String get limitFullPerDayLabel => '\"Full\" Mobile Bank — kuniga';

  @override
  String get limitFullPerDayValue => '500 000 ₽ gacha';

  @override
  String get limitCardToCardLabel => 'Kartadan kartaga (onlayn)';

  @override
  String get limitCardToCardValue => '150 000 ₽ gacha';

  @override
  String get exampleIncomingLabel => 'Kirim';

  @override
  String get exampleIncomingText =>
      'SBERBANK Kirim 10000 RUB Karta *1234 Balans: 25000 RUB';

  @override
  String get examplePurchaseLabel => 'Xarid';

  @override
  String get examplePurchaseText =>
      'SBERBANK Xarid 1500 RUB Karta *1234 DO‘KON NOMI Balans: 23500 RUB';

  @override
  String get exampleTransferLabel => 'O‘tkazma';

  @override
  String get exampleTransferText =>
      'Karta *1234 dan 5000 RUB o‘tkazildi. Balans: 18500 RUB.';

  @override
  String get exampleCashWithdrawalLabel => 'Naqd yechish';

  @override
  String get exampleCashWithdrawalText =>
      'Naqd yechish 3000 RUB. Karta *1234. Balans: 15500 RUB.';

  @override
  String get ruleRecipientClient =>
      'Qabul qiluvchi Sberbank mijozi bo‘lishi va Mobile Bank ulangan bo‘lishi kerak.';

  @override
  String get rulePhoneLinked =>
      'Telefon raqami qabul qiluvchi kartasiga bog‘langan bo‘lishi kerak.';

  @override
  String get ruleSmsIrreversible =>
      'SMS o‘tkazmasi qaytarilmaydi — tasdiqlashdan oldin raqamni tekshiring.';

  @override
  String get ruleSpecifyLast4 =>
      'Agar sizda bir nechta karta bo‘lsa, xatolarning oldini olish uchun manba kartaning last4 qismini ko‘rsating.';

  @override
  String get ruleEconomyVsFull =>
      '\"Economy\" tarifi (bepul) — 8 000 ₽/kun limit. \"Full\" tarifi (pullik) — 100 000 ₽/kungacha.';

  @override
  String get ruleResetAtMidnight =>
      'Kunlik limit Moskva vaqti bilan 00:00 da yangilanadi.';

  @override
  String get feeEconomyLabel => '\"Economy\" tarifi — o‘tkazma komissiyasi';

  @override
  String get feeEconomyValue => '1% (kamida 30 ₽)';

  @override
  String get feeFullLabel => '\"Full\" tarifi — o‘tkazma komissiyasi';

  @override
  String get feeFullValue => 'Bepul';

  @override
  String get feeSubscriptionLabel => '\"Full\" tarifi obunasi';

  @override
  String get feeSubscriptionValue => '60 ₽/oy';

  @override
  String get opIncoming => 'kirim';

  @override
  String get opOutgoing => 'chiqim';

  @override
  String get opTransfer => 'o‘tkazma';

  @override
  String get opUnknown => 'noma’lum';

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
  String get yourAccountTitle => 'Hisobingiz';

  @override
  String get yourAccountDesc =>
      'Hisob raqamingiz bilan QR yaratish uchun ishlatiladi';

  @override
  String get accountNumberLabel => 'Hisob raqami';

  @override
  String get snackAccountSaved => 'Hisob saqlandi';

  @override
  String get selectBankFirstHint =>
      'Sozlash uchun yuqorida bankni tanlang va saqlang';
}
