import 'default_sms_parser_profile.dart';

class AccessSmsParserProfile extends DefaultSmsParserProfile {
  const AccessSmsParserProfile();

  static final RegExp _acctLast4 = RegExp(
    r'acct\s*(?:xx|x{1,4}|\d{0,6})?(\d{4})\b',
    caseSensitive: false,
  );
  static final RegExp _balance = RegExp(
    r'avail\s+bal:\s*ngn\s*(\d[\d,]*(?:\.\d{1,2})?)',
    caseSensitive: false,
  );
  static final RegExp _amount = RegExp(
    r'(?:credit|debit)\s+ngn\s*(\d[\d,]*(?:\.\d{1,2})?)',
    caseSensitive: false,
  );

  @override
  String get profileId => 'access_ng';

  @override
  List<String> get senderAliases => const [
    'accessalert',
    'access',
    'access bank',
  ];

  @override
  List<String> get bodyKeywords => const [
    'accessalert',
    'credit ngn',
    'debit ngn',
    'avail bal: ngn',
  ];

  @override
  List<RegExp> get last4Patterns => [_acctLast4];

  @override
  List<String> get incomingKeywords => const ['credit', 'credited'];

  @override
  List<String> get outgoingKeywords => const ['debit', 'debited'];

  @override
  List<String> get transferKeywords => const ['transfer to'];

  @override
  RegExp get balancePattern => _balance;

  @override
  RegExp get amountPattern => _amount;
}
