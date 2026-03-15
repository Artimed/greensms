import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static const String _dbName = 'zelenaya_sms.db';
  static const int _dbVersion = 13;
  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _openDatabase();
    return _database!;
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  Future<void> drop() async {
    final dbPath = await getDatabasesPath();
    final fullPath = p.join(dbPath, _dbName);
    await close();
    await deleteDatabase(fullPath);
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final fullPath = p.join(dbPath, _dbName);

    return openDatabase(
      fullPath,
      version: _dbVersion,
      onCreate: (db, _) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE settings ADD COLUMN onboarding_done INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE settings ADD COLUMN device_phone TEXT NOT NULL DEFAULT \'\'',
          );
        }
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE settings ADD COLUMN daily_limit REAL');
        }
        if (oldVersion < 5) {
          await db.execute(
            'ALTER TABLE sms_raw ADD COLUMN is_otp INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 6) {
          await db.execute(
            'ALTER TABLE settings ADD COLUMN locale_code TEXT NOT NULL DEFAULT \'en\'',
          );
        }
        if (oldVersion < 7) {
          await db.execute(
            'ALTER TABLE settings ADD COLUMN direct_sms_enabled INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 8) {
          await db.execute(
            'ALTER TABLE settings ADD COLUMN direct_sms_configured INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 9) {
          await db.execute(
            'ALTER TABLE settings ADD COLUMN selected_country_code TEXT NOT NULL DEFAULT \'\'',
          );
          await db.execute(
            'ALTER TABLE settings ADD COLUMN selected_bank_id TEXT NOT NULL DEFAULT \'\'',
          );
        }
        if (oldVersion < 10) {
          const defaultCountry = 'RU';

          await db.execute(
            'ALTER TABLE sms_raw ADD COLUMN country_code TEXT NOT NULL DEFAULT \'\'',
          );
          await db.execute(
            'UPDATE sms_raw SET country_code = ? WHERE country_code = \'\'',
            [defaultCountry],
          );
          await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_sms_raw_country_date ON sms_raw(country_code, date_time DESC)',
          );

          await db.execute(
            'ALTER TABLE accounts_view RENAME TO accounts_view_old',
          );
          await db.execute('''
            CREATE TABLE accounts_view (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              country_code TEXT NOT NULL,
              last4 TEXT NOT NULL,
              sender TEXT,
              last_balance REAL,
              last_amount REAL,
              last_operation_type TEXT NOT NULL,
              updated_at INTEGER NOT NULL,
              UNIQUE(country_code, last4)
            )
          ''');
          await db.execute(
            '''
            INSERT INTO accounts_view (
              country_code, last4, sender, last_balance, last_amount,
              last_operation_type, updated_at
            )
            SELECT ?, last4, sender, last_balance, last_amount,
              last_operation_type, updated_at
            FROM accounts_view_old
            ''',
            [defaultCountry],
          );
          await db.execute('DROP TABLE accounts_view_old');
          await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_accounts_country_updated ON accounts_view(country_code, updated_at DESC)',
          );

          await db.execute(
            'ALTER TABLE qr_history ADD COLUMN country_code TEXT NOT NULL DEFAULT \'\'',
          );
          await db.execute(
            'UPDATE qr_history SET country_code = ? WHERE country_code = \'\'',
            [defaultCountry],
          );
          await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_qr_history_country_created ON qr_history(country_code, created_at DESC)',
          );
        }
        if (oldVersion < 11) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS bank_limits (
              scope_key TEXT PRIMARY KEY,
              daily_limit REAL NOT NULL DEFAULT 0
            )
          ''');
        }
        if (oldVersion < 12) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS device_phones (
              scope_key TEXT PRIMARY KEY,
              phone TEXT NOT NULL DEFAULT ''
            )
          ''');
        }
        if (oldVersion < 13) {
          await db.execute(
            'ALTER TABLE sms_raw ADD COLUMN reference TEXT',
          );
        }
      },
    );
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE sms_raw (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        country_code TEXT NOT NULL,
        sender TEXT NOT NULL,
        body TEXT NOT NULL,
        date_time INTEGER NOT NULL,
        parsed INTEGER NOT NULL,
        last4 TEXT,
        amount REAL,
        balance REAL,
        reference TEXT,
        operation_type TEXT NOT NULL,
        is_otp INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_sms_raw_date ON sms_raw(date_time DESC)',
    );
    await db.execute(
      'CREATE INDEX idx_sms_raw_country_date ON sms_raw(country_code, date_time DESC)',
    );

    await db.execute('''
      CREATE TABLE accounts_view (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        country_code TEXT NOT NULL,
        last4 TEXT NOT NULL,
        sender TEXT,
        last_balance REAL,
        last_amount REAL,
        last_operation_type TEXT NOT NULL,
        updated_at INTEGER NOT NULL,
        UNIQUE(country_code, last4)
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_accounts_country_updated ON accounts_view(country_code, updated_at DESC)',
    );

    await db.execute('''
      CREATE TABLE qr_profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        note_template TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE qr_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        country_code TEXT NOT NULL,
        phone TEXT NOT NULL,
        amount REAL,
        note TEXT,
        profile_name TEXT,
        created_at INTEGER NOT NULL,
        direction TEXT NOT NULL
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_qr_history_country_created ON qr_history(country_code, created_at DESC)',
    );

    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY CHECK(id = 1),
        sms_limit INTEGER NOT NULL DEFAULT 10,
        pin_enabled INTEGER NOT NULL DEFAULT 0,
        theme_mode TEXT NOT NULL DEFAULT 'system',
        locale_code TEXT NOT NULL DEFAULT 'en',
        onboarding_done INTEGER NOT NULL DEFAULT 0,
        device_phone TEXT NOT NULL DEFAULT '',
        direct_sms_enabled INTEGER NOT NULL DEFAULT 0,
        direct_sms_configured INTEGER NOT NULL DEFAULT 0,
        selected_country_code TEXT NOT NULL DEFAULT '',
        selected_bank_id TEXT NOT NULL DEFAULT '',
        daily_limit REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE bank_limits (
        scope_key TEXT PRIMARY KEY,
        daily_limit REAL NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE device_phones (
        scope_key TEXT PRIMARY KEY,
        phone TEXT NOT NULL DEFAULT ''
      )
    ''');

    await db.insert('settings', {
      'id': 1,
      'sms_limit': 10,
      'pin_enabled': 0,
      'theme_mode': 'system',
      'locale_code': 'en',
      'onboarding_done': 0,
      'device_phone': '',
      'direct_sms_enabled': 0,
      'direct_sms_configured': 0,
      'selected_country_code': '',
      'selected_bank_id': '',
    });
  }
}
