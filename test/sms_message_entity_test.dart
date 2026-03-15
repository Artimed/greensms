import 'package:flutter_test/flutter_test.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/operation_type.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/sms_message.dart';

void main() {
  group('SmsMessage entity', () {
    test('preserves reference in db roundtrip', () {
      final original = SmsMessage(
        id: 7,
        sender: 'ICICIB',
        body: 'Sample body',
        dateTime: DateTime(2026, 3, 14, 12, 0),
        parsed: true,
        operationType: OperationType.outgoing,
        last4: '8036',
        amount: 149,
        balance: 18500,
        reference: '100146771939',
        isOtp: false,
      );

      final restored = SmsMessage.fromDbMap(original.toDbMap());

      expect(restored.reference, '100146771939');
      expect(restored.amount, 149);
      expect(restored.balance, 18500);
      expect(restored.last4, '8036');
    });

    test('copyWith updates reference without losing other fields', () {
      final original = SmsMessage(
        sender: 'bKash',
        body: 'Body',
        dateTime: DateTime(2026, 3, 14, 12, 0),
        parsed: true,
        operationType: OperationType.incoming,
        amount: 500,
        balance: 4100.75,
        reference: 'OLDREF',
      );

      final updated = original.copyWith(reference: 'NEWREF');

      expect(updated.reference, 'NEWREF');
      expect(updated.amount, 500);
      expect(updated.balance, 4100.75);
      expect(updated.operationType, OperationType.incoming);
    });
  });
}
