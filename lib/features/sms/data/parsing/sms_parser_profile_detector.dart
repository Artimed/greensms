import '../../domain/entities/sms_message.dart';
import 'profiles/access_sms_parser_profile.dart';
import 'profiles/axisbank_sms_parser_profile.dart';
import 'profiles/bkash_sms_parser_profile.dart';
import 'profiles/default_sms_parser_profile.dart';
import 'profiles/firstbank_sms_parser_profile.dart';
import 'profiles/gcash_sms_parser_profile.dart';
import 'profiles/gtbank_sms_parser_profile.dart';
import 'profiles/hdfcbank_sms_parser_profile.dart';
import 'profiles/mandiri_sms_parser_profile.dart';
import 'profiles/mobidram_sms_parser_profile.dart';
import 'profiles/icicibank_sms_parser_profile.dart';
import 'profiles/sbi_sms_parser_profile.dart';
import 'profiles/sberbank_sms_parser_profile.dart';
import 'profiles/sms_parser_profile.dart';
import 'profiles/uba_sms_parser_profile.dart';
import 'profiles/ubl_sms_parser_profile.dart';
import 'profiles/zenith_sms_parser_profile.dart';

class SmsParserProfileDetector {
  SmsParserProfileDetector({List<SmsParserProfile>? profiles})
    : _profiles =
          profiles ??
          const [
            SberbankSmsParserProfile(),
            SbiSmsParserProfile(),
            AxisbankSmsParserProfile(),
            HdfcbankSmsParserProfile(),
            IcicibankSmsParserProfile(),
            GtbankSmsParserProfile(),
            FirstbankSmsParserProfile(),
            ZenithSmsParserProfile(),
            UbaSmsParserProfile(),
            AccessSmsParserProfile(),
            UblSmsParserProfile(),
            BkashSmsParserProfile(),
            MandiriSmsParserProfile(),
            GcashSmsParserProfile(),
            MobidramSmsParserProfile(),
            DefaultSmsParserProfile(),
          ];

  final List<SmsParserProfile> _profiles;

  SmsParserProfile detect(SmsMessage message) {
    final sender = message.sender.trim().toLowerCase();
    final body = message.body.toLowerCase();

    SmsParserProfile? bestProfile;
    var bestScore = 0;

    for (final profile in _profiles) {
      if (profile.profileId == 'default') continue;

      var score = 0;

      if (profile.senderAliases.any((alias) => sender == alias.toLowerCase())) {
        score += 8;
      }

      if (profile.senderAliases.any(
        (alias) => alias.isNotEmpty && sender.contains(alias.toLowerCase()),
      )) {
        score += 3;
      }

      for (final keyword in profile.bodyKeywords) {
        if (body.contains(keyword.toLowerCase())) {
          score += 4;
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestProfile = profile;
      }
    }

    return bestProfile ?? _defaultProfile;
  }

  SmsParserProfile get _defaultProfile => _profiles.firstWhere(
    (profile) => profile.profileId == 'default',
    orElse: () => const DefaultSmsParserProfile(),
  );
}
