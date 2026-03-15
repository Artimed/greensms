import 'default_sms_parser_profile.dart';

class UblSmsParserProfile extends DefaultSmsParserProfile {
  const UblSmsParserProfile();

  static final RegExp _acctLast4 = RegExp(
    r'acct\s*(?:xx|x{1,4}|\d{0,6})?(\d{4})\b',
    caseSensitive: false,
  );
  static final RegExp _balance = RegExp(
    r'avl\s+bal\s+pkr\s*(\d[\d,]*(?:\.\d{1,2})?)',
    caseSensitive: false,
  );
  static final RegExp _amount = RegExp(
    r'pkr\s*(\d[\d,]*(?:\.\d{1,2})?)\s*(?:credited|debited)',
    caseSensitive: false,
  );
  static final List<RegExp> _referencePatterns = [
    RegExp(r'\b(?:ibft\s+ref|ref)[:\s#-]*([A-Z0-9-]{5,32})\b', caseSensitive: false),
  ];

  @override
  String get profileId => 'ubl_pk';

  @override
  List<String> get senderAliases => const ['ubl', 'ubl bank', 'ublalert'];

  @override
  List<String> get bodyKeywords => const ['ubl:', 'pkr', 'ibft', 'avl bal pkr'];

  @override
  List<RegExp> get last4Patterns => [_acctLast4];

  @override
  List<String> get incomingKeywords => const ['credited', 'ibft from'];

  @override
  List<String> get outgoingKeywords => const ['debited', 'transfer to'];

  @override
  List<String> get transferKeywords => const ['ibft'];

  @override
  RegExp get balancePattern => _balance;

  @override
  RegExp get amountPattern => _amount;

  @override
  List<RegExp> get referencePatterns => [
    ..._referencePatterns,
    ...super.referencePatterns,
  ];
}
