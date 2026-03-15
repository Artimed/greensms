# Master Development Process & Waves

> Status: `ACTIVE`
> Role: `single coordination source`
> Scope: синхронизация кода, требований и этапов разработки
> Updated: `2026-03-15`

## 1. Purpose
Этот документ фиксирует:
- текущее фактическое состояние продукта;
- соответствие между `ACTIVE` документами и кодом;
- решения по найденным противоречиям;
- волны разработки (что делаем дальше и в каком порядке).

## 2. Baseline Snapshot (2026-03-14)
- Build gate: `flutter analyze` passed.
- Test gate: `flutter test` passed.
- Runtime gate: device smoke run на `V2231` завершен, `SMK-001..SMK-012` в `Pass`.
- Delta gate: после добавления `SEND_SMS` (opt-in direct mode) нужен отдельный smoke по сценариям on/off и отказу в разрешении.

## 3. Code-to-Docs Alignment Matrix
| Area | Source Docs | Code Evidence | Status | Decision |
|---|---|---|---|---|
| Локальная модель без облака/логина | `zelenaya_sms_tz_v1.md`, `active_constraints_mvp.md` | `lib/app/app.dart`, `lib/core/database/app_database.dart` | ALIGNED | Оставить как жесткий MVP-constraint. |
| Архитектура Flutter + Kotlin bridge | `active_constraints_mvp.md` | `android/.../MainActivity.kt`, `android/.../sms/SmsBridge.kt`, `android/.../sms/SmsReceiver.kt` | ALIGNED | Без изменений. |
| Хранилище SQLite | `active_constraints_mvp.md` | `lib/core/database/app_database.dart` | ALIGNED | Без изменений. |
| Одностраничный UX + QR-hub | `design_v2_single_page.md` | `lib/app/app.dart`, `lib/features/home/presentation/home_page.dart`, `lib/features/qr/presentation/qr_hub_page.dart` | ALIGNED | Без изменений. |
| Settings scope | `design_v2_single_page.md` | `lib/features/settings/presentation/settings_page.dart` | ALIGNED (resolved) | Зафиксирован фактический MVP+ scope: телефон + лимит + язык + тема + permissions + обслуживание данных. |
| QR internal payload | `active_constraints_mvp.md` | `lib/features/qr/domain/entities/qr_payload.dart` | ALIGNED (updated) | Формат `v3` с HMAC-SHA256, backward compatibility `v2`, поддержка `sourceLast4`. |
| QR error handling на устройстве | `tasks.md`, runtime fixes | `lib/features/qr/presentation/qr_hub_page.dart`, `lib/features/qr/presentation/qr_scanner_page.dart` | ALIGNED | Ошибки scanner-потока показываются в UI, процесс не должен падать; для Sber-команды `900` сумма обязательна. |
| Direct SMS mode (`SEND_SMS`) | `active_constraints_mvp.md`, `design_v2_single_page.md` | `lib/features/settings/presentation/settings_page.dart`, `lib/app/app_controller.dart`, `android/.../MainActivity.kt` | ALIGNED (QA pending) | Режим только opt-in из настроек; при сбое прямой отправки используется fallback в системный composer. |
| Учет дневного лимита по QR | `tasks.md`, `active_constraints_mvp.md` | `lib/features/qr/presentation/qr_hub_page.dart`, `lib/features/qr/data/datasources/qr_local_data_source.dart` | ALIGNED | Используются статусы `prepared/sent/cancelled`; в лимит попадает только `sent`. |
| Мультиязычность (EN/RU/HI/KK/UZ/FIL/ID/VI/HY/UR/BN + legacy TL) | `tasks.md` | `lib/l10n/app_*.arb`, `lib/features/settings/presentation/settings_page.dart` | ALIGNED | Языки отображаются самоназванием + флагом; `fil` включен, `tl` сохранен как legacy alias. |
| Лимиты/правила экран (dark mode) | `design_v2_single_page.md`, runtime fixes | `lib/features/sms/presentation/transfer_limits_page.dart` | ALIGNED | Исправлен контраст подсказочного баннера в dark theme. |
| Интеграционные device-smoke сценарии | `tasks.md`, `device_smoke_checklist.md` | process + checklist protocol | ALIGNED | Протокол заполнен на устройстве `V2231`, все `SMK-001..SMK-012` закрыты. |
| Bank / Locale / Command services | `greensms_banks_locales_architecture.md`, `sms_banks.json` | `lib/core/services/bank/` (BankRegistryService, CommandBuilderService); `assets/data/sms_banks.json`; `test/bank_registry_service_test.dart`; `test/command_builder_service_test.dart` | ALIGNED (W2-001..W2-005, tests) | Locale auto-detect → primary bank → SMS/USSD + user override `country→bank` from settings. PIN-based USSD (Vodafone GH) — pending by design. |
| SMS parser layer | `sms_parser_architecture.md`, `sms_banks.json` | `lib/features/sms/data/parsing/`; `test/widget_test.dart`; `test/sms_parser_profile_detector_test.dart`; `test/sms_profile_parsing_test.dart`; `test/sms_parser_regression_fixture_test.dart` | ALIGNED (implemented transitional state) | Parser facade, detector, shared helpers, evidence-backed regression corpus and bank profiles are implemented; remaining work is to reduce generic regex dependence and expand per-bank parsing coverage. |
| Режим оплаты без QR | `design_v2_single_page.md` | `lib/features/qr/presentation/qr_hub_page.dart` | ALIGNED (W2-008) | Добавлен сценарий прямого ввода телефона/суммы/`last4` с переходом сразу к подтверждению команды. |
| Карточка дневного лимита (CTA) | `design_v2_single_page.md`, `tasks.md` | `lib/features/home/presentation/widgets/daily_limit_card.dart` | ALIGNED | CTA открывает settings из главного экрана. |

