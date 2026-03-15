# GreenSMS Pro — Architecture

> Status: `ACTIVE`
> Scope: архитектура Pro-слоя: flavors, лицензия, пересылка, OTA парсер, FCM
> Updated: `2026-03-15`

---

## 1. Два APK — один репозиторий

### Package names
| Flavor | Package | Интернет | Парсер |
|--------|---------|----------|--------|
| `free` | `com.greensms.free` | ❌ | Bundled assets |
| `pro`  | `com.greensms.pro`  | ✅ | OTA с Supabase |

Разные `packageName` → разные приложения на устройстве, данные не пересекаются. Free и Pro — разные продукты для разной аудитории.

### Структура репо
```
lib/
├── main_free.dart          ← точка входа Free
├── main_pro.dart           ← точка входа Pro
├── core/                   ← общий код (парсер, QR, SMS, DB, банки)
└── features/
    ├── home/               ← общий
    ├── qr/                 ← общий
    ├── sms/                ← общий
    ├── settings/           ← общий
    ├── forwarding/         ← только Pro
    ├── pro_license/        ← только Pro
    └── push/               ← только Pro

android/app/src/
├── free/AndroidManifest.xml   ← READ_SMS, RECEIVE_SMS, CAMERA, SEND_SMS
└── pro/AndroidManifest.xml    ← + INTERNET, + RECEIVE_BOOT_COMPLETED
```

### Сборка
```bash
flutter build apk --flavor free -t lib/main_free.dart
flutter build apk --flavor pro  -t lib/main_pro.dart
```

### DI разделение (единственная точка различия)
```dart
// main_free.dart
void main() {
  setupCoreDependencies();
  // ParserProfileSource → BundledParserProfileSource
  runApp(const App());
}

// main_pro.dart
void main() {
  setupCoreDependencies();
  setupProDependencies();
  // ParserProfileSource → OtaParserProfileSource (Supabase + fallback bundled)
  // LicenseService, ForwardingService, FcmService
  runApp(const App());
}
```

---

## 2. Лицензия

### Модель
- **Ежемесячная подписка** — ключ действует 30 дней.
- Хранится на Supabase: `{license_key, device_id, expires_at, status}`.
- Валидация: при активации + тихая проверка раз в день (при наличии интернета).
- Офлайн-grace: если устройство без интернета — используется кешированный статус до 7 дней после истечения.

### Flow активации
```
Установил Pro APK
  → generateInstallationId() → UUID → flutter_secure_storage
  → Экран License: "Введи ключ"
  → POST /api/activate  { key, device_id }
  → Supabase проверяет ключ → возвращает { valid: true, expires_at }
  → Сохранить локально expires_at
  → Pro-фичи разблокированы
```

### Экран Pro
- Статус: Free / Pro (+ дата истечения)
- Copy installationId
- Ввод / смена ключа
- Кнопка "Купить Pro" → ссылка на сайт

---

## 3. Пересылка SMS (Forwarding)

### Модель (Вариант C: watchlist + 2 канала)
```
Watchlist банков → обновляется через FCM с сервера
  Пример: [sberbank_ru, gtbank_ng, firstbank_ng]

Канал 1 — URL (webhook):
  Пользователь вводит свой endpoint
  Вкл/выкл переключателем

Канал 2 — SMS на номер:
  Пользователь вводит номер телефона
  Вкл/выкл переключателем
```

### Trigger
При получении нового SMS:
1. Парсер разбирает SMS.
2. Проверяем `parsed.bank` против `watchlist`.
3. Если совпало И хотя бы один канал включен → пересылаем.

### Payload (для webhook URL)
```json
{
  "license": "XXXXX-XXXXX-XXXXX",
  "device_id": "uuid",
  "timestamp": "2026-03-15T10:00:00Z",
  "original": "Сбербанк: Перевод 1000р. Баланс: 5000р.",
  "parsed": {
    "bank": "sberbank_ru",
    "amount": 1000.0,
    "balance": 5000.0,
    "operation_type": "incoming",
    "last4": "1234",
    "reference": null
  }
}
```

### Payload (для SMS на номер)
```
[greensms] sberbank_ru +1000.0 bal:5000.0 | Сбербанк: Перевод 1000р...
```
(укороченный формат — влезает в одну SMS)

### Надёжность доставки
- HTTP webhook: `WorkManager` с `ExponentialBackoff`, до 5 попыток, `NetworkType.CONNECTED`.
- SMS: `SmsManager.sendMultipartTextMessage` + dedupe key в SharedPreferences.
- История пересылок: хранится в SQLite (`forwarding_log` таблица).

---

## 4. FCM Push (данные, не уведомления)

### Типы data-сообщений
```json
{ "type": "bank_watchlist_update", "version": 7,
  "banks": ["sberbank_ru", "gtbank_ng", "firstbank_ng"] }

{ "type": "parser_update", "version": 12,
  "url": "https://cdn.supabase.../sms_parser_profiles_v12.json" }
```

### GreenSmsFcmService (Kotlin)
```kotlin
class GreenSmsFcmService : FirebaseMessagingService() {
    override fun onMessageReceived(message: RemoteMessage) {
        when (message.data["type"]) {
            "bank_watchlist_update" -> saveBanksToPrefs(message.data["banks"])
            "parser_update"        -> scheduleParserDownload(message.data["url"])
        }
    }
    override fun onNewToken(token: String) {
        // POST /api/fcm-token { device_id, token }
    }
}
```

- Только data messages (silent) — без всплывающих уведомлений.
- Никакого Firebase Auth, никакого Firestore — только FCM.

---

## 5. OTA Парсер

### Принцип
```dart
abstract class ParserProfileSource {
  Future<List<SmsParserProfile>> load();
}

// Free: всегда из assets/data/sms_banks.json
class BundledParserProfileSource implements ParserProfileSource { ... }

// Pro: сначала кеш (SQLite/файл), затем assets как fallback
class OtaParserProfileSource implements ParserProfileSource {
  Future<List<SmsParserProfile>> load() async {
    final cached = await _loadCached();        // версия с сервера
    if (cached != null) return cached;
    return await _loadBundled();               // fallback
  }
}
```

### Версионирование
- Сервер хранит `sms_parser_profiles_v{N}.json` в Supabase Storage.
- FCM `parser_update` пушит URL на устройство.
- Устройство скачивает, валидирует JSON, сохраняет локально с номером версии.
- Rollback: если новый файл невалиден → остаётся предыдущая версия.

---

## 6. Supabase — минимальная схема

```sql
-- Лицензии
licenses (
  key          TEXT PRIMARY KEY,   -- ключ пользователя
  device_id    TEXT,               -- installationId
  expires_at   TIMESTAMPTZ,
  status       TEXT                -- active / expired / revoked
)

-- FCM токены устройств
device_tokens (
  device_id    TEXT PRIMARY KEY,
  fcm_token    TEXT,
  updated_at   TIMESTAMPTZ
)

-- Версии парсера (CDN в Supabase Storage)
parser_versions (
  version      INT PRIMARY KEY,
  url          TEXT,
  released_at  TIMESTAMPTZ
)
```

### API endpoints (Supabase Edge Functions или внешний Node.js)
```
POST /api/activate      { key, device_id }   → { valid, expires_at }
POST /api/fcm-token     { device_id, token } → 200
GET  /api/parser/latest                      → { version, url }
```

---

## 7. Что Free НИКОГДА не получает
- INTERNET permission
- Парсер OTA
- Экран Forwarding
- Экран License
- FCM сервис
- Supabase запросы

Free остаётся полностью офлайн. Код Pro-фич не компилируется в Free APK.
