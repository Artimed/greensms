import '../../../../core/database/app_database.dart';
import '../../domain/entities/qr_history_direction.dart';

class QrLocalDataSource {
  QrLocalDataSource(this._database);

  final AppDatabase _database;

  Future<List<String>> loadRecentRecipients({
    required String countryCode,
    int limit = 5,
  }) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final db = await _database.database;
    final rows = await db.rawQuery(
      '''
      SELECT phone
      FROM qr_history
      WHERE country_code = ?
        AND direction != ?
        AND phone IS NOT NULL
        AND phone != ''
      GROUP BY phone
      ORDER BY MAX(created_at) DESC
      LIMIT ?
      ''',
      [normalizedCountry, QrHistoryDirection.cancelled, limit],
    );
    return rows.map((row) => row['phone'] as String).toList();
  }

  Future<void> addHistory({
    required String phone,
    required String direction,
    required String countryCode,
    double? amount,
    String? note,
    String? profileName,
  }) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final db = await _database.database;
    await db.insert('qr_history', {
      'country_code': normalizedCountry,
      'phone': phone,
      'amount': amount,
      'note': note,
      'profile_name': profileName,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'direction': direction,
    });
  }

  /// Сумма переводов, подтвержденных пользователем как отправленные сегодня.
  Future<double> loadTodayUsedAmount({required String countryCode}) async {
    final normalizedCountry = countryCode.trim().toUpperCase();
    final db = await _database.database;
    final now = DateTime.now();
    final dayStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch;
    final dayEnd = DateTime(
      now.year,
      now.month,
      now.day + 1,
    ).millisecondsSinceEpoch;

    final rows = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(amount), 0) AS total
      FROM qr_history
      WHERE country_code = ?
        AND direction = ?
        AND amount IS NOT NULL
        AND created_at >= ?
        AND created_at < ?
      ''',
      [normalizedCountry, QrHistoryDirection.sent, dayStart, dayEnd],
    );

    return (rows.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<void> clearData() async {
    final db = await _database.database;
    await db.delete('qr_profiles');
    await db.delete('qr_history');
  }
}
