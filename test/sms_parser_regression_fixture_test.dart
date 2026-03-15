import 'package:flutter_test/flutter_test.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/sms_parser.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/sms_parser_profile_detector.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/operation_type.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/sms_message.dart';

import 'fixtures/sms_parser_regression_fixtures.dart';

SmsMessage _msg(String sender, String body) => SmsMessage(
  sender: sender,
  body: body,
  dateTime: DateTime(2026, 3, 14, 12, 0),
  parsed: false,
  operationType: OperationType.unknown,
);

void main() {
  group('SMS parser regression corpus', () {
    final detector = SmsParserProfileDetector();
    final parser = SmsParser();

    for (final fixture in smsParserRegressionFixtures) {
      test(fixture.id, () {
        final message = _msg(fixture.sender, fixture.body);
        final detectedProfile = detector.detect(message);
        final parsed = parser.parse(message);

        expect(detectedProfile.profileId, fixture.expectedProfileId);
        expect(parsed.operationType, fixture.expectedOperationType);
        expect(parsed.last4, fixture.expectedLast4);
        expect(parsed.amount, fixture.expectedAmount);
        expect(parsed.balance, fixture.expectedBalance);
        expect(parsed.reference, fixture.expectedReference);
        expect(parsed.isOtp, fixture.expectedIsOtp);
      });
    }
  });
}