## 4. Accepted Decisions
1. `Settings` закрепляется как расширенный MVP+ экран, а не только поле телефона.
2. Для QR сохраняется внутренняя подписанная схема `v3` и совместимость `v2`.
3. Любые device-only дефекты (camera/plugin/vendor) фиксируются и проверяются отдельным smoke-чеклистом.
4. `ACTIVE` документы обязательно обновляются в том же цикле, что и код.
5. Прямая отправка SMS (`SEND_SMS`) допускается только через opt-in переключатель в settings.
6. **Канал распространения — только сайт (2026-03-14).** Google Play не планируется. APK публикуется напрямую через сайт проекта. `green_sms_flutter_and_playstore_plan.md` переведён в `ARCHIVE`.
7. `VN / Vietcombank` исключается из command routing: страна не должна показываться в выборе routing, так как официальный SMS Banking не поддерживает перевод одной SMS-командой.
8. **Два APK (2026-03-15).** Один репозиторий, два Android Product Flavors: `free` (`com.greensms.free`, офлайн) и `pro` (`com.greensms.pro`, онлайн). Free — стабильная базовая версия, обновляется редко. Pro — активно поддерживается. Источник истины: `pro_architecture.md`. `green_sms_pro_and_monetization.md` переведён в `ARCHIVE`.
9. **Донаты — только в Free (2026-03-15).** Кнопка в About → ссылка на страницу поддержки. В Pro нет доната.

## 5. Development Process (Mandatory)
1. Scope Gate:
- Изменение сначала в `ACTIVE` документах и `tasks.md`.
2. Implementation Gate:
- Код только после фиксации требований и критериев приемки.
3. Verification Gate:
- Обязательно: `flutter analyze`, `flutter test`.
- Для QR/SMS/permissions: обязательный device-smoke.
4. Documentation Gate:
- После merge-ready состояния обновляются:
  - `tasks.md` (status),
  - `docs_registry.md` (роль/статус),
  - этот master-документ (матрица/волна).

## 6. Waves Roadmap

### Wave 0 — Stabilization ✅ Завершена (2026-03-14)
Goal: убрать критичные UX/runtime дефекты и зафиксировать единый scope.

Scope:
- стабилизация QR camera flow и обработка scanner ошибок;
- стабилизация SMS composer fallback;
- dark/light visual contrast fixes;
- финализация scope settings и документации;
- device smoke checklist v1.

