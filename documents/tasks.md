# Tasks Backlog

> Status: `ACTIVE`
> Scope: wave-based план реализации
> Updated: `2026-03-15` (Wave 2: W2-001..W2-005, W2-007, W2-008 Done; W2-006 In Progress; W1-003 In Progress; архитектура W3+ переработана под два флавора + Supabase)

## Rules
- Реализация задач допускается только из `ACTIVE` документов.
- Любая новая функция сначала фиксируется в `ACTIVE` документе, потом в коде.
- Статусы задач обновляются вместе с изменениями в `master_development_process_and_waves.md`.

## Completed Wave — Wave 0 (Stabilization)
| ID | Priority | Task | Status | Source |
|---|---|---|---|---|
| W0-001 | P1 | Стабилизировать QR-flow на реальном устройстве (камера, галерея, SMS composer) | Done | `master_development_process_and_waves.md` |
| W0-002 | P1 | Закрыть device smoke checklist v1 (home, permissions, QR, SMS composer) с заполненным протоколом | Done | `zelenaya_sms_tz_v1.md` |
| W0-003 | P1 | Зафиксировать единый settings scope в ACTIVE документах | Done | `design_v2_single_page.md` |
| W0-004 | P2 | Привести контраст info-banners к теме (dark/light) | Done | `design_v2_single_page.md` |
| W0-005 | P2 | Исправить CTA в `DailyLimitCard` (переход в settings или удаление кнопки) | Done | `project_review_2026-03-13.md` |

## Wave 1 — MVP Closure (Backlog)
| ID | Priority | Task | Status | Source |
|---|---|---|---|---|
| W1-001 | P1 | Уточнить тексты privacy/permission в onboarding/settings | Next | `zelenaya_sms_tz_v1.md` |
| W1-002 | P1 | Формально описать поведение дневного лимита для пользователя | Next | `active_constraints_mvp.md` |
| W1-003 | P2 | Доработать parser edge-cases, зафиксировать bank-profile архитектуру и пополнить регрессионный тест-пакет | In Progress | `active_constraints_mvp.md` |
| W1-004 | P2 | Формализовать e2e сценарии для native SMS bridge | Next | `project_review_2026-03-13.md` |
| W1-005 | P2 | Ввести статусы QR/SMS события (`prepared/sent/cancelled`) и учитывать лимит по `sent` | Done | `project_review_2026-03-13.md` |
| W1-006 | P1 | Для Sber QR-flow сделать обязательную сумму и опциональный `last4` источника в команде `900` | Done | `zelenaya_sms_tz_v1.md` |
| W1-007 | P1 | Развести два режима генерации QR (`My QR` без суммы и `QR с суммой`) и сделать выбор `last4` раскрывающимся | Done | `design_v2_single_page.md` |
| W1-008 | P1 | Добавить opt-in режим прямой отправки SMS (`SEND_SMS`) с fallback в системный composer | Done | `active_constraints_mvp.md` |
| W1-009 | P1 | Провести device smoke для сценариев `directSmsEnabled on/off` и отказа в `SEND_SMS` | Next | `device_smoke_checklist.md` |

## Current Wave — Wave 2 (International Layer)
| ID | Priority | Task | Status | Source |
|---|---|---|---|---|
| W2-001 | P1 | Реализовать `LocaleConfigService` + `BankRegistryService` (загрузка `sms_banks.json`) | Done | `greensms_banks_locales_architecture.md` |
| W2-002 | P1 | Реализовать `CommandBuilderService`: buildSmsCommand / buildUssdCommand из QR payload | Done | `greensms_banks_locales_architecture.md` |
| W2-003 | P1 | Интегрировать bank resolver в QR-flow: выбор метода (SMS / USSD) по банку локали | Done | `greensms_supported_locales.md` |
| W2-004 | P1 | USSD-режим: формировать Android URI `tel:...%23` и открывать диалер | Done | `greensms_banks_locales_architecture.md` |
| W2-005 | P2 | Ручная смена банка в настройках (`страна` → `банк`, с fallback на primary) | Done | `greensms_supported_locales.md` |
| W2-006 | P2 | Верификация шаблонов и official data-layer: лимиты, правила и каналы по банкам | In Progress | `sms_banks.json` |
| W2-007 | P2 | Language QA для ARB-файлов (en, ru, hi, kk, uz, fil, id, vi, hy, ur, bn + legacy tl) | Done | `greensms_supported_locales.md` |
| W2-008 | P1 | Режим оплаты без QR: ввод телефона+суммы(+опц. `last4`) и переход сразу к подтверждению команды | Done | `design_v2_single_page.md` |

