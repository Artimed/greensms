import 'default_sms_parser_profile.dart';

class IcicibankSmsParserProfile extends DefaultSmsParserProfile {
  const IcicibankSmsParserProfile();

  @override
  String get profileId => 'icicibank_in';

  @override
  List<String> get senderAliases => const ['icicib', 'icicibank', 'icici'];

  @override
  List<String> get bodyKeywords => const [
    'icici bank',
    'successfully debited',
    'autopay',
    'rrn',
  ];
}
