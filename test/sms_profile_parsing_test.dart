import 'package:flutter_test/flutter_test.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/profiles/axisbank_sms_parser_profile.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/profiles/access_sms_parser_profile.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/profiles/firstbank_sms_parser_profile.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/profiles/hdfcbank_sms_parser_profile.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/profiles/icicibank_sms_parser_profile.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/profiles/ubl_sms_parser_profile.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/profiles/zenith_sms_parser_profile.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/sms_parser.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/operation_type.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/sms_message.dart';

SmsMessage _msg(String body) => SmsMessage(
  sender: 'bank',
  body: body,
  dateTime: DateTime(2026, 3, 14, 12, 0),
  parsed: false,
  operationType: OperationType.unknown,
);

void main() {
  group('Profile-specific parsing', () {
    test('Axis profile parses debit alert sample', () {
      final parser = SmsParser(profile: const AxisbankSmsParserProfile());
      final result = parser.parse(
        _msg(
          'Your A/c XX8036 is debited with Rs 600.00. Avbl Bal is Rs 17,689.29. - Axis Bank',
        ),
      );

      expect(result.last4, '8036');
      expect(result.amount, 600);
      expect(result.balance, 17689.29);
      expect(result.operationType, OperationType.outgoing);
    });

    test('HDFC profile parses UPI debit sample', () {
      final parser = SmsParser(profile: const HdfcbankSmsParserProfile());
      final result = parser.parse(
        _msg(
          'HDFC Bank: Rs 99.00 debited from a/c **0161 to VPA merchant@okhdfc (UPI Ref No 123456789).',
        ),
      );

      expect(result.last4, '0161');
      expect(result.amount, 99);
      expect(result.balance, isNull);
      expect(result.operationType, OperationType.outgoing);
    });

    test('ICICI profile parses autopay debit sample', () {
      final parser = SmsParser(profile: const IcicibankSmsParserProfile());
      final result = parser.parse(
        _msg(
          'Your account has been successfully debited with Rs 149.00 on 10-Mar-2026 towards NOVI DIGITAL AutoPay, RRN 100146771939. - ICICI Bank',
        ),
      );

      expect(result.last4, isNull);
      expect(result.amount, 149);
      expect(result.balance, isNull);
      expect(result.reference, '100146771939');
      expect(result.operationType, OperationType.outgoing);
    });

    test('Zenith profile parses credit alert sample', () {
      final parser = SmsParser(profile: const ZenithSmsParserProfile());
      final result = parser.parse(
        _msg(
          'Acct:225**8036 Amt:NGN7,500.00 CR Desc:NIP/UBA/CHUKWUEMEKA Avail Bal:NGN19,200.00 REF:123456.',
        ),
      );

      expect(result.last4, '8036');
      expect(result.amount, 7500);
      expect(result.balance, 19200);
      expect(result.reference, '123456');
      expect(result.operationType, OperationType.incoming);
    });

    test('Access profile parses incoming credit sample', () {
      final parser = SmsParser(profile: const AccessSmsParserProfile());
      final result = parser.parse(
        _msg(
          'AccessAlert: Credit NGN20,000.00 to Acct XX8036. Avail Bal: NGN35,500.00',
        ),
      );

      expect(result.last4, '8036');
      expect(result.amount, 20000);
      expect(result.balance, 35500);
      expect(result.operationType, OperationType.incoming);
    });

    test('FirstBank profile parses credit sample', () {
      final parser = SmsParser(profile: const FirstbankSmsParserProfile());
      final result = parser.parse(
        _msg(
          'Txn: Credit. Acct: XX8036. Amt: NGN10,000.00. Desc: NIP/FirstBank/MARY OKAFOR. Avail Bal: NGN17,250.00. Date: 14-Mar-2026 14:07.',
        ),
      );

      expect(result.last4, '8036');
      expect(result.amount, 10000);
      expect(result.balance, 17250);
      expect(result.operationType, OperationType.incoming);
    });

    test('UBL profile parses IBFT credit sample', () {
      final parser = SmsParser(profile: const UblSmsParserProfile());
      final result = parser.parse(
        _msg(
          'UBL: PKR 10,000.00 credited to Acct XX8036. Desc: IBFT from HBL. Avl Bal PKR 45,000.00. REF: UBL998877.',
        ),
      );

      expect(result.last4, '8036');
      expect(result.amount, 10000);
      expect(result.balance, 45000);
      expect(result.reference, 'UBL998877');
      expect(result.operationType, OperationType.incoming);
    });
  });
}