## Wave 3 — Flavor Split + Pro Foundation
| ID | Priority | Task | Status | Source |
|---|---|---|---|---|
| W3-001 | P1 | Настроить Android Product Flavors `free`/`pro` в `build.gradle` + раздельные `AndroidManifest.xml` | Future | `pro_architecture.md` |
| W3-002 | P1 | Создать `main_free.dart` и `main_pro.dart` с DI разделением | Future | `pro_architecture.md` |
| W3-003 | P1 | Абстракция `ParserProfileSource`: `BundledParserProfileSource` (Free) + заглушка OTA (Pro) | Future | `pro_architecture.md` |
| W3-004 | P1 | Генерация `installationId` (UUID) при первом запуске → `flutter_secure_storage` | Future | `pro_architecture.md` |
| W3-005 | P1 | Экран Pro: статус Free/Pro + дата истечения, Copy ID, ввод ключа, кнопка "Купить" | Future | `pro_architecture.md` |
| W3-006 | P1 | Supabase: создать схему `licenses` + Edge Function `POST /api/activate` | Future | `pro_architecture.md` |
| W3-007 | P1 | Flutter: активация ключа через `/api/activate`, кеш статуса (offline-grace 7 дней) | Future | `pro_architecture.md` |
| W3-008 | P1 | Pro-gate заглушка: forwarding недоступен без валидной лицензии | Future | `pro_architecture.md` |

## Wave 4 — SMS Forwarding Pro
| ID | Priority | Task | Status | Source |
|---|---|---|---|---|
| W4-001 | P1 | Экран Forwarding Settings: URL-канал (вкл/выкл + ввод) + SMS-канал (вкл/выкл + номер) + watchlist (readonly) | Future | `pro_architecture.md` |
| W4-002 | P1 | Движок пересылки в `SmsReceiver.kt`: матч по watchlist → запуск WorkManager job | Future | `pro_architecture.md` |
| W4-003 | P1 | `ForwardingWorker`: HTTP POST payload `{license, device_id, timestamp, original, parsed}` с ExponentialBackoff | Future | `pro_architecture.md` |
| W4-004 | P1 | `SmsForwardWorker`: `sendMultipartTextMessage` + dedupe key, компактный payload формат | Future | `pro_architecture.md` |
| W4-005 | P1 | SQLite таблица `forwarding_log` + экран истории пересылок | Future | `pro_architecture.md` |
| W4-006 | P1 | Device smoke: forwarding URL on/off, forwarding SMS on/off, permission denied, сеть недоступна | Future | `device_smoke_checklist.md` |

## Wave 5 — OTA Parser + FCM Push
| ID | Priority | Task | Status | Source |
|---|---|---|---|---|
| W5-001 | P1 | `GreenSmsFcmService.kt`: обработка data-messages `bank_watchlist_update` и `parser_update` | Future | `pro_architecture.md` |
| W5-002 | P1 | `OtaParserProfileSource`: загрузка кешированного JSON + fallback на bundled assets | Future | `pro_architecture.md` |
| W5-003 | P1 | WorkManager job для скачивания `sms_parser_profiles.json` с Supabase Storage + валидация + rollback | Future | `pro_architecture.md` |
| W5-004 | P1 | Supabase: таблица `device_tokens` + Edge Function `POST /api/fcm-token` + рассылка пуша | Future | `pro_architecture.md` |
| W5-005 | P2 | Unit-тесты: `OtaParserProfileSource` happy path, fallback, rollback | Future | `pro_architecture.md` |

