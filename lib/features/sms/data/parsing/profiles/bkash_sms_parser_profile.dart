import 'default_sms_parser_profile.dart';

class BkashSmsParserProfile extends DefaultSmsParserProfile {
  const BkashSmsParserProfile();

  static final RegExp _balance = RegExp(
    r'balance\s+tk\s+(\d[\d,]*(?:\.\d{1,2})?)',
    caseSensitive: false,
  );

  static final RegExp _amount = RegExp(
    r'you\s+have\s+(?:sent\s+tk\s+(\d[\d,]*(?:\.\d{1,2})?)|received\s+tk\s+(\d[\d,]*(?:\.\d{1,2})?))',
    caseSensitive: false,
  );

  @override
  String get profileId => 'bkash_bd';

  @override
  List<String> get senderAliases => const ['bkash'];

  @override
  List<String> get bodyKeywords => const [
    'bkash:',
    'you have sent tk',
    'you have received tk',
    'balance tk',
    'trxid',
  ];

  @override
  RegExp get balancePattern => _balance;

  @override
  RegExp get amountPattern => _amount;

  @override
  List<String> get incomingKeywords => const ['you have received'];

  @override
  List<String> get outgoingKeywords => const ['you have sent'];

  @override
  List<String> get transferKeywords => const ['send money'];
}
