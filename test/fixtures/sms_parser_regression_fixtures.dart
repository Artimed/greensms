import 'package:zelenaya_sms/features/sms/domain/entities/operation_type.dart';

class SmsParserRegressionFixture {
  const SmsParserRegressionFixture({
    required this.id,
    required this.sender,
    required this.body,
    required this.expectedProfileId,
    required this.expectedOperationType,
    this.expectedLast4,
    this.expectedAmount,
    this.expectedBalance,
    this.expectedReference,
    this.expectedIsOtp = false,
  });

  final String id;
  final String sender;
  final String body;
  final String expectedProfileId;
  final OperationType expectedOperationType;
  final String? expectedLast4;
  final double? expectedAmount;
  final double? expectedBalance;
  final String? expectedReference;
  final bool expectedIsOtp;
}

// External regression corpus normalized from public evidence-pack sources.
const smsParserRegressionFixtures = <SmsParserRegressionFixture>[
  SmsParserRegressionFixture(
    id: 'sbi_in_debit_alert',
    sender: 'SBIINB',
    body:
        'INR 1,499.00 debited from A/c XX8036 towards AMAZON PAY. Avl Bal INR 18,500.00.',
    expectedProfileId: 'sbi_in',
    expectedOperationType: OperationType.outgoing,
    expectedLast4: '8036',
    expectedAmount: 1499,
    expectedBalance: 18500,
  ),
  SmsParserRegressionFixture(
    id: 'bkash_bd_outgoing_send_money',
    sender: 'bKash',
    body:
        'bKash: You have sent Tk 120.00 to 017XXXXXXXX successful. Ref CASHOUT. Fee Tk 0.00. Balance Tk 2,450.50. TrxID 9ABCD123.',
    expectedProfileId: 'bkash_bd',
    expectedOperationType: OperationType.outgoing,
    expectedAmount: 120,
    expectedBalance: 2450.5,
    expectedReference: '9ABCD123',
  ),
  SmsParserRegressionFixture(
    id: 'bkash_bd_incoming_receive_money',
    sender: 'bKash',
    body:
        'bKash: You have received Tk 500.00 from 017XXXXXXXX. Ref SALARY. Fee Tk 0.00. Balance Tk 4,100.75. TrxID 8XYZ456.',
    expectedProfileId: 'bkash_bd',
    expectedOperationType: OperationType.incoming,
    expectedAmount: 500,
    expectedBalance: 4100.75,
    expectedReference: '8XYZ456',
  ),
  SmsParserRegressionFixture(
    id: 'gtbank_ng_debit_alert',
    sender: 'GTBANK',
    body:
        'Acct: XX8036 Amt: NGN5,400.00 DR Desc: POS/SHOPRITE Avail Bal: NGN20,600.00 Date: 14-Mar-2026 13:05.',
    expectedProfileId: 'gtbank_ng',
    expectedOperationType: OperationType.outgoing,
    expectedLast4: '8036',
    expectedAmount: 5400,
    expectedBalance: 20600,
  ),
  SmsParserRegressionFixture(
    id: 'access_ng_debit_alert',
    sender: 'AccessAlert',
    body:
        'Debit NGN30,000.00 from Acct XX0466. Desc: POS PURCHASE. Avail Bal: NGN70,500.00.',
    expectedProfileId: 'access_ng',
    expectedOperationType: OperationType.outgoing,
    expectedLast4: '0466',
    expectedAmount: 30000,
    expectedBalance: 70500,
  ),
  SmsParserRegressionFixture(
    id: 'access_ng_credit_alert',
    sender: 'AccessAlert',
    body:
        'Credit NGN150,000.00 to Acct XX3968. Desc: NJFP STIPEND. Avail Bal: NGN180,250.55.',
    expectedProfileId: 'access_ng',
    expectedOperationType: OperationType.incoming,
    expectedLast4: '3968',
    expectedAmount: 150000,
    expectedBalance: 180250.55,
  ),
  SmsParserRegressionFixture(
    id: 'firstbank_ng_credit_alert',
    sender: 'FBN',
    body:
        'Txn: Credit. Acct: XX8036. Amt: NGN10,000.00. Desc: NIP/FIRSTBANK/MARY OKAFOR. Avail Bal: NGN17,250.00. Date: 14-Mar-2026 14:07.',
    expectedProfileId: 'firstbank_ng',
    expectedOperationType: OperationType.incoming,
    expectedLast4: '8036',
    expectedAmount: 10000,
    expectedBalance: 17250,
  ),
  SmsParserRegressionFixture(
    id: 'zenith_ng_credit_alert',
    sender: 'AlertZ',
    body:
        'Acct:225**8036 DT:14-Mar-2026 Desc:NIP/FIRSTBANK CR Amt:NGN7,500.00 Avail Bal:NGN19,200.00 REF:123456.',
    expectedProfileId: 'zenith_ng',
    expectedOperationType: OperationType.incoming,
    expectedLast4: '8036',
    expectedAmount: 7500,
    expectedBalance: 19200,
    expectedReference: '123456',
  ),
  SmsParserRegressionFixture(
    id: 'uba_ng_debit_alert',
    sender: 'UBAAlert',
    body:
        'Txn: Debit. Acct XX8036. Amt: NGN500.00. Des: POS PURCHASE. Date: 14-Mar-2026. Bal: NGN764.77. Ref: UBA998877.',
    expectedProfileId: 'uba_ng',
    expectedOperationType: OperationType.outgoing,
    expectedLast4: '8036',
    expectedAmount: 500,
    expectedBalance: 764.77,
    expectedReference: 'UBA998877',
  ),
  SmsParserRegressionFixture(
    id: 'ubl_pk_incoming_ibft_credit',
    sender: 'UBL',
    body:
        'UBL: PKR 10,000.00 credited to Acct XX8036. Desc: IBFT from HBL. Avl Bal PKR 45,000.00. REF: UBL998877.',
    expectedProfileId: 'ubl_pk',
    expectedOperationType: OperationType.incoming,
    expectedLast4: '8036',
    expectedAmount: 10000,
    expectedBalance: 45000,
    expectedReference: 'UBL998877',
  ),
  SmsParserRegressionFixture(
    id: 'ubl_pk_outgoing_transfer_debit',
    sender: 'UBL',
    body:
        'UBL: PKR 5,500.00 debited from Acct XX8036. Desc: transfer to HBL. Avl Bal PKR 39,500.00. REF: UBL665544.',
    expectedProfileId: 'ubl_pk',
    expectedOperationType: OperationType.outgoing,
    expectedLast4: '8036',
    expectedAmount: 5500,
    expectedBalance: 39500,
    expectedReference: 'UBL665544',
  ),
  SmsParserRegressionFixture(
    id: 'mandiri_id_outgoing_debet',
    sender: 'BANKMANDIRI',
    body:
        'BankMandiri: Debet Rp 125,000 dari rek.xx8036. Saldo Rp 950,000. Ref MB12345678.',
    expectedProfileId: 'mandiri_id',
    expectedOperationType: OperationType.outgoing,
    expectedLast4: '8036',
    expectedAmount: 125000,
    expectedBalance: 950000,
    expectedReference: 'MB12345678',
  ),
  SmsParserRegressionFixture(
    id: 'mandiri_id_incoming_kredit',
    sender: 'BANKMANDIRI',
    body:
        'BankMandiri: Kredit Rp 250,000 ke rek.xx8036. Saldo Rp 1,200,000. Ref MB87654321.',
    expectedProfileId: 'mandiri_id',
    expectedOperationType: OperationType.incoming,
    expectedLast4: '8036',
    expectedAmount: 250000,
    expectedBalance: 1200000,
    expectedReference: 'MB87654321',
  ),
  SmsParserRegressionFixture(
    id: 'gcash_ph_outgoing_send',
    sender: 'GCash',
    body:
        'GCash: You have sent PHP 350.00 to Maria Santos. Your new balance is PHP 1,250.50. TrxID 700ABC123.',
    expectedProfileId: 'gcash_ph',
    expectedOperationType: OperationType.outgoing,
    expectedAmount: 350,
    expectedBalance: 1250.5,
    expectedReference: '700ABC123',
  ),
  SmsParserRegressionFixture(
    id: 'gcash_ph_incoming_receive',
    sender: 'GCash',
    body:
        'GCash: You have received PHP 800.00 from Juan Cruz. Your new balance is PHP 2,050.75. TrxID 700XYZ456.',
    expectedProfileId: 'gcash_ph',
    expectedOperationType: OperationType.incoming,
    expectedAmount: 800,
    expectedBalance: 2050.75,
    expectedReference: '700XYZ456',
  ),
  SmsParserRegressionFixture(
    id: 'vivacell_am_outgoing_transfer_hy',
    sender: 'MobiDram',
    body:
        'MobiDram: կատարվել է փոխանցում 5000 AMD։ ձեր մնացորդը 12000 AMD։',
    expectedProfileId: 'vivacell_am',
    expectedOperationType: OperationType.outgoing,
    expectedAmount: 5000,
    expectedBalance: 12000,
  ),
  SmsParserRegressionFixture(
    id: 'vivacell_am_incoming_credit_hy',
    sender: 'MobiDram',
    body:
        'MobiDram: դուք ստացել եք 7500 AMD։ ձեր մնացորդը 19500 AMD։',
    expectedProfileId: 'vivacell_am',
    expectedOperationType: OperationType.incoming,
    expectedAmount: 7500,
    expectedBalance: 19500,
  ),
  SmsParserRegressionFixture(
    id: 'axisbank_in_generic_debit',
    sender: 'AXISBK',
    body:
        'Your A/c XX8036 is debited with Rs 600.00. Avbl Bal is Rs 17,689.29. - Axis Bank',
    expectedProfileId: 'axisbank_in',
    expectedOperationType: OperationType.outgoing,
    expectedLast4: '8036',
    expectedAmount: 600,
    expectedBalance: 17689.29,
  ),
  SmsParserRegressionFixture(
    id: 'hdfcbank_in_generic_upi_debit',
    sender: 'HDFCBK',
    body:
        'HDFC Bank: Rs 99.00 debited from a/c **0161 to VPA merchant@okhdfc (UPI Ref No 123456789).',
    expectedProfileId: 'hdfcbank_in',
    expectedOperationType: OperationType.outgoing,
    expectedLast4: '0161',
    expectedAmount: 99,
    expectedReference: '123456789',
  ),
  SmsParserRegressionFixture(
    id: 'icicibank_in_generic_autopay_debit',
    sender: 'ICICIB',
    body:
        'Your account has been successfully debited with Rs 149.00 on 10-Mar-2026 towards NOVI DIGITAL AutoPay, RRN 100146771939. - ICICI Bank',
    expectedProfileId: 'icicibank_in',
    expectedOperationType: OperationType.outgoing,
    expectedAmount: 149,
    expectedReference: '100146771939',
  ),
  SmsParserRegressionFixture(
    id: 'sberbank_ru_otp_message',
    sender: '900',
    body: 'Никому не сообщайте код 12345 для входа в СберБанк Онлайн.',
    expectedProfileId: 'sberbank_ru',
    expectedOperationType: OperationType.unknown,
    expectedIsOtp: true,
  ),
  SmsParserRegressionFixture(
    id: 'sberbank_ru_service_only_message',
    sender: '900',
    body: 'СберБанк: Ваш запрос принят. Подробности доступны в приложении.',
    expectedProfileId: 'sberbank_ru',
    expectedOperationType: OperationType.unknown,
  ),
  SmsParserRegressionFixture(
    id: 'uba_ng_malformed_alert',
    sender: 'UBAAlert',
    body: 'UBA Alert: Txn pending. Acct XX8036. Amt: NGN ---. Date: 14-Mar-2026.',
    expectedProfileId: 'uba_ng',
    expectedOperationType: OperationType.unknown,
    expectedLast4: '8036',
  ),
  SmsParserRegressionFixture(
    id: 'unsupported_bank_service_message',
    sender: 'PAYTM',
    body: 'Paytm: Security notice. Login from a new device was detected.',
    expectedProfileId: 'default',
    expectedOperationType: OperationType.unknown,
  ),
];