## Wave 6 — Supabase Backend + Сайт + Дистрибуция
| ID | Priority | Task | Status | Source |
|---|---|---|---|---|
| W6-001 | P1 | Supabase: полная схема БД (`licenses`, `device_tokens`, `parser_versions`) | Future | `pro_architecture.md` |
| W6-002 | P1 | CLI-скрипт генерации ключа: принимает device_id + срок → INSERT в Supabase → возвращает ключ | Future | `pro_architecture.md` |
| W6-003 | P1 | APK release builds: `--flavor free --release` + `--flavor pro --release`, keystore подпись | Future | `pro_architecture.md` |
| W6-004 | P1 | Сайт: лендинг (Download Free / Download Pro) + страница Pro (покупка) | Future | `master_development_process_and_waves.md` |
| W6-005 | P2 | Инструкция sideload + FAQ по лицензии на сайте | Future | `master_development_process_and_waves.md` |

## Wave 7 — Post-Launch Hardening
| ID | Priority | Task | Status | Source |
|---|---|---|---|---|
| W7-001 | P2 | Расширение OTA парсера: новые банки по feedback через `sms_parser_profiles.json` | Future | `pro_architecture.md` |
| W7-002 | P3 | Донат-кнопка в Free (About → ссылка на страницу поддержки) | Future | `active_constraints_mvp.md` |
| W7-003 | P2 | Crash-free улучшения и оптимизация battery/performance | Future | `master_development_process_and_waves.md` |

