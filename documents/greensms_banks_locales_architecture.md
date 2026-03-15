
# Green SMS — Banks & Locales Architecture

## 1. Goal

This package defines the minimal architecture for:
- bank templates
- locale mapping
- primary-bank selection by locale

The project rule is strict:

- only full SMS commands
- only full USSD templates
- no interactive USSD menus

---

## 2. Files

### `banks.json`
Contains:
- primary bank/system entries
- SMS templates
- USSD templates
- parser examples
- verification status

### `locales.json`
Contains:
- locale metadata
- primary bank mapping
- UI labels
- currency
- optional extra banks

---

## 3. Recommended runtime flow

### Step 1
App detects locale, for example:
- ru-RU
- en-IN
- en-NG

### Step 2
App loads `locales.json`

### Step 3
App gets `primary_bank_id`

### Step 4
App loads bank entry from `banks.json`

### Step 5
When user scans internal QR, app checks:
- if SMS template exists → build SMS
- if USSD template exists → build direct USSD
- otherwise show unsupported message

### Step 6
Settings routing UI uses only operational countries:
- country appears in selector only if at least one bank is command-capable;
- if country has exactly one operational bank, bank selector is fixed/auto-selected;
- excluded/parser-only countries (example: `VN / Vietcombank`) stay in research data, but do not appear in command routing.

---

## 4. QR payload example

```json
{
  "phone": "08123456789",
  "amount": "1000",
  "account": "0123456789",
  "note": "Taxi"
}
```

---

## 5. Build rules

### SMS
Example template:
`ПЕРЕВОД {phone} {amount}`

Output:
`ПЕРЕВОД 9123456789 1000`

### USSD
Example template:
`*894*{amount}*{account}#`

Output:
`*894*1000*0123456789#`

For Android dialer:
`tel:*894*1000*0123456789%23`

---

## 6. Status meaning

- `verified` — ready for production
- `needs_verification` — present in base, but needs manual confirmation before enabling by default

---

## 7. MVP recommendation

Enable by default:
- Sberbank (ru-RU)
- FirstBank Nigeria (en-NG)

Keep behind verification flag:
- India
- Pakistan
- Bangladesh
- Indonesia
- Philippines
- Ghana
- Armenia

Exclude from command routing:
- Vietnam (`Vietcombank`) — notification/balance parser only

---

## 8. Flutter loading pattern

Recommended services:
- `LocaleConfigService`
- `BankRegistryService`
- `CommandBuilderService`

Recommended methods:
- `loadLocales()`
- `loadBanks()`
- `getPrimaryBankForLocale(locale)`
- `buildSmsCommand(bank, payload)`
- `buildUssdCommand(bank, payload)`

---

## 9. Next step

From these files you can implement:
- Dart data models
- JSON loaders
- bank resolver by locale
- QR-driven command generation
- command-capable country filtering in settings
