import 'package:flutter_test/flutter_test.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/sms_parser_profile_detector.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/operation_type.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/sms_message.dart';

SmsMessage _msg({required String sender, required String body}) => SmsMessage(
  sender: sender,
  body: body,
  dateTime: DateTime(2026, 3, 14, 12, 0),
  parsed: false,
  operationType: OperationType.unknown,
);

void main() {
  final detector = SmsParserProfileDetector();

  group('SmsParserProfileDetector', () {
    test('detects Sberbank profile by sender 900', () {
      final profile = detector.detect(
        _msg(sender: '900', body: 'ECMC4874 Покупка 3150р Баланс: 4410.68р'),
      );

      expect(profile.profileId, 'sberbank_ru');
    });

    test('detects SBI profile by IMPS and INR body keywords', () {
      final profile = detector.detect(
        _msg(
          sender: 'VM-ALERT',
          body:
              'INR 5,000 credited to A/C XX8036 via IMPS. Avl Bal INR 20,200.',
        ),
      );

      expect(profile.profileId, 'sbi_in');
    });

    test('detects Axis Bank profile by sender and balance wording', () {
      final profile = detector.detect(
        _msg(
          sender: 'AXISBK',
          body:
              'Your A/c XX8036 is debited with Rs 600.00. Avbl Bal is Rs 17,689.29. - Axis Bank',
        ),
      );

      expect(profile.profileId, 'axisbank_in');
    });

    test('detects HDFC Bank profile by sender and UPI wording', () {
      final profile = detector.detect(
        _msg(
          sender: 'HDFCBK',
          body:
              'HDFC Bank: Rs 99.00 debited from a/c **0161 to VPA merchant@okhdfc (UPI Ref No 123456789).',
        ),
      );

      expect(profile.profileId, 'hdfcbank_in');
    });

    test('detects ICICI Bank profile by sender and autopay wording', () {
      final profile = detector.detect(
        _msg(
          sender: 'ICICIB',
          body:
              'Your account has been successfully debited with Rs 149.00 on 10-Mar-2026 towards NOVI DIGITAL AutoPay, RRN 100146771939. - ICICI Bank',
        ),
      );

      expect(profile.profileId, 'icicibank_in');
    });

    test('falls back to default for unknown sender and body', () {
      final profile = detector.detect(
        _msg(
          sender: 'unknown',
          body: 'Random service message without payment semantics.',
        ),
      );

      expect(profile.profileId, 'default');
    });

    test('detects GTBank profile by sender and body keywords', () {
      final profile = detector.detect(
        _msg(
          sender: 'GTBANK',
          body:
              'Acct: XX8036 Amt: NGN1,000.00 DR Desc: Transfer to 0123456789 GTB Avail Bal: NGN14,200.00',
        ),
      );

      expect(profile.profileId, 'gtbank_ng');
    });

    test('detects Mandiri profile by sender and body keywords', () {
      final profile = detector.detect(
        _msg(
          sender: 'BANKMANDIRI',
          body:
              'BANKMANDIRI: Rek.XX8036 tgl 14/03/26 09:30 Debet Rp1.000.000 Ket:Transfer ke 1234567890. Saldo Rp8.500.000',
        ),
      );

      expect(profile.profileId, 'mandiri_id');
    });

    test('detects GCash profile by body keywords even with generic sender', () {
      final profile = detector.detect(
        _msg(
          sender: '900',
          body:
              'You have sent PHP 500.00 GCASH to Juan 09171234567. Your new balance is PHP 2,550.00.',
        ),
      );

      expect(profile.profileId, 'gcash_ph');
    });

    test('detects MobiDram profile by Armenian body keywords', () {
      final profile = detector.detect(
        _msg(
          sender: '900',
          body:
              'MobiDram: Դուք ստացել եք 10,000 AMD 077456789 բաժանորդից։ Ձեր մնացորդը՝ 52,800 AMD',
        ),
      );

      expect(profile.profileId, 'vivacell_am');
    });

    test('detects UBA profile by body keywords', () {
      final profile = detector.detect(
        _msg(
          sender: '900',
          body:
              'UBA Alert: Debit NGN2,750.00 on Acct XX8036. Desc: POS NNPC. Bal: NGN9,450.00',
        ),
      );

      expect(profile.profileId, 'uba_ng');
    });

    test('detects bKash profile by body keywords', () {
      final profile = detector.detect(
        _msg(
          sender: '900',
          body:
              'bKash: You have sent Tk 500.00 to 01712345678. Fee Tk 5.00. Balance Tk 1,495.00. TrxID AA12345',
        ),
      );

      expect(profile.profileId, 'bkash_bd');
    });

    test('detects Zenith profile by AlertZ body keywords', () {
      final profile = detector.detect(
        _msg(
          sender: '900',
          body:
              'Acct:225**8036 Amt:NGN7,500.00 CR Desc:NIP/UBA/CHUKWUEMEKA Avail Bal:NGN19,200.00',
        ),
      );

      expect(profile.profileId, 'zenith_ng');
    });

    test('detects Access profile by AccessAlert body keywords', () {
      final profile = detector.detect(
        _msg(
          sender: '900',
          body:
              'AccessAlert: Credit NGN20,000.00 to Acct XX8036. Avail Bal: NGN35,500.00',
        ),
      );

      expect(profile.profileId, 'access_ng');
    });

    test('detects UBL profile by PKR and IBFT body keywords', () {
      final profile = detector.detect(
        _msg(
          sender: '900',
          body:
              'UBL: PKR 10,000.00 credited to Acct XX8036. Desc: IBFT from HBL. Avl Bal PKR 45,000.00',
        ),
      );

      expect(profile.profileId, 'ubl_pk');
    });

    test('detects FirstBank profile by txn and nip keywords', () {
      final profile = detector.detect(
        _msg(
          sender: '900',
          body:
              'Txn: Credit. Acct: XX8036. Amt: NGN10,000.00. Desc: NIP/FirstBank/MARY OKAFOR. Avail Bal: NGN17,250.00. Date: 14-Mar-2026 14:07.',
        ),
      );

      expect(profile.profileId, 'firstbank_ng');
    });
  });
}
