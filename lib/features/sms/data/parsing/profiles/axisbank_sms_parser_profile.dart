import 'default_sms_parser_profile.dart';

class AxisbankSmsParserProfile extends DefaultSmsParserProfile {
  const AxisbankSmsParserProfile();

  @override
  String get profileId => 'axisbank_in';

  @override
  List<String> get senderAliases => const ['axisbk', 'axisbank', 'axis'];

  @override
  List<String> get bodyKeywords => const [
    'axis bank',
    'your a/c',
    'avbl bal is rs',
    'mandate due',
  ];
}