Exit Criteria: выполнены. Нет P1/P0 дефектов. `analyze` + `test` + device smoke пройдены.

---

### Wave 1 — MVP Closure (Carry-over Backlog)
Goal: формально закрыть MVP — все ключевые сценарии работают и покрыты приемочными тестами.

Scope:
- UX-полировка текстов privacy/permission в onboarding/settings;
- формальное описание поведения дневного лимита для пользователя;
- parser edge-cases, фиксация bank-profile архитектуры и пополнение регрессионного тест-пакета;
- e2e сценарии для native SMS bridge;
- device smoke для сценариев `directSmsEnabled on/off` и отказа `SEND_SMS`.

Exit Criteria:
- все W1-задачи в статусе Done;
- smoke пакет для direct-SMS сценариев заполнен;
- `flutter analyze` + `flutter test` зелёные;
- документация синхронизирована с кодом.

---

### Wave 2 — International Layer 🔄 Текущая (W2-001..W2-005, W2-007, W2-008 Done; W2-006 In Progress)
Goal: полноценная поддержка нескольких стран — банки, шаблоны, языки.

Scope:
- интеграция `sms_banks.json` в приложение: `LocaleConfigService`, `BankRegistryService`, `CommandBuilderService`;
- выбор банка по локали устройства (первичный) + ручная смена в настройках;
- в settings показываются только command-capable страны; если у страны один рабочий банк, он фиксируется автоматически без интерактивного выбора;
- построение SMS/USSD команды из QR payload и шаблона банка;
- USSD-режим: Android URI `tel:...%23` для прямого набора;
- режим оплаты без QR: ввод телефона/суммы/опционального `last4` и прямой переход к подтверждению;
- верификация шаблонов приоритетных банков (Sberbank RU, GTBank NG, FirstBank NG, SBI IN);
- language QA для расширенного набора ARB-файлов (en, ru, hi, kk, uz, fil, id, vi, hy, ur, bn + legacy tl);
- локализация до native QA-качества (нет машинных артефактов).

Exit Criteria:
- Sberbank RU + GTBank NG + FirstBank NG работают end-to-end с реальным QR;
- SBI IN: `manual verification` выполнена и статус в `sms_banks.json` переведен из `needs_verification`;
- USSD URI корректно открывает диалер Android;
- bank/locale resolver покрыт unit-тестами;
- language QA checklist закрыт по расширенному набору языков.

---

### Wave 3 — Flavor Split + Pro Foundation
Goal: разделить репозиторий на два флавора и заложить фундамент Pro — лицензию через Supabase.

Scope:
- настроить Android Product Flavors (`free` / `pro`) в `build.gradle`;
- создать `main_free.dart` и `main_pro.dart` с разными точками DI;
- раздельные `AndroidManifest.xml` (INTERNET только в `pro`);
- абстракция `ParserProfileSource` (Bundled для Free, OTA-ready для Pro);
- генерация `installationId` (UUID) при первом запуске → `flutter_secure_storage`;
- экран Pro: статус Free/Pro, дата истечения, Copy ID, ввод ключа, кнопка "Купить";
- `POST /api/activate {key, device_id}` → Supabase Edge Function;
- кеширование статуса лицензии локально (offline-grace 7 дней);
- Pro-gate заглушка: forwarding недоступен без валидной лицензии.

Exit Criteria:
- `flutter build apk --flavor free` и `--flavor pro` собираются без ошибок;
- Free APK не содержит INTERNET permission;
- `installationId` стабильно сохраняется между сессиями;
- активация ключа через Supabase работает end-to-end;
- невалидный ключ — понятное сообщение об ошибке.

---

### Wave 4 — SMS Forwarding Pro
Goal: реализовать ядро Pro-продукта — пересылку распарсенных SMS.

