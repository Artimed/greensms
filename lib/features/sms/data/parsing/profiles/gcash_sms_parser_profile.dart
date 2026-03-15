import 'default_sms_parser_profile.dart';

class GcashSmsParserProfile extends DefaultSmsParserProfile {
  const GcashSmsParserProfile();

  static final RegExp _balance = RegExp(
    r'your\s+new\s+balance\s+is\s+php\s+(\d[\d,]*(?:\.\d{1,2})?)',
    caseSensitive: false,
  );

  static final RegExp _amount = RegExp(
    r'(?:you\s+have\s+sent\s+php\s+(\d[\d,]*(?:\.\d{1,2})?)|you\s+have\s+received\s+php\s+(\d[\d,]*(?:\.\d{1,2})?)|you\s+paid\s+php\s+(\d[\d,]*(?:\.\d{1,2})?))',
    caseSensitive: false,
  );
  static final List<RegExp> _referencePatterns = [
    RegExp(r'\btrxid[:\s#-]*([A-Z0-9-]{5,32})\b', caseSensitive: false),
    RegExp(r'\bref(?:\s+no\.?)?[:\s#-]*([A-Z0-9-]{5,32})\b', caseSensitive: false),
  ];

  @override
  String get profileId => 'gcash_ph';

  @override
  List<String> get senderAliases => const ['gcash'];

  @override
  List<String> get bodyKeywords => const [
    'gcash',
    'you have sent php',
    'you have received php',
    'your new balance is php',
  ];

  @override
  RegExp get balancePattern => _balance;

  @override
  RegExp get amountPattern => _amount;

  @override
  List<String> get incomingKeywords => const [
    'you have received',
    'received php',
  ];

  @override
  List<String> get outgoingKeywords => const ['you have sent', 'you paid'];

  @override
  List<String> get transferKeywords => const ['send money'];

  @override
  List<RegExp> get referencePatterns => [
    ..._referencePatterns,
    ...super.referencePatterns,
  ];
}
