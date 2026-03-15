# Green SMS — SMS Parser Architecture

> Status: `FUTURE`
> Updated: `2026-03-14`
> Source Task: `W1-003`

## 1. Goal

Слой parser должен:
- разбирать входящие банковские SMS офлайн;
- масштабироваться по странам и банкам без роста хрупких `if/else`;
- позволять добавлять новый банк без регрессий в уже работающих форматах.

## 2. Target Design

Рекомендуемая схема:

1. `SmsNormalizer`
- trim / collapse spaces;
- унификация масок счетов и карт;
- нормализация числовых форматов (`1 000,50`, `1,000.50`, `1200000`);
- приведение валютных маркеров к общему виду.

2. `SmsBankDetector`
- определение профиля по:
  - `bankId` из routing-контекста;
  - sender aliases;
  - ключевым словам;
  - country fallback.

3. `SmsParserEngine`
- общий движок, который умеет:
  - `amount`
  - `balance`
  - `last4`
  - `operationType`
  - `reference`
- использует bank-specific patterns, а не глобальный монолитный regex-набор.

4. `Bank Parser Profiles`
- profile на банк:
  - `sberbank_ru`
  - `axisbank_in`
  - `hdfcbank_in`
  - `icicibank_in`
  - `gtbank_ng`
  - `firstbank_ng`
  - `sbi_in`
  - `ubl_pk`
  - `bkash_bd`
  - `mandiri_id`
  - `gcash_ph`
  - `vivacell_am`
- профиль хранит:
  - sender aliases;
  - amount patterns;
  - balance patterns;
  - last4 patterns;
  - incoming/outgoing/transfer keywords;
  - parse priority.

5. `Country Fallback Profiles`
- общий fallback для страны, если SMS не совпал с конкретным банком.

6. `Generic Notification Parser`
- последний fallback только для notification-mode;
- не используется для формирования платежных решений, если confidence низкий.

## 3. Runtime Flow

```text
raw SMS
 -> normalize
 -> detect bank profile
 -> parse with bank profile
 -> fallback country profile
 -> fallback generic notification parser
 -> structured SmsMessage
```

## 4. Routing Rules

- Командный routing (`страна -> банк`) и parser routing должны быть согласованы, но не идентичны.
- Банк может быть:
  - `command-capable`
  - `parser-only`
  - `excluded`

Пример:
- `Vietcombank (VN)` — не command-capable для Green SMS, но parser-only для balance/notification сообщений допустим.

## 5. Vietnam Decision

`Vietcombank` не поддерживает перевод денег через SMS-команду в формате проекта.

Поэтому:
- страна `VN` не должна попадать в UI-список routing-стран для команд;
- шаблон `VCB TRANSFER {phone} {amount}` запрещен;
- parser может поддерживать только notification/balance SMS, если это полезно для истории операций.

## 6. Incremental Refactor Plan

### Step A
- сохранить текущий `SmsParser` как фасад;
- вынести numeric normalization и common regex helpers в отдельные utility-файлы.

### Step B
- вынести bank profiles в отдельный каталог:
  - `lib/features/sms/data/parsing/profiles/`

### Step C
- ввести dispatcher:
  - profile by `bankId`
  - country fallback
  - generic fallback

### Step D
- перевести тесты на структуру `group by bank`.

## 7. Test Strategy

Обязательные тесты:
- unit tests per bank;
- regression tests по реальным SMS из документов;
- negative tests:
  - OTP
  - service SMS
  - unknown format
  - unsupported bank

## 8. Current Status

На `2026-03-14`:
- `SmsParser` уже работает как facade;
- внедрены shared layers:
  - `SmsNumberParser`
  - `SmsPatternLibrary`
  - `SmsParserProfileDetector`
- внедрены bank profiles:
  - `sberbank_ru`
  - `sbi_in`
  - `axisbank_in`
  - `hdfcbank_in`
  - `icicibank_in`
  - `gtbank_ng`
  - `firstbank_ng`
  - `zenith_ng`
  - `uba_ng`
  - `access_ng`
  - `ubl_pk`
  - `bkash_bd`
  - `mandiri_id`
  - `gcash_ph`
  - `vivacell_am`
- добавлены detector tests и profile-specific parsing tests;
- добавлен отдельный regression corpus из внешнего evidence-pack:
  - `test/fixtures/sms_parser_regression_fixtures.dart`
  - `test/sms_parser_regression_fixture_test.dart`
- regression corpus расширен на:
  - `axisbank_in`
  - `hdfcbank_in`
  - `icicibank_in`
  - `ubl_pk`
  - `mandiri_id`
  - `gcash_ph`
  - `vivacell_am`
- в regression corpus добавлены negative fixtures:
  - OTP
  - service-only SMS
  - malformed bank alerts
  - unsupported bank messages
- `axisbank_in`, `hdfcbank_in`, `icicibank_in` подняты из generic fallback в отдельные detector-backed bank profiles;
- в доменную модель `SmsMessage` добавлено поле `reference`, с сохранением в SQLite и generic extraction для `REF / TrxID / RRN`;
- `reference` выведен в SMS details sheet как условное поле, если parser его нашел;
- для `UBL`, `Mandiri`, `UBA`, `GCash` добавлены bank-specific `referencePatterns`; компактный `Ref` также показан в карточке SMS на главной;
- для `firstbank_ng`, `zenith_ng`, `access_ng`, `ubl_pk`, `gcash_ph`, `vivacell_am`, `bkash_bd` уже выделены bank-specific `amount/balance` patterns;
- generic parser расширен для индийского маркера валюты `Rs`, что закрыло fallback cases для `Axis/HDFC/ICICI`;
- международные edge-cases по форматам чисел и `last4` стабилизированы;
- refactor остается `In Progress`, потому что generic regex-библиотека еще не полностью разгружена по bank-specific patterns.
