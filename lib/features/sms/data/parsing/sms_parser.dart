import '../../domain/entities/operation_type.dart';
import '../../domain/entities/sms_message.dart';
import 'profiles/default_sms_parser_profile.dart';
import 'profiles/sms_parser_profile.dart';
import 'sms_number_parser.dart';
import 'sms_parser_profile_detector.dart';
import 'sms_pattern_library.dart';

/// Парсер SMS-уведомлений банков.
///
/// Поддерживает форматы:
/// - 🇷🇺 Сбербанк, Т-Банк, Альфа-Банк, ВТБ (RUB)
/// - 🇳🇬 GTBank, First Bank, Zenith, UBA, Access (NGN)
/// - 🇮🇳 SBI, Axis, HDFC, ICICI (INR)
/// - 🇵🇰 UBL (PKR)
/// - 🇧🇩 bKash (BDT / Tk)
/// - 🇮🇩 Bank Mandiri (IDR / Rp)
/// - 🇵🇭 GCash (PHP)
/// - 🇦🇲 VivaCell MobiDram (AMD)
///
/// `VN / Vietcombank` intentionally remains outside command routing because
/// official SMS Banking does not support one-line transfer commands.
class SmsParser {
  SmsParser({SmsParserProfile? profile, SmsNumberParser? numberParser})
    : _explicitProfile = profile,
      _detector = SmsParserProfileDetector(),
      _numberParser = numberParser ?? const SmsNumberParser();

  final SmsParserProfile? _explicitProfile;
  final SmsParserProfileDetector _detector;
  final SmsNumberParser _numberParser;

  // ─── public API ────────────────────────────────────────────────────────────

  SmsMessage parse(SmsMessage message) {
    final body = message.body;
    final lower = body.toLowerCase();
    final profile = _explicitProfile ?? _detector.detect(message);

    final isOtp = profile.otpPattern.hasMatch(lower);

    final last4 = _extractLast4(body, profile);
    final balanceMatch = profile.balancePattern.firstMatch(body);
    final balance = balanceMatch != null
        ? _numberParser.parseFlexibleNumber(balanceMatch.group(1))
        : null;
    final amount = _extractAmount(body, balanceMatch?.start, profile);
    final reference = _extractReference(body, profile);
    final operationType = _extractOperationType(lower, profile);

    return message.copyWith(
      parsed: true,
      isOtp: isOtp,
      last4: last4,
      balance: balance,
      amount: amount,
      reference: reference,
      operationType: operationType,
    );
  }

  // ─── private extractors ────────────────────────────────────────────────────

  String? _extractLast4(String text, [SmsParserProfile? profile]) {
    for (final pattern
        in (profile ?? const DefaultSmsParserProfile()).last4Patterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    final bankCode = SmsPatternLibrary.bankCodeLast4.firstMatch(text);
    if (bankCode != null) return bankCode.group(2);

    final masked = SmsPatternLibrary.maskedLast4.firstMatch(text);
    if (masked != null) return masked.group(1);

    final named = SmsPatternLibrary.namedLast4.firstMatch(text);
    if (named != null) return named.group(1);

    return null;
  }

  double? _extractAmount(
    String text,
    int? balanceStartPos,
    SmsParserProfile profile,
  ) {
    for (final m in profile.amountPattern.allMatches(text)) {
      if (balanceStartPos != null && m.start >= balanceStartPos) continue;
      final rawValue = _firstCapturedGroup(m);
      final v = _numberParser.parseFlexibleNumber(rawValue);
      if (v == null) continue;
      return v;
    }
    return null;
  }

  String? _extractReference(String text, SmsParserProfile profile) {
    for (final pattern in profile.referencePatterns) {
      final match = pattern.firstMatch(text);
      if (match == null) continue;
      final raw = _firstCapturedGroup(match);
      if (raw == null) continue;
      final normalized = raw.trim().replaceAll(RegExp(r'[.。,;:]+$'), '');
      if (normalized.isEmpty) continue;
      return normalized;
    }
    return null;
  }

  OperationType _extractOperationType(String lower, SmsParserProfile profile) {
    if (_containsAny(lower, profile.incomingKeywords)) {
      return OperationType.incoming;
    }
    if (_containsAny(lower, profile.outgoingKeywords)) {
      return OperationType.outgoing;
    }
    if (_containsAny(lower, profile.transferKeywords)) {
      return OperationType.transfer;
    }
    if (profile.creditFlagPattern.hasMatch(lower)) {
      return OperationType.incoming;
    }
    if (profile.debitFlagPattern.hasMatch(lower)) {
      return OperationType.outgoing;
    }
    return OperationType.unknown;
  }

  bool _containsAny(String text, List<String> needles) {
    for (final n in needles) {
      if (text.contains(n)) return true;
    }
    return false;
  }

  String? _firstCapturedGroup(RegExpMatch match) {
    for (var i = 1; i <= match.groupCount; i++) {
      final value = match.group(i);
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
