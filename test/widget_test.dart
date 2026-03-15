import 'package:flutter_test/flutter_test.dart';
import 'package:zelenaya_sms/features/sms/data/parsing/sms_parser.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/operation_type.dart';
import 'package:zelenaya_sms/features/sms/domain/entities/sms_message.dart';

SmsMessage _msg(String body) => SmsMessage(
  sender: '900',
  body: body,
  dateTime: DateTime(2026, 3, 13, 12, 0),
  parsed: false,
  operationType: OperationType.unknown,
);

void main() {
  final parser = SmsParser();

  // ─── Синтетические тесты ────────────────────────────────────────────────

  group('Сбербанк 900 — зачисление', () {
    test('Формат: Зачисление Nр Карта *XXXX Баланс Nр', () {
      final r = parser.parse(
        _msg('СБЕРБАНК Зачисление 15000р Карта *3456 Баланс: 42000р'),
      );
      expect(r.last4, '3456');
      expect(r.amount, 15000);
      expect(r.balance, 42000);
      expect(r.operationType, OperationType.incoming);
    });

    test('Формат с ₽ и пробелами', () {
      final r = parser.parse(
        _msg('СБЕРБАНК. Зачисление 5 000 ₽. Карта *1234. Баланс: 20 500 ₽.'),
      );
      expect(r.last4, '1234');
      expect(r.amount, 5000);
      expect(r.balance, 20500);
      expect(r.operationType, OperationType.incoming);
    });

    test('Формат: перевод от Иванова', () {
      final r = parser.parse(
        _msg('Перевод от Иванова И. 3000р. Карта *7890. Баланс: 18000р.'),
      );
      expect(r.last4, '7890');
      expect(r.amount, 3000);
      expect(r.balance, 18000);
      expect(r.operationType, OperationType.incoming);
    });

    test('Пополнение', () {
      final r = parser.parse(
        _msg('Пополнение 10000р. Счёт *2244. Баланс 55000р.'),
      );
      expect(r.last4, '2244');
      expect(r.amount, 10000);
      expect(r.balance, 55000);
      expect(r.operationType, OperationType.incoming);
    });
  });

  group('Сбербанк 900 — списание / покупка', () {
    test('Формат: Покупка Nр Карта *XXXX', () {
      final r = parser.parse(
        _msg('СБЕРБАНК Покупка 1500р Карта *3456 MAGNIT Баланс: 18500р'),
      );
      expect(r.last4, '3456');
      expect(r.amount, 1500);
      expect(r.balance, 18500);
      expect(r.operationType, OperationType.outgoing);
    });

    test('Оплата услуги', () {
      final r = parser.parse(
        _msg('Оплата 500р. Карта *1234. МОБИЛЬНАЯ СВЯЗЬ. Баланс: 17000р.'),
      );
      expect(r.last4, '1234');
      expect(r.amount, 500);
      expect(r.balance, 17000);
      expect(r.operationType, OperationType.outgoing);
    });

    test('Списание с пробелами в сумме', () {
      final r = parser.parse(
        _msg('Списание 25 000 руб. Карта *5678. Баланс: 75 000 руб.'),
      );
      expect(r.last4, '5678');
      expect(r.amount, 25000);
      expect(r.balance, 75000);
      expect(r.operationType, OperationType.outgoing);
    });

    test('Снятие наличных', () {
      final r = parser.parse(
        _msg('Снятие 3000р. Карта *1234. Баланс: 14000р.'),
      );
      expect(r.last4, '1234');
      expect(r.amount, 3000);
      expect(r.balance, 14000);
      expect(r.operationType, OperationType.outgoing);
    });
  });

  group('Сбербанк 900 — перевод', () {
    test('Перевод выполнен', () {
      final r = parser.parse(
        _msg('Перевод 5000р с карты *1234 выполнен. Баланс: 10000р.'),
      );
      expect(r.last4, '1234');
      expect(r.amount, 5000);
      expect(r.balance, 10000);
      expect(r.operationType, OperationType.transfer);
    });

    test('Переведено на номер', () {
      final r = parser.parse(
        _msg(
          'Переведено 2000р. Карта *9012. Получатель: +79161234567. Баланс: 8000р.',
        ),
      );
      expect(r.last4, '9012');
      expect(r.amount, 2000);
      expect(r.balance, 8000);
      expect(r.operationType, OperationType.transfer);
    });
  });

  // ─── Реальные SMS с устройства ───────────────────────────────────────────

  group('Реальные SMS от 900 — идентификаторы карт Сбера', () {
    test('ECMC4874 — код карты Eurocard/MC', () {
      final r = parser.parse(
        _msg(
          'ECMC4874 10:19 Перевод из Т‑Банк +1000000р от АРТЕМ Д. Баланс: 1008470.48р',
        ),
      );
      expect(r.last4, '4874');
      expect(r.amount, 1000000);
      expect(r.balance, closeTo(1008470.48, 0.01));
      expect(r.operationType, OperationType.incoming);
    });

    test('MIR-8715 — карта Мир через дефис', () {
      final r = parser.parse(
        _msg(
          'MIR-8715 13:33 перевод 49 000р Комиссия 200р C2C PSB M NF Баланс: 14 175.95р',
        ),
      );
      expect(r.last4, '8715');
      expect(r.operationType, OperationType.transfer);
    });

    test('СЧЁТ5085 — счёт без пробела перед цифрами', () {
      final r = parser.parse(
        _msg('СЧЁТ5085 19:17 перевод 3000р Баланс: 5675.95р'),
      );
      expect(r.last4, '5085');
      expect(r.amount, 3000);
      expect(r.balance, closeTo(5675.95, 0.01));
      expect(r.operationType, OperationType.transfer);
    });

    test('Накопит. счет Премьер *5554 — masked account', () {
      final r = parser.parse(
        _msg(
          'Накопит. счет Премьер *5554 12:43 Выдача 1 000 000р Баланс: 3 637 054,61р',
        ),
      );
      expect(r.last4, '5554');
      expect(r.amount, 1000000);
      expect(r.balance, closeTo(3637054.61, 0.01));
      expect(r.operationType, OperationType.outgoing); // Выдача = снятие
    });

    test('ECMC зачисление', () {
      final r = parser.parse(
        _msg('ECMC4874 19:45 зачисление 200р Баланс: 200р'),
      );
      expect(r.last4, '4874');
      expect(r.amount, 200);
      expect(r.balance, 200);
      expect(r.operationType, OperationType.incoming);
    });

    test('ECMC покупка', () {
      final r = parser.parse(
        _msg('ECMC4874 20:54 Покупка 3150р KLEVER_P_QR Баланс: 4410.68р'),
      );
      expect(r.last4, '4874');
      expect(r.amount, 3150);
      expect(r.balance, closeTo(4410.68, 0.01));
      expect(r.operationType, OperationType.outgoing);
    });

    test('ECMC оплата', () {
      final r = parser.parse(
        _msg('ECMC4874 17:17 Оплата 4429.52р Баланс: 770.48р'),
      );
      expect(r.last4, '4874');
      expect(r.amount, closeTo(4429.52, 0.01));
      expect(r.balance, closeTo(770.48, 0.01));
      expect(r.operationType, OperationType.outgoing);
    });

    test('Накопит счёт — перевод на другую карту', () {
      final r = parser.parse(
        _msg(
          'Накопит. счет Премьер *5554 17:16 Перевод 5000р на карту ECMC4874. Баланс счёта: 3 593 948.4р, баланс карты: 5200р',
        ),
      );
      expect(r.last4, '5554');
      expect(r.amount, 5000);
      expect(r.operationType, OperationType.transfer);
    });

    test('MIR покупка СБП', () {
      final r = parser.parse(
        _msg('MIR-8715 19:17 Покупка 360р TABAK_P_QR Баланс: 63 375.95р'),
      );
      expect(r.last4, '8715');
      expect(r.amount, 360);
      expect(r.balance, closeTo(63375.95, 0.01));
      expect(r.operationType, OperationType.outgoing);
    });

    test('Покупка по СБП', () {
      final r = parser.parse(
        _msg(
          'ECMC4874 15:23 Покупка по СБП 239.98р 377H Пятерочка Баланс: 9373.01р',
        ),
      );
      expect(r.last4, '4874');
      expect(r.amount, closeTo(239.98, 0.01));
      expect(r.operationType, OperationType.outgoing);
    });

    test('Зачисление на счёт (ECMC формат со счётом)', () {
      final r = parser.parse(
        _msg(
          'ECMC4874 Зачисление средств 1 008 470.48р на счёт Накопит. счет Премьер *5554. Баланс карты: 0р, баланс счёта: 4 637 054.61р',
        ),
      );
      expect(r.last4, '4874');
      expect(r.operationType, OperationType.incoming);
    });
  });

  group('Реальные SMS — OTP и сервисные (должны игнорироваться)', () {
    test('OTP "Никому не сообщайте код" — isOtp true', () {
      final r = parser.parse(
        _msg(
          'Никому не сообщайте код 7163 Списание 49 000р с MIR-8715 C2C PSB M NF',
        ),
      );
      expect(r.isOtp, isTrue);
    });

    test('OTP для входа в СберОнлайн', () {
      final r = parser.parse(
        _msg(
          'Никому не сообщайте код 63900 для входа в СберБанк Онлайн.\n'
          '@online.sberbank.ru #63900',
        ),
      );
      expect(r.isOtp, isTrue);
    });

    test('Сервисное — начало обслуживания', () {
      final r = parser.parse(
        _msg(
          'Вы начали обслуживание в СберБанке в 12:42 мск. Если вы не обращались в банк, позвоните на 900.',
        ),
      );
      expect(r.isOtp, isFalse);
      expect(r.last4, isNull);
      expect(r.operationType, OperationType.unknown);
    });
  });

  group('Маскировка карты — разные форматы', () {
    test('Одна звёздочка *1234', () {
      final r = parser.parse(
        _msg('Зачисление 1000р. Карта *1234. Баланс 5000р.'),
      );
      expect(r.last4, '1234');
    });

    test('Двойная звёздочка **1234', () {
      final r = parser.parse(
        _msg('Зачисление 1000р. Карта **1234. Баланс 5000р.'),
      );
      expect(r.last4, '1234');
    });

    test('Четыре звёздочки **** 1234', () {
      final r = parser.parse(_msg('Покупка 500р. **** 1234. Баланс 4500р.'));
      expect(r.last4, '1234');
    });

    test('Именованный счёт: счёт 5678', () {
      final r = parser.parse(
        _msg('Зачисление 2000р. Счёт 5678. Баланс 12000р.'),
      );
      expect(r.last4, '5678');
    });
  });

  group('Суммы с разными форматами', () {
    test('Рубли с точкой: 1500.50 руб', () {
      final r = parser.parse(
        _msg('Покупка 1500.50 руб. Карта *1234. Баланс 8499.50 руб.'),
      );
      expect(r.amount, 1500.50);
      expect(r.balance, closeTo(8499.50, 0.01));
    });

    test('Рубли с запятой: 1500,50 руб', () {
      final r = parser.parse(
        _msg('Покупка 1500,50 руб. Карта *1234. Баланс 8000 руб.'),
      );
      expect(r.amount, closeTo(1500.50, 0.01));
    });

    test('RUB формат', () {
      final r = parser.parse(
        _msg('Operation: 3000 RUB. Card *1234. Balance: 12000 RUB.'),
      );
      expect(r.amount, 3000);
      expect(r.balance, 12000);
    });

    test('Очень большая сумма: 1 000 000р', () {
      final r = parser.parse(
        _msg('ECMC4874 Перевод +1 000 000р. Баланс: 2 000 000р.'),
      );
      expect(r.amount, 1000000);
      expect(r.balance, 2000000);
    });

    test('Сумма с дробью и пробелами: 3 637 054,61р', () {
      final r = parser.parse(
        _msg('Счёт *5554 Выдача 1 000 000р Баланс: 3 637 054,61р'),
      );
      expect(r.amount, 1000000);
      expect(r.balance, closeTo(3637054.61, 0.01));
    });
  });

  group('Граничные случаи', () {
    test('Нет карты — last4 null', () {
      final r = parser.parse(_msg('Ваш код подтверждения: 12345'));
      expect(r.last4, isNull);
      expect(r.operationType, OperationType.unknown);
    });

    test('Нет баланса — balance null', () {
      final r = parser.parse(_msg('Перевод 1000р. Карта *1234.'));
      expect(r.last4, '1234');
      expect(r.amount, 1000);
      expect(r.balance, isNull);
    });

    test('Баланс не путается с суммой операции', () {
      final r = parser.parse(
        _msg('СБЕРБАНК Покупка 500р Карта *1234 Баланс: 9500р'),
      );
      expect(r.amount, 500);
      expect(r.balance, 9500);
      expect(r.amount, isNot(equals(r.balance)));
    });
  });

  // ─── Международные банки ────────────────────────────────────────────────

  group('Нигерия — NGN (GTBank, Zenith, UBA, Access, FirstBank)', () {
    test('GTBank — transfer debit NGN prefix', () {
      final r = parser.parse(_msg(
        'Acct: XX8036 Amt: NGN1,000.00 DR Desc: Transfer to 0123456789 GTB Avail Bal: NGN14,200.00',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 1000.0);
      expect(r.balance, 14200.0);
      expect(r.operationType, OperationType.transfer);
    });

    test('Zenith — AlertZ credit', () {
      final r = parser.parse(_msg(
        'Acct:225**8036 Amt:NGN7,500.00 CR Desc:NIP/UBA/CHUKWUEMEKA Avail Bal:NGN19,200.00',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 7500.0);
      expect(r.balance, 19200.0);
      expect(r.operationType, OperationType.incoming);
    });

    test('UBA — debit alert', () {
      final r = parser.parse(_msg(
        'UBA Alert: Debit NGN2,750.00 on Acct XX8036. Desc: POS NNPC. Bal: NGN9,450.00',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 2750.0);
      expect(r.balance, 9450.0);
      expect(r.operationType, OperationType.outgoing);
    });

    test('Access — incoming credit', () {
      final r = parser.parse(_msg(
        'AccessAlert: Credit NGN20,000.00 to Acct XX8036. Avail Bal: NGN35,500.00',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 20000.0);
      expect(r.balance, 35500.0);
      expect(r.operationType, OperationType.incoming);
    });
  });

  group('Индия — INR (SBI)', () {
    test('SBI — IMPS credit', () {
      final r = parser.parse(_msg(
        'INR 5,000 credited to A/C XX8036 via IMPS. Avl Bal INR 20,200.',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 5000.0);
      expect(r.balance, 20200.0);
      expect(r.operationType, OperationType.incoming);
    });

    test('SBI — POS debit', () {
      final r = parser.parse(_msg(
        'Acct XX8036 debited by INR 1,499. Avl Bal INR 18,701.',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 1499.0);
      expect(r.balance, 18701.0);
      expect(r.operationType, OperationType.outgoing);
    });
  });

  group('Пакистан — PKR (UBL)', () {
    test('UBL — IBFT credit', () {
      final r = parser.parse(_msg(
        'UBL: PKR 10,000.00 credited to Acct XX8036. Desc: IBFT from HBL. Avl Bal PKR 45,000.00',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 10000.0);
      expect(r.balance, 45000.0);
      expect(r.operationType, OperationType.incoming);
    });

    test('UBL — transfer debit', () {
      final r = parser.parse(_msg(
        'UBL: PKR 5,000.00 debited from Acct XX8036. Desc: Transfer to 03001234567. Avl Bal PKR 40,000.00',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 5000.0);
      expect(r.balance, 40000.0);
      expect(r.operationType, OperationType.outgoing);
    });
  });

  group('Бангладеш — Tk/BDT (bKash)', () {
    test('bKash — send money', () {
      final r = parser.parse(_msg(
        'bKash: You have sent Tk 500.00 to 01712345678. Fee Tk 5.00. Balance Tk 1,495.00. TrxID AA12345',
      ));
      expect(r.amount, 500.0);
      expect(r.balance, 1495.0);
      expect(r.operationType, OperationType.outgoing);
    });

    test('bKash — receive money', () {
      final r = parser.parse(_msg(
        'bKash: You have received Tk 1,000.00 from 01811223344. Balance Tk 2,495.00. TrxID BB67890',
      ));
      expect(r.amount, 1000.0);
      expect(r.balance, 2495.0);
      expect(r.operationType, OperationType.incoming);
    });
  });

  group('Индонезия — IDR/Rp (Bank Mandiri)', () {
    test('Mandiri — transfer debit', () {
      final r = parser.parse(_msg(
        'BANKMANDIRI: Rek.XX8036 tgl 14/03/26 09:30 Debet Rp1.000.000 Ket:Transfer ke 1234567890. Saldo Rp8.500.000',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 1000000.0);
      expect(r.balance, 8500000.0);
      expect(r.operationType, OperationType.outgoing);
    });

    test('Mandiri — kredit incoming', () {
      final r = parser.parse(_msg(
        'BANKMANDIRI: Rek.XX8036 tgl 14/03/26 14:45 Kredit Rp2.000.000 Ket:Transfer dari BUDI. Saldo Rp10.500.000',
      ));
      expect(r.last4, '8036');
      expect(r.amount, 2000000.0);
      expect(r.balance, 10500000.0);
      expect(r.operationType, OperationType.incoming);
    });
  });

  group('Филиппины — PHP (GCash)', () {
    test('GCash — send money', () {
      final r = parser.parse(_msg(
        'You have sent PHP 500.00 GCASH to Juan 09171234567. Your new balance is PHP 2,550.00.',
      ));
      expect(r.amount, 500.0);
      expect(r.balance, 2550.0);
      expect(r.operationType, OperationType.outgoing);
    });

    test('GCash — receive money', () {
      final r = parser.parse(_msg(
        'You have received PHP 1,000.00 GCASH from Maria 09185556789. Your new balance is PHP 3,550.00.',
      ));
      expect(r.amount, 1000.0);
      expect(r.balance, 3550.0);
      expect(r.operationType, OperationType.incoming);
    });
  });

  group('Армения — AMD (VivaCell MobiDram)', () {
    test('MobiDram — transfer debit (Armenian)', () {
      final r = parser.parse(_msg(
        'MobiDram: Կատարվել է փոխանցում 5,000 AMD գումարով՝ 093123456 բաժանորդին։ Ձեր մնացորդը՝ 47,800 AMD',
      ));
      expect(r.amount, 5000.0);
      expect(r.balance, 47800.0);
      expect(r.operationType, OperationType.outgoing);
    });

    test('MobiDram — incoming credit (Armenian)', () {
      final r = parser.parse(_msg(
        'MobiDram: Դուք ստացել եք 10,000 AMD 077456789 բաժանորդից։ Ձեր մնացորդը՝ 52,800 AMD',
      ));
      expect(r.amount, 10000.0);
      expect(r.balance, 52800.0);
      expect(r.operationType, OperationType.incoming);
    });

    test('MobiDram — transfer debit (Russian)', () {
      final r = parser.parse(_msg(
        'MobiDram: Перевод 5,000 AMD на номер 093123456 выполнен. Ваш баланс: 47,800 AMD.',
      ));
      expect(r.amount, 5000.0);
      expect(r.balance, 47800.0);
      expect(r.operationType, OperationType.transfer);
    });
  });
}
