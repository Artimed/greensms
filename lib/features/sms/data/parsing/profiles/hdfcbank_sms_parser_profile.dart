import 'default_sms_parser_profile.dart';

class HdfcbankSmsParserProfile extends DefaultSmsParserProfile {
  const HdfcbankSmsParserProfile();

  @override
  String get profileId => 'hdfcbank_in';

  @override
  List<String> get senderAliases => const ['hdfcbk', 'hdfcbank', 'hdfc'];

  @override
  List<String> get bodyKeywords => const [
    'hdfc bank:',
    'upi ref no',
    'debited from a/c',
    'spent on hdfc bank card',
  ];
}
