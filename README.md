# Зелёная SMS (MVP+) 

Локальное Android-приложение на Flutter + Kotlin bridge:
- читает только последние 10 SMS;
- парсит `last4`, сумму, баланс и тип операции;
- отображает состояния счетов по `last4`;
- имеет одностраничный UI с настройками через иконку;
- хранит только телефон устройства (без логина/аккаунта);
- генерирует/сканирует внутренний QR в полноэкранном режиме камеры;
- открывает сценарий ручного формирования SMS.

## Архитектура
Используется слоистая feature-архитектура:
- `domain`: сущности, интерфейсы репозиториев, use-cases;
- `data`: local/native data source, repository implementation, parser;
- `presentation`: экраны и UI-компоненты;
- `app`: bootstrap, DI (`get_it`), глобальный controller.

## Основные модули
- `lib/features/sms` — native bridge + parser + хранение SMS
- `lib/features/qr` — профили QR, генерация, сканирование, история
- `lib/features/settings` — локальные настройки и онбординг
- `lib/core` — БД, сервисы разрешений, логирование, result/errors

## Документация
- Реестр документации и статусов: `documents/docs_registry.md`
- Активное ТЗ: `documents/zelenaya_sms_tz_v1.md`
- Активный UX-дизайн: `documents/design_v2_single_page.md`
- Активные ограничения MVP: `documents/active_constraints_mvp.md`
- Активный бэклог задач: `documents/tasks.md`
- Технический аудит состояния: `documents/project_review_2026-03-13.md`
- Стратегия монетизации (future): `documents/green_sms_monetization_strategy.md`
- База верифицированных банков (future): `documents/green_sms_verified_banks_and_sms_formats.md`

## Android native
- `MainActivity` настраивает `MethodChannel` и `EventChannel`
- `SmsBridge.kt` читает последние SMS из inbox
- `SmsReceiver.kt` принимает входящие SMS и пушит в Flutter stream

## Разрешения
- `READ_SMS`
- `RECEIVE_SMS`
- `CAMERA`

## Запуск
1. `flutter pub get`
2. `flutter analyze`
3. `flutter test`
4. `flutter run`
