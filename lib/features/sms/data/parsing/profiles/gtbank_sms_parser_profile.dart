import '../sms_pattern_library.dart';
import 'default_sms_parser_profile.dart';

class GtbankSmsParserProfile extends DefaultSmsParserProfile {
  const GtbankSmsParserProfile();

  static final RegExp _acctLast4 = RegExp(
    r'acct\s*:?\s*(?:xx|x{1,4}|\d{0,6})?(\d{4})\b',
    caseSensitive: false,
  );

  @override
  String get profileId => 'gtbank_ng';

  @override
  List<String> get senderAliases => const [
    'gtbank',
    'gtb',
    'gtalert',
    'gtworld',
  ];

  @override
  List<String> get bodyKeywords => const [
    'amt: ngn',
    'avail bal: ngn',
    'desc: transfer to',
    'gtb',
  ];

  @override
  List<String> get incomingKeywords => const ['credited', 'credit alert'];

  @override
  List<String> get outgoingKeywords => const ['debited', 'debit alert'];

  @override
  List<String> get transferKeywords => const ['transfer to', 'ft to'];

  @override
  List<RegExp> get last4Patterns => [_acctLast4];

  @override
  RegExp get amountPattern => SmsPatternLibrary.money;
}
