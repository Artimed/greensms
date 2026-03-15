import 'default_sms_parser_profile.dart';

class SbiSmsParserProfile extends DefaultSmsParserProfile {
  const SbiSmsParserProfile();

  @override
  String get profileId => 'sbi_in';

  @override
  List<String> get senderAliases => const ['sbi', 'sbibnk', 'sbiinb'];

  @override
  List<String> get bodyKeywords => const [
    'imps',
    'avl bal inr',
    'credited to a/c',
    'acct xx',
    'debited by inr',
  ];
}
