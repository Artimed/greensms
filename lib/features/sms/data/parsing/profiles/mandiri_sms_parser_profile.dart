import '../sms_pattern_library.dart';
import 'default_sms_parser_profile.dart';

class MandiriSmsParserProfile extends DefaultSmsParserProfile {
  const MandiriSmsParserProfile();

  static final RegExp _rekeningLast4 = RegExp(
    r'rek\.?\s*(?:xx|x{1,4}|\d{0,6})?(\d{4})\b',
    caseSensitive: false,
  );
  static final List<RegExp> _referencePatterns = [
    RegExp(r'\b(?:ref|no\.?\s*ref)[:\s#-]*([A-Z0-9-]{5,32})\b', caseSensitive: false),
    RegExp(r'\btrx(?:\s+id)?[:\s#-]*([A-Z0-9-]{5,32})\b', caseSensitive: false),
  ];

  @override
  String get profileId => 'mandiri_id';

  @override
  List<String> get senderAliases => const ['bankmandiri', 'mandiri', 'bmri'];

  @override
  List<String> get bodyKeywords => const [
    'bankmandiri',
    'rek.xx',
    'debet rp',
    'kredit rp',
    'saldo rp',
  ];

  @override
  List<String> get incomingKeywords => const ['kredit', 'transfer dari'];

  @override
  List<String> get outgoingKeywords => const ['debet', 'tarik tunai'];

  @override
  List<String> get transferKeywords => const ['transfer ke', 'trf to'];

  @override
  List<RegExp> get last4Patterns => [_rekeningLast4];

  @override
  RegExp get amountPattern => SmsPatternLibrary.money;

  @override
  List<RegExp> get referencePatterns => [
    ..._referencePatterns,
    ...super.referencePatterns,
  ];
}
