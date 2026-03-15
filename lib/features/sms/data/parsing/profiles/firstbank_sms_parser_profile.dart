import 'default_sms_parser_profile.dart';

class FirstbankSmsParserProfile extends DefaultSmsParserProfile {
  const FirstbankSmsParserProfile();

  static final RegExp _acctLast4 = RegExp(
    r'acct\s*:?\s*(?:xx|x{1,4}|\d{0,6})?(\d{4})\b',
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
  String get profileId => 'firstbank_ng';

  @override
  List<String> get senderAliases => const [
    'firstbank',
    'firstbank nigeria',
    'fbn',
  ];

  @override
  List<String> get bodyKeywords => const [
    'txn: credit',
    'txn: debit',
    'nip/firstbank',
    'avail bal: ngn',
  ];

  @override
  List<RegExp> get last4Patterns => [_acctLast4];

  @override
  List<String> get incomingKeywords => const ['txn: credit', 'credited'];

  @override
  List<String> get outgoingKeywords => const ['txn: debit', 'debited'];

  @override
  List<String> get transferKeywords => const ['nip/', 'transfer to'];

  @override
  RegExp get balancePattern => _balance;

  @override
  RegExp get amountPattern => _amount;
}
