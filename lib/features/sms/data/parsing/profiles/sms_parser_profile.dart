abstract class SmsParserProfile {
  const SmsParserProfile();

  String get profileId;
  RegExp get otpPattern;
  List<RegExp> get last4Patterns;
  RegExp get balancePattern;
  RegExp get amountPattern;
  List<RegExp> get referencePatterns;
  RegExp get creditFlagPattern;
  RegExp get debitFlagPattern;
  List<String> get senderAliases;
  List<String> get bodyKeywords;

  List<String> get incomingKeywords;
  List<String> get outgoingKeywords;
  List<String> get transferKeywords;
}
