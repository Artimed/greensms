import '../../../../core/database/app_database.dart';
import '../../domain/entities/app_settings.dart';
import 'package:sqflite/sqflite.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(this._database);

  final AppDatabase _database;

  Future<AppSettings> load() async {
    final db = await _database.database;
    final rows = await db.query('settings', where: 'id = 1', limit: 1);
    if (rows.isEmpty) {
      return const AppSettings(
        smsLimit: 10,
        pinEnabled: false,
        themeMode: 'system',
        localeCode: 'en',
        onboardingDone: false,
        devicePhone: '',
        directSmsEnabled: false,
        directSmsConfigured: false,
        selectedCountryCode: null,
        selectedBankId: null,
        dailyLimit: 0,
      );
    }
    final base = AppSettings.fromDbMap(rows.first);
    final limitScopeKey = _scopeKeyFor(
      selectedCountryCode: base.selectedCountryCode,
      selectedBankId: base.selectedBankId,
    );
    final countryScopeKey = _countryScopeKeyFor(base.selectedCountryCode);
    final scopedLimit = await _loadScopedDailyLimit(
      db: db,
      scopeKey: limitScopeKey,
      defaultValue: 0,
    );
    final scopedPhone = await _loadScopedPhone(
      db: db,
      scopeKey: countryScopeKey,
      defaultValue: base.devicePhone,
    );
    return base.copyWith(dailyLimit: scopedLimit, devicePhone: scopedPhone);
  }

  Future<void> updateOnboardingDone(bool value) async {
    final db = await _database.database;
    await db.update('settings', {
      'onboarding_done': value ? 1 : 0,
    }, where: 'id = 1');
  }

  Future<void> updateDevicePhone(String phone) async {
    final db = await _database.database;
    await db.update('settings', {'device_phone': phone}, where: 'id = 1');
    final countryScopeKey = await _loadCurrentCountryScopeKey(db);
    await db.insert('device_phones', {
      'scope_key': countryScopeKey,
      'phone': phone,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateDirectSmsEnabled(bool value) async {
    final db = await _database.database;
    await db.update('settings', {
      'direct_sms_enabled': value ? 1 : 0,
    }, where: 'id = 1');
  }

  Future<void> updateDirectSmsConfigured(bool value) async {
    final db = await _database.database;
    await db.update('settings', {
      'direct_sms_configured': value ? 1 : 0,
    }, where: 'id = 1');
  }

  Future<void> updateSelectedCountryCode(String? countryCode) async {
    final db = await _database.database;
    await db.update('settings', {
      'selected_country_code': (countryCode ?? '').trim(),
    }, where: 'id = 1');
  }

  Future<void> updateSelectedBankId(String? bankId) async {
    final db = await _database.database;
    await db.update('settings', {
      'selected_bank_id': (bankId ?? '').trim(),
    }, where: 'id = 1');
  }

  Future<void> updateDailyLimit(double? limit) async {
    final db = await _database.database;
    final scopeKey = await _loadCurrentScopeKey(db);
    final normalizedLimit = (limit == null || limit < 0) ? 0.0 : limit;
    await db.insert('bank_limits', {
      'scope_key': scopeKey,
      'daily_limit': normalizedLimit,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Keep legacy column in sync with currently active scope.
    await db.update('settings', {
      'daily_limit': normalizedLimit,
    }, where: 'id = 1');
  }

  Future<void> updateThemeMode(String mode) async {
    final db = await _database.database;
    await db.update('settings', {'theme_mode': mode}, where: 'id = 1');
  }

  Future<void> updateLocaleCode(String code) async {
    final db = await _database.database;
    await db.update('settings', {'locale_code': code}, where: 'id = 1');
  }

  Future<String> _loadCurrentScopeKey(Database db) async {
    final rows = await db.query('settings', where: 'id = 1', limit: 1);
    if (rows.isEmpty) return _scopeKeyFor();
    return _scopeKeyFor(
      selectedCountryCode: _nullIfEmpty(rows.first['selected_country_code']),
      selectedBankId: _nullIfEmpty(rows.first['selected_bank_id']),
    );
  }

  Future<String> _loadCurrentCountryScopeKey(Database db) async {
    final rows = await db.query('settings', where: 'id = 1', limit: 1);
    if (rows.isEmpty) return _countryScopeKeyFor(null);
    return _countryScopeKeyFor(
      _nullIfEmpty(rows.first['selected_country_code']),
    );
  }

  Future<String> _loadScopedPhone({
    required Database db,
    required String scopeKey,
    required String defaultValue,
  }) async {
    final rows = await db.query(
      'device_phones',
      columns: ['phone'],
      where: 'scope_key = ?',
      whereArgs: [scopeKey],
      limit: 1,
    );
    if (rows.isEmpty) return defaultValue;
    return (rows.first['phone'] as String?) ?? defaultValue;
  }

  Future<double> _loadScopedDailyLimit({
    required Database db,
    required String scopeKey,
    required double defaultValue,
  }) async {
    final rows = await db.query(
      'bank_limits',
      columns: ['daily_limit'],
      where: 'scope_key = ?',
      whereArgs: [scopeKey],
      limit: 1,
    );
    if (rows.isEmpty) return defaultValue;
    return (rows.first['daily_limit'] as num?)?.toDouble() ?? defaultValue;
  }

  String _scopeKeyFor({String? selectedCountryCode, String? selectedBankId}) {
    final bank = (selectedBankId ?? '').trim();
    if (bank.isNotEmpty) return 'bank:$bank';

    final country = (selectedCountryCode ?? '').trim().toUpperCase();
    if (country.isNotEmpty) return 'country:$country';

    return 'country:RU';
  }

  String _countryScopeKeyFor(String? selectedCountryCode) {
    final country = (selectedCountryCode ?? '').trim().toUpperCase();
    if (country.isNotEmpty) return 'country:$country';
    return 'country:RU';
  }

  String? _nullIfEmpty(Object? value) {
    final raw = (value as String?)?.trim();
    if (raw == null || raw.isEmpty) return null;
    return raw;
  }
}
