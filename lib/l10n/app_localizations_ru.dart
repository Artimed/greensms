// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Зелёная SMS';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get back => 'Назад';

  @override
  String get allow => 'Разрешить';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get clear => 'Очистить';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get onboardingSubtitle => 'Визуальный помощник для SMS-операций';

  @override
  String get onboardingFeatureLocal => 'Работает локально, без интернета';

  @override
  String get onboardingFeatureSms => 'Читает только последние 10 SMS';

  @override
  String get onboardingFeaturePrivacy => 'Данные не отправляются наружу';

  @override
  String get onboardingFeatureQr =>
      'QR используется только для передачи номера телефона';

  @override
  String get onboardingButton => 'Запросить разрешения и продолжить';

  @override
  String get accounts => 'Счета';

  @override
  String get noAccountsYet => 'Пока нет распознанных счетов.';

  @override
  String get latestSms => 'Последние SMS';

  @override
  String get smsNotLoaded => 'SMS пока не загружены.';

  @override
  String get qrModeTitle => 'QR-режим';

  @override
  String get qrModeSubtitle => 'Открыть камеру на весь экран';

  @override
  String get smsDetailsTitle => 'Детали SMS';

  @override
  String smsDetailsSender(String sender) {
    return 'Отправитель: $sender';
  }

  @override
  String smsDetailsTime(String time) {
    return 'Время: $time';
  }

  @override
  String smsDetailsLast4(String last4) {
    return 'last4: $last4';
  }

  @override
  String get smsDetailsLast4NotFound => 'не найдено';

  @override
  String smsDetailsAmount(String amount) {
    return 'Сумма: $amount';
  }

  @override
  String smsDetailsBalance(String balance) {
    return 'Баланс: $balance';
  }

  @override
  String smsDetailsReference(String reference) {
    return 'Ref: $reference';
  }

  @override
  String smsDetailsType(String type) {
    return 'Тип: $type';
  }

  @override
  String get transferRulesTooltip => 'Правила переводов';

  @override
  String get accountsLabel => 'Счетов';

  @override
  String get refreshSmsButton => 'Обновить SMS';

  @override
  String get dailyLimitNotSet => 'Дневной лимит не установлен';

  @override
  String get setLimitInSettings => 'Укажите лимит в настройках';

  @override
  String get dailyTransferLimit => 'Дневной лимит переводов';

  @override
  String get usedToday => 'Использовано сегодня';

  @override
  String get remaining => 'Остаток';

  @override
  String get limitExceeded => 'Лимит исчерпан';

  @override
  String get limitWarning80 => 'Использовано более 80% дневного лимита';

  @override
  String get limitExceededBlocked =>
      'Дневной лимит исчерпан. Переводы через QR заблокированы.';

  @override
  String accountBalanceLabel(String balance) {
    return 'Баланс: $balance';
  }

  @override
  String get parsedLabel => 'распознано';

  @override
  String get rawLabel => 'сырой';

  @override
  String get devicePhoneTitle => 'Телефон устройства';

  @override
  String get devicePhoneDesc => 'Используется для генерации QR с вашим номером';

  @override
  String get phoneNumberLabel => 'Номер телефона';

  @override
  String get dailyLimitDesc =>
      'Максимальная сумма переводов через это приложение в день. Сбрасывается в полночь. Оставьте пустым, чтобы убрать лимит.';

  @override
  String get limitLabel => 'Лимит';

  @override
  String get limitHint => 'Например: 50000';

  @override
  String get removeLimitButton => 'Снять лимит';

  @override
  String get themeTitle => 'Тема оформления';

  @override
  String get languageTitle => 'Язык';

  @override
  String get bankRoutingTitle => 'Страна и банк';

  @override
  String get bankRoutingDesc =>
      'Сначала выберите страну, затем банк для платежных команд.';

  @override
  String get countryLabel => 'Страна';

  @override
  String get bankLabel => 'Банк';

  @override
  String get bankAutoSelectedHint =>
      'Для выбранной страны доступен один банк — выбран автоматически.';

  @override
  String get referenceOnlyBadge => 'только справка';

  @override
  String get bankReferenceOnlyHint =>
      'Для этой страны банк доступен только как справочный источник лимитов и правил. Прямые платежные команды сейчас не подтверждены.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageKazakh => 'Қазақша';

  @override
  String get languageUzbek => 'O\'zbekcha';

  @override
  String get languageTagalog => 'Tagalog';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get permissionsTitle => 'Разрешения';

  @override
  String get readSmsTitle => 'Чтение SMS';

  @override
  String get readSmsDesc =>
      'Нужно для чтения входящих SMS и обновления данных.';

  @override
  String get directSmsTitle => 'Прямая отправка SMS';

  @override
  String get directSmsDesc =>
      'Отправлять SMS напрямую без открытия приложения сообщений';

  @override
  String get directSmsPermissionRequired =>
      'Требуется разрешение SEND_SMS. Выдайте его в настройках приложения.';

  @override
  String get directSmsEnabledSnack => 'Прямая отправка SMS включена';

  @override
  String get directSmsDisabledSnack => 'Прямая отправка SMS выключена';

  @override
  String get openSettingsButton => 'Настройки';

  @override
  String get permissionsManageInSystem =>
      'Отключение выполняется в системных настройках приложения.';

  @override
  String get cameraTitle => 'Камера';

  @override
  String get cameraDesc => 'Для сканирования QR';

  @override
  String get clearLocalDataTitle => 'Очистить локальные данные';

  @override
  String get clearLocalDataDesc => 'SMS, счета, профили QR и история';

  @override
  String get aboutTitle => 'О приложении';

  @override
  String get aboutVersion =>
      'Зелёная SMS v1.0\nЛокальное приложение без интернета';

  @override
  String get snackLimitRemoved => 'Лимит снят';

  @override
  String snackLimitSet(String amount) {
    return 'Лимит установлен: $amount ₽';
  }

  @override
  String get snackPhoneSaved => 'Телефон сохранён';

  @override
  String get snackDataCleared => 'Локальные данные очищены';

  @override
  String get clearDataDialogTitle => 'Очистить данные?';

  @override
  String get clearDataDialogContent =>
      'Будут удалены SMS, счета, профили QR и история.';

  @override
  String get cameraPermissionNeeded => 'Нужен доступ к камере';

  @override
  String get scanHint => 'Наведи камеру на QR-код';

  @override
  String get scanButton => 'Сканировать';

  @override
  String get phoneTransferButton => 'По телефону';

  @override
  String get limitWarningTitle => 'Превышение дневного лимита';

  @override
  String limitWarningContent(String amount, String remaining) {
    return 'Сумма перевода: $amount ₽\nОстаток лимита: $remaining ₽\n\nПеревод превышает установленный дневной лимит. Всё равно продолжить?';
  }

  @override
  String get sendAnywayButton => 'Всё равно отправить';

  @override
  String get createSmsDialogTitle => 'Сформировать SMS?';

  @override
  String createSmsPhone(String phone) {
    return 'Телефон: $phone';
  }

  @override
  String createSmsText(String text) {
    return 'Текст: $text';
  }

  @override
  String get qrNotRecognized => 'QR не распознан как внутренний формат.';

  @override
  String get transferCancelledLimit => 'Перевод отменён — превышение лимита.';

  @override
  String get smsSentSuccess =>
      'SMS сформировано. Подтверди отправку в приложении сообщений.';

  @override
  String get scanningContinues => 'Сканирование продолжается.';

  @override
  String get noQrInImage => 'В выбранном изображении QR не найден.';

  @override
  String get qrFoundNoData => 'QR найден, но данных нет.';

  @override
  String get setPhoneFirst => 'Сначала укажи телефон устройства в настройках.';

  @override
  String get setAccountFirst => 'Сначала укажи номер счёта в настройках.';

  @override
  String get chooseChannelTitle => 'Выбрать канал перевода';

  @override
  String get scanningActive => 'Сканирование активно.';

  @override
  String get phoneQrTitle => 'QR телефона';

  @override
  String phoneLabel(String phone) {
    return 'Телефон: $phone';
  }

  @override
  String get qrGenerationTitle => 'Генерация QR';

  @override
  String get noProfile => 'Без профиля';

  @override
  String get profileLabel => 'Профиль';

  @override
  String get profileNameLabel => 'Название профиля';

  @override
  String get recipientPhone => 'Телефон получателя';

  @override
  String get phoneTransferInputTitle => 'Перевод без QR';

  @override
  String get enterPhoneError => 'Введите номер телефона';

  @override
  String get amountOptional => 'Сумма (опционально)';

  @override
  String get amountRequiredLabel => 'Сумма перевода (обязательно)';

  @override
  String get enterAmountError => 'Введите сумму перевода';

  @override
  String get sourceLast4Optional => 'Карта/счёт списания last4 (опционально)';

  @override
  String get sourceLast4Hint => 'Например: 1234';

  @override
  String get invalidLast4Error => 'Укажите ровно 4 цифры';

  @override
  String get sourceAccountOptionalSection => 'Счёт списания (опционально)';

  @override
  String get sberAmountRequired => 'Для перевода на 900 нужна сумма.';

  @override
  String get smsTarget900 => 'Номер: 900';

  @override
  String get noteOptional => 'Заметка (опционально)';

  @override
  String get myQrButton => 'Мой QR';

  @override
  String get qrAmountButton => 'QR с суммой';

  @override
  String get showQrButton => 'Показать QR';

  @override
  String get saveProfileButton => 'Сохранить профиль';

  @override
  String get composeSmsButton => 'Составить SMS';

  @override
  String get qrHintPhoneOnly =>
      'Покажите этот QR получателю — сумму и счёт он введёт у себя перед отправкой';

  @override
  String get qrHint =>
      'Покажите этот QR получателю — он отсканирует и сделает перевод';

  @override
  String get profileSaved => 'Профиль сохранён';

  @override
  String qrError(Object error) {
    return 'Ошибка QR: $error';
  }

  @override
  String get transferLimitsTitle => 'Лимиты и правила переводов';

  @override
  String get openSberSiteTooltip => 'Открыть сайт Сбербанка';

  @override
  String get infoActualBanner =>
      'Информация актуальна на момент выхода этой версии приложения. Лимиты и условия могут меняться — проверяйте на sberbank.ru или по номеру 900.';

  @override
  String get smsCommandsTitle => 'Команды для перевода (на номер 900)';

  @override
  String get limitsTitle => 'Лимиты переводов';

  @override
  String get notificationFormatsTitle => 'Форматы SMS-уведомлений Сбера';

  @override
  String get importantRulesTitle => 'Важные правила';

  @override
  String get feesTitle => 'Комиссии';

  @override
  String get cannotOpenBrowser => 'Не удалось открыть браузер';

  @override
  String get number900Copied => 'Номер 900 скопирован';

  @override
  String copiedCommand(String command) {
    return 'Скопировано: $command';
  }

  @override
  String get officialSberSite => 'Официальный сайт Сбербанка';

  @override
  String get officialSiteButton => 'Официальный сайт';

  @override
  String get helpContact900 => 'Помощь: написать на 900';

  @override
  String get disclaimerText =>
      'Это приложение не является официальным продуктом Сбербанка. Приложение только помогает читать SMS и формировать команды — все переводы выполняются стандартными SMS-командами через ваш оператор связи.';

  @override
  String get personalLimitBanner =>
      'Чтобы узнать ваш персональный лимит — отправьте SMS «ЛИМИТ» на номер 900. Лимиты могут отличаться в зависимости от тарифа и истории операций.';

  @override
  String get phoneCopied => 'Номер скопирован';

  @override
  String get copyPhoneButton => 'Скопировать номер';

  @override
  String noteLabel(String note) {
    return 'Заметка: $note';
  }

  @override
  String qrNotRecognizedWithRaw(String raw) {
    return 'QR не распознан как внутренний формат: $raw';
  }

  @override
  String get cmdTransferMain => 'ПЕРЕВОД [телефон] [сумма]';

  @override
  String get cmdTransferMainDesc =>
      'Перевод на номер телефона с основной карты.\nПример: ПЕРЕВОД 79161234567 1000';

  @override
  String get cmdTransferWithCard => 'ПЕРЕВОД [телефон] [сумма] [last4]';

  @override
  String get cmdTransferWithCardDesc =>
      'Перевод с конкретной карты.\nПример: ПЕРЕВОД 79161234567 500 1234';

  @override
  String get cmdBalance => 'БАЛАНС';

  @override
  String get cmdBalanceDesc => 'Баланс основной карты.';

  @override
  String get cmdBalanceCard => 'БАЛАНС [last4]';

  @override
  String get cmdBalanceCardDesc => 'Баланс конкретной карты.';

  @override
  String get cmdHistory => 'ИСТОРИЯ';

  @override
  String get cmdHistoryDesc => 'Последние 5 операций по основной карте.';

  @override
  String get cmdBlock => 'БЛОКИРОВКА [last4]';

  @override
  String get cmdBlockDesc => 'Временная блокировка карты.';

  @override
  String get cmdLimit => 'ЛИМИТ';

  @override
  String get cmdLimitDesc =>
      'Узнать ваши текущие лимиты на переводы через SMS.';

  @override
  String get limitEconomyPerTxLabel => 'Мобильный банк «Эконом» — за операцию';

  @override
  String get limitEconomyPerTxValue => '8 000 ₽';

  @override
  String get limitEconomyPerDayLabel => 'Мобильный банк «Эконом» — в день';

  @override
  String get limitEconomyPerDayValue => '8 000 ₽';

  @override
  String get limitFullPerTxLabel => 'Мобильный банк «Полный» — за операцию';

  @override
  String get limitFullPerTxValue => 'до 50 000 ₽';

  @override
  String get limitFullPerDayLabel => 'Мобильный банк «Полный» — в день';

  @override
  String get limitFullPerDayValue => 'до 500 000 ₽';

  @override
  String get limitCardToCardLabel => 'Карта → карта (онлайн)';

  @override
  String get limitCardToCardValue => 'до 150 000 ₽';

  @override
  String get exampleIncomingLabel => 'Зачисление';

  @override
  String get exampleIncomingText =>
      'СБЕРБАНК Зачисление 10000р Карта *1234 Баланс: 25000р';

  @override
  String get examplePurchaseLabel => 'Покупка';

  @override
  String get examplePurchaseText =>
      'СБЕРБАНК Покупка 1500р Карта *1234 НАЗВАНИЕ МАГАЗИНА Баланс: 23500р';

  @override
  String get exampleTransferLabel => 'Перевод';

  @override
  String get exampleTransferText =>
      'Перевод 5000р с карты *1234 выполнен. Баланс: 18500р.';

  @override
  String get exampleCashWithdrawalLabel => 'Снятие наличных';

  @override
  String get exampleCashWithdrawalText =>
      'Снятие 3000р. Карта *1234. Баланс: 15500р.';

  @override
  String get ruleRecipientClient =>
      'Получатель должен быть клиентом Сбербанка и подключён к Мобильному банку.';

  @override
  String get rulePhoneLinked =>
      'Номер телефона должен быть привязан к карте получателя.';

  @override
  String get ruleSmsIrreversible =>
      'Перевод по SMS необратим — проверяйте номер получателя до подтверждения.';

  @override
  String get ruleSpecifyLast4 =>
      'Если у вас несколько карт, указывайте last4 карты-источника во избежание ошибок.';

  @override
  String get ruleEconomyVsFull =>
      'Тариф «Эконом» (бесплатный) — лимит 8 000 ₽/день. Тариф «Полный» (платный) — до 500 000 ₽/день.';

  @override
  String get ruleResetAtMidnight =>
      'Суточный лимит сбрасывается в 00:00 по московскому времени.';

  @override
  String get feeEconomyLabel => 'Тариф «Эконом» — за переводы';

  @override
  String get feeEconomyValue => '1% (мин. 30 ₽)';

  @override
  String get feeFullLabel => 'Тариф «Полный» — за переводы';

  @override
  String get feeFullValue => 'Бесплатно';

  @override
  String get feeSubscriptionLabel => 'Абонентская плата «Полный»';

  @override
  String get feeSubscriptionValue => '60 ₽/мес';

  @override
  String get opIncoming => 'зачисление';

  @override
  String get opOutgoing => 'списание';

  @override
  String get opTransfer => 'перевод';

  @override
  String get opUnknown => 'неизвестно';

  @override
  String smsTargetLabel(String number) {
    return 'Кому: $number';
  }

  @override
  String get amountRequiredForTransfer => 'Для перевода требуется сумма.';

  @override
  String get ussdDialogTitle => 'USSD-перевод?';

  @override
  String get openDialerButton => 'Открыть набор номера';

  @override
  String get ussdSentHint =>
      'USSD-код набран. Подтвердите перевод в наборщике номера.';

  @override
  String get bankNotAvailable =>
      'Команды банка не настроены для вашего региона.';

  @override
  String get transferSmsCommandTitle => 'SMS-команда перевода';

  @override
  String get transferUssdCommandTitle => 'USSD-команда перевода';

  @override
  String sendToLabel(String number) {
    return 'Отправить на: $number';
  }

  @override
  String get exampleLabelShort => 'Пример';

  @override
  String bankLimitsContactBanner(String bankName) {
    return 'Лимиты переводов и комиссии зависят от тарифа. Уточняйте актуальные условия в $bankName.';
  }

  @override
  String get notificationExamplesTitle => 'Примеры SMS-уведомлений';

  @override
  String get noBankSelectedBanner =>
      'Банк не выбран. Выберите страну и банк в настройках.';

  @override
  String helpContactNumber(String number) {
    return 'Помощь: написать на $number';
  }

  @override
  String bankDisclaimerGeneric(String bankName) {
    return 'Это приложение не является официальным продуктом $bankName. Переводы выполняются стандартными SMS или USSD-командами через вашего оператора связи.';
  }

  @override
  String get infoActualBannerGeneric =>
      'Информация основана на публично доступных данных. Лимиты и условия могут меняться — уточняйте в вашем банке.';

  @override
  String get officialDataTitle => 'Официальные данные';

  @override
  String get officialStatusLabel => 'Статус источника';

  @override
  String get officialChannelLabel => 'Канал панели';

  @override
  String get officialLastVerifiedLabel => 'Проверено';

  @override
  String get officialStatusVerifiedPublic =>
      'Подтверждено публичным источником';

  @override
  String get officialStatusLimitedPublic => 'Публичный источник ограничен';

  @override
  String get officialStatusManualVerificationRequired =>
      'Требуется ручная верификация';

  @override
  String get officialStatusUnknown => 'Не указан';

  @override
  String get officialWarningLimited =>
      'Публичные лимиты и правила для этого точного канала подтверждены не полностью. Используйте значения как справочные и перепроверяйте их в банке.';

  @override
  String get officialWarningManual =>
      'Для этого банка или канала нет достаточного публичного официального подтверждения. Данные показаны только как ориентир.';

  @override
  String get commandChannelUnavailableBanner =>
      'Прямой SMS или USSD-командный канал для этого банка сейчас не подтвержден. Инфопанель показана как справка по официальным публичным данным.';

  @override
  String get directTransferButton => 'Перевод';

  @override
  String createSmsAccount(String account) {
    return 'Счёт: $account';
  }

  @override
  String get recipientAccount => 'Счёт получателя';

  @override
  String get enterAccountError => 'Введите счёт получателя';

  @override
  String get routeLabel => 'Канал перевода';

  @override
  String get routeSmsPhone => 'SMS по телефону';

  @override
  String get routeSmsAccount => 'SMS по счёту';

  @override
  String get routeUssdPhone => 'USSD по телефону';

  @override
  String get routeUssdAccount => 'USSD по счёту';

  @override
  String get accountQrTitle => 'QR счёта';

  @override
  String get qrHintAccountOnly =>
      'Покажите этот QR отправителю — в своем банковском сценарии он использует ваш счёт перед отправкой';

  @override
  String get yourAccountTitle => 'Ваш счёт';

  @override
  String get yourAccountDesc =>
      'Используется для генерации QR с вашим номером счёта';

  @override
  String get accountNumberLabel => 'Номер счёта';

  @override
  String get snackAccountSaved => 'Счёт сохранён';

  @override
  String get selectBankFirstHint => 'Сначала выберите и сохраните банк выше';
}
