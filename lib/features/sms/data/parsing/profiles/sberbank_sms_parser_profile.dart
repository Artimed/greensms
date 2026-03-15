import '../sms_pattern_library.dart';
import 'default_sms_parser_profile.dart';

class SberbankSmsParserProfile extends DefaultSmsParserProfile {
  const SberbankSmsParserProfile();

  @override
  String get profileId => 'sberbank_ru';

  @override
  List<String> get senderAliases => const ['900', 'sberbank', 'sber'];

  @override
  List<String> get bodyKeywords => const [
    'сбербанк',
    'сбербанке',
    'сбербанк онлайн',
    '@online.sberbank.ru',
    'ecmc',
    'mir-',
    'счёт',
  ];

  @override
  RegExp get otpPattern => SmsPatternLibrary.otp;
}
