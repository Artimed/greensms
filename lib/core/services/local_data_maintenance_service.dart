import '../database/app_database.dart';

class LocalDataMaintenanceService {
  LocalDataMaintenanceService(this._database);

  final AppDatabase _database;

  Future<void> clearSmsAndAccountsForCountry(String countryCode) async {
    final normalized = countryCode.trim().toUpperCase();
    if (normalized.isEmpty) return;
    final db = await _database.database;
    await db.transaction((txn) async {
      await txn.delete(
        'sms_raw',
        where: 'country_code = ?',
        whereArgs: [normalized],
      );
      await txn.delete(
        'accounts_view',
        where: 'country_code = ?',
        whereArgs: [normalized],
      );
    });
  }

  Future<void> clearAll() async {
    final db = await _database.database;
    await db.transaction((txn) async {
      await txn.delete('sms_raw');
      await txn.delete('accounts_view');
      await txn.delete('qr_profiles');
      await txn.delete('qr_history');
    });
  }
}
