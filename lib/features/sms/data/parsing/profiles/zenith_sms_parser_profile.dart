import 'default_sms_parser_profile.dart';

class ZenithSmsParserProfile extends DefaultSmsParserProfile {
  const ZenithSmsParserProfile();

  static final RegExp _acctLast4 = RegExp(
    r'acct\s*:?\s*(?:\d{0,6}[*xX]{0,4})?(\d{4})\b',
    caseSensitive: false,
  );
  static final RegExp _balance = RegExp(
    r'avail\s+bal:\s*ngn\s*(\d[\d,]*(?:\.\d{1,2})?)',
    caseSensitive: false,
  );
  static final RegExp _amount = RegExp(
    r'amt:\s*ngn\s*(\d[\d,]*(?:\.\d{1,2})?)',
    caseSensitive: false,
  );

  @override
  String get profileId => 'zenith_ng';

  @override
  List<String> get senderAliases => const ['zenith', 'alertz', 'zenithbank'];

  @override
  List<String> get bodyKeywords => const [
    'amt:ngn',
    'alertz',
    'desc:nip/',
    'avail bal:ngn',
  ];

  @override
  List<RegExp> get last4Patterns => [_acctLast4];

  @override
  List<String> get incomingKeywords => const ['cr', 'credited', 'credit alert'];

  @override
  List<String> get outgoingKeywords => const ['dr', 'debited', 'debit alert'];

  @override
  List<String> get transferKeywords => const ['nip/', 'transfer to'];

  @override
  RegExp get balancePattern => _balance;

  @override
  RegExp get amountPattern => _amount;
}
