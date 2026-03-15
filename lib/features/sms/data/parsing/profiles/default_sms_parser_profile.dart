import '../sms_pattern_library.dart';
import 'sms_parser_profile.dart';

class DefaultSmsParserProfile extends SmsParserProfile {
  const DefaultSmsParserProfile();

  @override
  String get profileId => 'default';

  @override
  List<String> get senderAliases => const [];

  @override
  List<String> get bodyKeywords => const [];

  static const List<String> _incomingWords = [
    'зачисление',
    'зачислен',
    'поступление',
    'поступил',
    'пополнение',
    'пополнен',
    'перевод от',
    'перевод из',
    'получен',
    'возврат',
    'возвращено',
    'кэшбэк',
    'cashback',
    'credited',
    'credit alert',
    'credit',
    'cash in',
    'received',
    'kredit',
    'ստացել',
  ];

  static const List<String> _outgoingWords = [
    'списание',
    'списано',
    'списан',
    'оплата',
    'оплачено',
    'покупка',
    'снятие',
    'снято',
    'расход',
    'платёж',
    'платеж',
    'выдача',
    'выдано',
    'withdraw',
    'payment',
    'debited',
    'debit alert',
    'debit',
    'you have sent',
    'you paid',
    'cash out',
    'atm withdrawal',
    'debet',
    'tarik tunai',
    'փոխանցում',
  ];

  static const List<String> _transferWords = [
    'перевод',
    'переведено',
    'переведен',
    'transfer',
    'send money',
    'transfer to',
    'transfer ke',
    'ft to',
    'ibft',
    'trf to',
  ];

  @override
  RegExp get otpPattern => SmsPatternLibrary.otp;

  @override
  List<RegExp> get last4Patterns => const [];

  @override
  RegExp get balancePattern => SmsPatternLibrary.balance;

  @override
  RegExp get amountPattern => SmsPatternLibrary.money;

  @override
  List<RegExp> get referencePatterns => SmsPatternLibrary.referencePatterns;

  @override
  RegExp get creditFlagPattern => SmsPatternLibrary.creditFlag;

  @override
  RegExp get debitFlagPattern => SmsPatternLibrary.debitFlag;

  @override
  List<String> get incomingKeywords => _incomingWords;

  @override
  List<String> get outgoingKeywords => _outgoingWords;

  @override
  List<String> get transferKeywords => _transferWords;
}
