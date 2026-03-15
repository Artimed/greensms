class SmsPatternLibrary {
  static const String currencyToken =
      r'(?:₽|р(?![а-яёА-ЯЁa-zA-Z])|руб\.?(?![а-яёА-ЯЁ])|rub|rs\.?|ngn|inr|pkr|tk|bdt|idr|rp(?![a-zA-Z])|php|amd|vnd)';

  static const String numberToken =
      r'(?:\d{1,3}(?:[ .,\u00A0]\d{3})+(?:[.,]\d{1,2})?|\d+(?:[.,]\d{1,2})?)';

  static final RegExp otp = RegExp(
    r'никому не сообщайте|не сообщайте код|код подтверждения|пароль для|one.time password|otp\b',
    caseSensitive: false,
  );

  static final RegExp bankCodeLast4 = RegExp(
    r'^([A-ZА-ЯЁa-zа-яё]{2,6})[-–]?(\d{4})\b',
    caseSensitive: false,
  );

  static final RegExp maskedLast4 = RegExp(
    r'(?:\*+|X+)\s*(\d{4})\b',
    caseSensitive: false,
  );

  static final RegExp namedLast4 = RegExp(
    r'(?:карт[аеыу]?|сч[её]т[аеу]?|acct|account|a/c|rek(?:ening)?\.?)\s*[:#.]?\s*(?:[0-9xX*]{0,12})?(\d{4})\b',
    caseSensitive: false,
  );

  static final RegExp balance = RegExp(
    '(?:'
    r'баланс\s*(?:сч[её]та|карты)?|остаток|доступно|'
    r'avail(?:able)?\s*bal(?:ance)?|avl\.?\s*bal(?:ance)?|'
    r'bal(?:ance)?\s*(?:is|:)|your\s+new\s+(?:gcash\s+)?balance\s+is|'
    r'balance|saldo|so\s+du\s+hien\s+tai|'
    r'ձեր\s+(?:հաշվի\s+)?մնացորդը?|ваш\s+баланс'
    r')\D{0,18}(?:'
    '$currencyToken'
    r'\s*)?('
    '$numberToken'
    ')(?:\\s*$currencyToken)?',
    caseSensitive: false,
  );

  static final RegExp money = RegExp(
    '(?:$currencyToken\\s*($numberToken)|($numberToken)\\s*$currencyToken)',
    caseSensitive: false,
  );

  static final List<RegExp> referencePatterns = [
    RegExp(
      r'\btrxid[:\s#-]*([A-Z0-9-]{5,32})\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\brrn[:\s#-]*([A-Z0-9-]{5,32})\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\bref(?:erence)?(?:\s+no\.?)?[:\s#-]*([A-Z0-9-]{5,32})\b',
      caseSensitive: false,
    ),
  ];

  static final RegExp creditFlag = RegExp(r'\bcr\b', caseSensitive: false);
  static final RegExp debitFlag = RegExp(r'\bdr\b', caseSensitive: false);
}