## Done
| ID | Date | Result |
|---|---|---|
| MVP-001 | 2026-03-13 | Добавлен референс-дизайн и стартовая иконка |
| MVP-002 | 2026-03-13 | Обновлены Android launcher icons (`mipmap-*`) |
| MVP-003 | 2026-03-13 | Проект переведен в одностраничный UX |
| MVP-004 | 2026-03-13 | Внедрен внутренний QR payload `v3` с подписью HMAC и совместимостью `v2` |
| MVP-005 | 2026-03-13 | Полная локализация базового набора RU/EN/HI/KK/UZ/TL/ID без пропусков ключей |
| MVP-006 | 2026-03-13 | Исправлен language-switch lag в app bar/settings |
| MVP-007 | 2026-03-13 | QR-scanner flow укреплен: lifecycle + error handling + fallback UI |
| MVP-008 | 2026-03-13 | Исправлен контраст подсказочного баннера в dark mode |
| DOC-010 | 2026-03-13 | Введены статусы `ACTIVE/FUTURE` для документации |
| DOC-011 | 2026-03-13 | Внедрен governance (`docs_registry`) и зафиксированы `active_constraints_mvp` |
| DOC-012 | 2026-03-13 | В реестр включены документы по лицензированию и `sms_banks` |
| DOC-013 | 2026-03-13 | Добавлен master-документ по процессу и wave roadmap |
| DOC-014 | 2026-03-13 | Проведено повторное сопоставление code↔docs, обновлены review и wave-задачи по найденным дельтам |
| MVP-009 | 2026-03-13 | Исправлен CTA в `DailyLimitCard`: кнопка ведет в settings |
| MVP-010 | 2026-03-13 | QR-история переведена на статусы `prepared/sent/cancelled`, лимит считается только по `sent` |
| MVP-011 | 2026-03-14 | QR-flow для Сбера переведен на команду `900`: сумма обязательна, `last4` источника опционален, команда формируется как `ПЕРЕВОД <phone> <amount> [last4]` |
| MVP-012 | 2026-03-14 | Добавлены режимы `My QR` (без суммы) и `QR с суммой`; при сканировании сумма всегда подтверждается/вводится, `last4` выбирается в раскрывающемся блоке |
| QA-001 | 2026-03-14 | Выполнен ADB-assisted device-smoke run на `V2231` (частично закрыты SMK-003/004/005/008/010/012) |
| QA-002 | 2026-03-14 | Завершен полный device-smoke run: закрыты `SMK-001..SMK-012`, включая no-QR, foreign-QR и открытие системного SMS composer |
| MVP-013 | 2026-03-14 | Добавлен opt-in режим прямой отправки SMS (`SEND_SMS`) через settings, с безопасным fallback в системный composer |
| DOC-015 | 2026-03-14 | В `docs_registry` добавлен ранее неучтенный документ `greensms_supported_locales.md` |
| DOC-016 | 2026-03-14 | Зафиксирована целевая parser-архитектура (`sms_parser_architecture.md`); Vietnam исключен из command routing, оставлен только как parser-only |
| DOC-017 | 2026-03-14 | Parser-слой переведен в implemented transitional state: facade + detector + bank profiles + profile-specific tests; добавлен `firstbank_ng` profile |
| DOC-018 | 2026-03-14 | Часть international parser-банков переведена на bank-specific `amount/balance` regex (`firstbank_ng`, `zenith_ng`, `access_ng`, `ubl_pk`) |
| DOC-019 | 2026-03-14 | Сформирован и расширен `bank_sms_evidence_pack.md`: внешний corpus по банкам с source links, exact samples, confidence и parser gaps |
| DOC-020 | 2026-03-14 | На базе evidence-pack добавлен parser regression corpus (`fixtures` + full-path tests detect→parse); generic parser расширен для `Rs` fallback-cases (`Axis/HDFC/ICICI`) |
| DOC-021 | 2026-03-14 | Regression corpus расширен на `UBL`, `Mandiri`, `GCash`, `MobiDram`; международный parser test-pack теперь покрывает bank-profile и fallback сценарии шире |
| DOC-022 | 2026-03-14 | `Axis/HDFC/ICICI` подняты из generic fallback в отдельные bank profiles с detector tests, profile parsing tests и regression fixtures |
| DOC-023 | 2026-03-14 | В regression corpus добавлены negative fixtures: OTP, service-only SMS, malformed alerts и unsupported bank; проверка идет через полный путь `detect→parse` |
| DOC-024 | 2026-03-14 | В `SmsMessage` добавлено поле `reference` с SQLite migration и generic extraction для `REF/TrxID/RRN`; покрыто parser tests и entity round-trip test |
| DOC-025 | 2026-03-14 | `reference` выведен в SMS details sheet; во все ARB добавлен ключ `smsDetailsReference`, l10n regenerated без пропусков |
| DOC-026 | 2026-03-14 | Для `UBL/Mandiri/UBA/GCash` добавлены bank-specific `referencePatterns`; компактный `Ref` показан и в карточке SMS на главной |
| DOC-027 | 2026-03-14 | Проведен официальный аудит лимитов/правил/каналов по банкам; `sms_banks.json` дополнен provenance-полями (`official_status`, `panel_channel`, `official_sources`, `last_verified_at`) и обновлен для инфопанели по публичным источникам |
| W2-001 | 2026-03-14 | `BankRegistryService` реализован: загрузка `assets/data/sms_banks.json`, поиск по locale tag + language fallback |
| W2-002 | 2026-03-14 | `CommandBuilderService` реализован: `buildCommand(bank, payload)` → `SmsCommandResult` / `UssdCommandResult` |
| W2-003 | 2026-03-14 | Bank resolver интегрирован в `QrHubPage`: locale detection → primary bank → command type |
| W2-004 | 2026-03-14 | USSD-режим: `UssdCommandResult.uri` формируется как `tel:...%23`, открывается через `launchUrl` |
| W2-005 | 2026-03-14 | В settings добавлен routing override `страна` → `банк`; выбор сохраняется в локальных настройках и используется в QR-flow |
| W2-007 | 2026-03-14 | Выполнен language QA для расширенного набора ARB: проверена полнота ключей и native-названия в селекторе, пропусков ключей нет |
| W2-008 | 2026-03-14 | В QR Hub добавлен режим “по телефону без QR”: ввод телефона, суммы и опционального `last4` с переходом сразу к подтверждению оплаты |
