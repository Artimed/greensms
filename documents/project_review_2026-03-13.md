# Project Review — 2026-03-13

> Status: `ARCHIVE`
> Type: `technical review report (Wave 0 snapshot)`
> Scope: код + документация на 2026-03-13
> Updated: `2026-03-14`
> Note: Wave 0 закрыта. Открытые findings (P2/P3) перенесены в `tasks.md`.

## Checks
- `flutter analyze` — passed (`No issues found`)
- `flutter test -r compact` — passed (`All tests passed`)
- Проверка `ARB` ключей — passed (во всех `app_*.arb` без пропусков по key-set).
- Device smoke run (`V2231`, `2026-03-14`) — full pass: закрыты `SMK-001..SMK-012`, включая `no-QR`, `foreign-QR`, `SMS composer`.
- Delta note: после добавления opt-in режима `directSmsEnabled` (`SEND_SMS`) device smoke для `SMK-013..SMK-015` еще не закрыт.

## Code-to-Docs Snapshot
- `ACTIVE` документы и код в целом согласованы по архитектуре (offline/local, SQLite, Flutter+Kotlin bridge, single-page + fullscreen QR).
- Добавлен master-процесс с wave-roadmap: `documents/master_development_process_and_waves.md`.
- Добавлен формальный smoke-шаблон: `documents/device_smoke_checklist.md`.
- Открытые вопросы находятся в качестве реализации и процессных артефактов (не в базовой архитектуре).

## Findings

### P2 — Подтверждение отправки SMS самоотчетное
- Файл: `lib/features/qr/presentation/qr_hub_page.dart`
- Проблема: после открытия системного composer статус `sent` фиксируется по ответу пользователя в диалоге приложения.
- Риск: возможна ошибка учета при неверном пользовательском подтверждении.

### P2 — Жестко зашитые бизнес-данные по лимитам Сбера
- Файл: `lib/features/sms/presentation/transfer_limits_page.dart`
- Проблема: фиксированные суммы/условия могут устареть.
- Риск: пользователь увидит неактуальную информацию.

### P2 — Шумные vendor camera logs на реальном устройстве
- Файлы: `lib/features/qr/presentation/qr_hub_page.dart`, `android/...`
- Проблема: на Vivo/MediaTek фиксируются многочисленные системные `mali_gralloc/CameraManager` сообщения.
- Риск: затрудненная диагностика реальных дефектов сканера в логах (noise floor высокий).

### P3 — Нет интеграционных тестов на нативный SMS bridge
- Файлы: `android/...`, `lib/features/sms/data/datasources/sms_native_data_source.dart`
- Проблема: покрыт в основном parser, но не end-to-end сценарии разрешений/чтения/приема SMS.
- Риск: регрессии проявятся только на устройстве.

## Resolved In This Iteration
- Закрыт полный `device_smoke_checklist` на `V2231` (`SMK-001..SMK-012`).
- Sber QR-flow синхронизирован с SMS-командами: отправка в `900`, сумма обязательна, `last4` источника опционален.
- Стабилизирован scanner error handling (`MobileScanner.onDetectError`, UI fallback).
- Исправлен contrast issue подсказочного баннера в dark theme.
- Документация выровнена по settings-scope через `design_v2_single_page.md` + master-документ.
- Введен формальный `documents/device_smoke_checklist.md`.
- QR-учет переведен на статусы `prepared/sent/cancelled`; лимит считается только по `sent`.
- Кнопка settings в `DailyLimitCard` подключена к реальной навигации.

## Recommendations
1. Зафиксировать baseline для `Wave 1`: использовать текущий smoke-протокол как эталон и переиспользовать сценарии на каждом релиз-кандидате.
2. Для лимитов Сбера добавить дату актуальности и сделать официальный источник primary.
3. Рассмотреть политику подтверждения `sent` (например, явный пост-compose flow) и зафиксировать в UX-документации.
4. Добавить интеграционный smoke сценарий для SMS bridge на физическом Android.