Scope:
- экран Forwarding Settings: watchlist банков (показывается, не редактируется — управляется сервером), URL-канал (вкл/выкл + поле ввода), SMS-канал (вкл/выкл + поле номера);
- движок пересылки в `SmsReceiver.kt`: при входящем SMS → парсинг → матч по watchlist → WorkManager job;
- `ForwardingWorker` (Kotlin): HTTP POST с `ExponentialBackoff`, до 5 попыток;
- `SmsForwardWorker` (Kotlin): `SmsManager.sendMultipartTextMessage` + dedupe key;
- payload формат webhook: `{license, device_id, timestamp, original, parsed}`;
- payload формат SMS: компактная строка `[gs] bank +amount bal:balance | оригинал...`;
- таблица `forwarding_log` в SQLite: время, банк, статус (sent/failed), канал;
- экран истории пересылок;
- Pro-gate: экран Forwarding виден только при активной лицензии.

Exit Criteria:
- пересылка на URL работает end-to-end на реальном устройстве;
- пересылка на номер работает end-to-end;
- при недоступном интернете WorkManager ретраит и доставляет после восстановления;
- без Pro-лицензии экран Forwarding заблокирован;
- device smoke: forwarding on/off, permission denied, сеть недоступна.

---

### Wave 5 — OTA Parser + FCM Push
Goal: сделать парсер Pro обновляемым без переиздания APK.

Scope:
- `GreenSmsFcmService.kt` (только в Pro): обрабатывает data-messages `bank_watchlist_update` и `parser_update`;
- при `bank_watchlist_update` → сохранить список в SharedPreferences;
- при `parser_update` → `WorkManager` job скачивает JSON с Supabase Storage, валидирует, сохраняет локально;
- `OtaParserProfileSource`: загружает кешированный JSON, fallback → bundled assets;
- `POST /api/fcm-token {device_id, token}` → Supabase при каждом обновлении FCM токена;
- Supabase: таблица `device_tokens`, функция рассылки пуша всем активным Pro устройствам.

Exit Criteria:
- FCM data message обновляет watchlist на устройстве без перезапуска;
- новый `sms_parser_profiles.json` скачивается и применяется без переиздания APK;
- если JSON невалиден → остаётся предыдущая версия (rollback);
- unit-тесты на `OtaParserProfileSource` покрывают happy path, fallback и rollback.

---

### Wave 6 — Supabase Backend + Сайт + Дистрибуция
Goal: запустить backend, сайт и ручную схему продажи лицензий.

Scope:
- Supabase: схема БД (`licenses`, `device_tokens`, `parser_versions`), Edge Functions (`/activate`, `/fcm-token`, `/parser/latest`);
- CLI-скрипт генерации ключа лицензии (Node.js/Python: принимает device_id + срок → INSERT в Supabase → возвращает ключ);
- ручная выдача лицензий (email / Telegram) — для старта без автоматизации;
- APK release builds: `flutter build apk --flavor free --release` и `--flavor pro --release`, keystore подпись;
- сайт: лендинг (описание, скриншоты, Download Free / Download Pro);
- страница Pro: инструкция по покупке, ввод installationId, способ оплаты;
- инструкция sideload + FAQ.

Exit Criteria:
- оба APK скачиваются и устанавливаются с сайта;
- ручной цикл выдачи лицензии протестирован: покупка → генерация ключа → активация в приложении → Pro activated;
- сайт доступен по домену.

---

### Wave 7 — Post-Launch Hardening
Goal: стабилизировать после первых реальных пользователей.

Scope:
- расширение OTA парсера: новые банки по запросам пользователей (через `sms_parser_profiles.json`);
- донат-кнопка в Free (About → ссылка на страницу поддержки);
- crash-free улучшения по реальному feedback;
- оптимизация battery/performance (фоновый `RECEIVE_SMS` receiver).

Exit Criteria:
- нет регрессий после расширения парсера;
- crash rate стабильный по device logs.

## 7. Artifacts Per Wave
Для каждой волны обязательны:
- update в `tasks.md` (In Progress / Done);
- краткий review-отчет с фактами прогонов;
- список измененных `ACTIVE` документов;
- список ручных тест-кейсов и их статусов.

## 8. Canonical Active Docs (Order of Precedence)
1. `documents/master_development_process_and_waves.md`
2. `documents/tasks.md`
3. `documents/active_constraints_mvp.md`
4. `documents/design_v2_single_page.md`
5. `documents/zelenaya_sms_tz_v1.md`
