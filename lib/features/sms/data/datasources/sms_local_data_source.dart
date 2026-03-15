import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/account_summary.dart';
import '../../domain/entities/operation_type.dart';
import '../../domain/entities/sms_message.dart';

class SmsLocalDataSource {
  SmsLocalDataSource(this._database);

  final AppDatabase _database;

  Future<void> replaceRaw(
    List<SmsMessage> messages, {
    required String countryCode,
  }) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final db = await _database.database;
    await db.transaction((txn) async {
      await txn.delete(
        'sms_raw',
        where: 'country_code = ?',
        whereArgs: [normalizedCountry],
      );
      for (final message in messages) {
        final payload = message.toDbMap()
          ..remove('id')
          ..['country_code'] = normalizedCountry;
        await txn.insert('sms_raw', payload);
      }
    });
  }

  Future<void> saveIncoming(
    SmsMessage message, {
    required int limit,
    required String countryCode,
  }) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final db = await _database.database;
    await db.insert(
      'sms_raw',
      message.toDbMap()
        ..remove('id')
        ..['country_code'] = normalizedCountry,
    );

    final overflowRows = await db.rawQuery(
      '''
      SELECT id FROM sms_raw
      WHERE country_code = ?
      ORDER BY date_time DESC
      LIMIT -1 OFFSET ?
      ''',
      [normalizedCountry, limit],
    );

    if (overflowRows.isEmpty) {
      return;
    }

    final ids = overflowRows.map((row) => row['id']).join(',');
    await db.delete('sms_raw', where: 'id IN ($ids)');
  }

  Future<List<SmsMessage>> loadStored({
    required int limit,
    required String countryCode,
  }) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final db = await _database.database;
    final rows = await db.query(
      'sms_raw',
      where: 'country_code = ?',
      whereArgs: [normalizedCountry],
      orderBy: 'date_time DESC',
      limit: limit,
    );
    return rows.map(SmsMessage.fromDbMap).toList();
  }

  Future<void> rebuildAccounts({required String countryCode}) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final db = await _database.database;
    final rows = await db.query(
      'sms_raw',
      where: 'country_code = ?',
      whereArgs: [normalizedCountry],
      orderBy: 'date_time DESC',
    );

    final byLast4 = <String, AccountSummary>{};

    for (final row in rows) {
      final sms = SmsMessage.fromDbMap(row);
      final last4 = sms.last4;
      if (last4 == null || last4.isEmpty) {
        continue;
      }

      final existing = byLast4[last4];
      if (existing == null) {
        byLast4[last4] = AccountSummary(
          last4: last4,
          sender: sms.sender,
          lastBalance: sms.balance,
          lastAmount: sms.amount,
          lastOperationType: sms.operationType,
          updatedAt: sms.dateTime,
        );
        continue;
      }

      if (existing.lastBalance == null && sms.balance != null) {
        byLast4[last4] = existing.copyWith(lastBalance: sms.balance);
      }
    }

    await db.transaction((txn) async {
      await txn.delete(
        'accounts_view',
        where: 'country_code = ?',
        whereArgs: [normalizedCountry],
      );
      for (final account in byLast4.values) {
        await txn.insert(
          'accounts_view',
          account.toDbMap()
            ..remove('id')
            ..['country_code'] = normalizedCountry,
        );
      }
    });
  }

  Future<void> upsertAccount(
    SmsMessage message, {
    required String countryCode,
  }) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final db = await _database.database;
    final last4 = message.last4;
    if (last4 == null || last4.isEmpty) {
      return;
    }

    final existingRows = await db.query(
      'accounts_view',
      where: 'last4 = ? AND country_code = ?',
      whereArgs: [last4, normalizedCountry],
      limit: 1,
    );

    final existing = existingRows.isEmpty
        ? null
        : AccountSummary.fromDbMap(existingRows.first);

    final next = AccountSummary(
      id: existing?.id,
      last4: last4,
      sender: message.sender,
      lastBalance: message.balance ?? existing?.lastBalance,
      lastAmount: message.amount ?? existing?.lastAmount,
      lastOperationType: message.operationType == OperationType.unknown
          ? (existing?.lastOperationType ?? OperationType.unknown)
          : message.operationType,
      updatedAt: message.dateTime,
    );

    await db.insert(
      'accounts_view',
      next.toDbMap()
        ..remove('id')
        ..['country_code'] = normalizedCountry,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AccountSummary>> loadAccounts({
    required String countryCode,
  }) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final db = await _database.database;
    final rows = await db.query(
      'accounts_view',
      where: 'country_code = ?',
      whereArgs: [normalizedCountry],
      orderBy: 'updated_at DESC',
    );
    return rows.map(AccountSummary.fromDbMap).toList();
  }
}
