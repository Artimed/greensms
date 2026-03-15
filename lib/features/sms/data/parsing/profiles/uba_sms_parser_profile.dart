import '../sms_pattern_library.dart';
import 'default_sms_parser_profile.dart';

class UbaSmsParserProfile extends DefaultSmsParserProfile {
  const UbaSmsParserProfile();

  static final RegExp _acctLast4 = RegExp(
    r'acct\s*(?:xx|x{1,4}|\d{0,6})?(\d{4})\b',
    caseSensitive: false,
  );
  static final List<RegExp> _referencePatterns = [
    RegExp(r'\bref[:\s#-]*([A-Z0-9-]{5,32})\b', caseSensitive: false),
    RegExp(r'\bsession(?:\s+id)?[:\s#-]*([A-Z0-9-]{5,32})\b', caseSensitive: false),
  ];

  @override
  String get profileId => 'uba_ng';

  @override
  List<String> get senderAliases => const ['uba', 'uba alert', 'ubaalert'];

  @override
  List<String> get bodyKeywords => const [
    'uba alert',
    'debit ngn',
    'credit ngn',
    'bal: ngn',
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
  RegExp get amountPattern => SmsPatternLibrary.money;

  @override
  List<RegExp> get referencePatterns => [
    ..._referencePatterns,
    ...super.referencePatterns,
  ];
}
