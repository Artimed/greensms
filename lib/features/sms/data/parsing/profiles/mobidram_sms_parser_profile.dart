import 'default_sms_parser_profile.dart';

class MobidramSmsParserProfile extends DefaultSmsParserProfile {
  const MobidramSmsParserProfile();

  static final RegExp _balance = RegExp(
    r'(?:ձեր\s+մնացորդը[:՝]?\s*|ваш\s+баланс[: ]\s*)(\d[\d,]*(?:\.\d{1,2})?)\s*amd',
    caseSensitive: false,
  );

  static final RegExp _amount = RegExp(
    r'(?:կատարվել\s+է\s+փոխանցում\s+(\d[\d,]*(?:\.\d{1,2})?)\s*amd|դուք\s+ստացել\s+եք\s+(\d[\d,]*(?:\.\d{1,2})?)\s*amd|перевод\s+(\d[\d,]*(?:\.\d{1,2})?)\s*amd)',
    caseSensitive: false,
  );

  @override
  String get profileId => 'vivacell_am';

  @override
  List<String> get senderAliases => const ['mobidram', 'vivacell', 'viva'];

  @override
  List<String> get bodyKeywords => const [
    'mobidram',
    'amd',
    'ձեր մնացորդը',
    'դուք ստացել եք',
    'կատարվել է փոխանցում',
  ];

  @override
  RegExp get balancePattern => _balance;

  @override
  RegExp get amountPattern => _amount;

  @override
  List<String> get incomingKeywords => const [
    'դուք ստացել եք',
    'ստացել եք',
    'received',
  ];

  @override
  List<String> get outgoingKeywords => const [
    'կատարվել է փոխանցում',
    'փոխանցում',
  ];

  @override
  List<String> get transferKeywords => const ['перевод', 'transfer'];
}
