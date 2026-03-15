
# Green SMS — Supported Locales & Banks (MVP Strategy)

> Status: `FUTURE`
> Updated: `2026-03-14`

> Language QA note (2026-03-14):
> - ARB completeness check passed for `en/ru/hi/kk/uz/fil/id/vi/hy/ur/bn` (+legacy `tl`) with no missing keys vs `app_en.arb`.
> - Native language names used in settings selector (self-name + flag).

This document defines the supported locales, banks, and payment templates for the Green SMS project.

**Goal:** Support only systems that allow full offline command automation — no interactive flows.

Supported automation types:
- **Tier 1** — SMS Full Command (primary: user sends SMS to bank number)
- **Tier 2** — SMS Full Command + USSD Full Template (both methods available)
- **Tier 3** — USSD Full Template only (one-line code, no interactive menu)

**Not supported:**
- USSD interactive menus (e.g. M-Pesa *247#, bKash *247# menu flow)
- Step-by-step USSD flows requiring multiple user inputs
- Systems requiring manual input after launch

---

# Selection Rules

A bank/system is included only if it satisfies at least one:

1. **Full SMS command** — single outgoing SMS triggers the transfer
   - Example: `ПЕРЕВОД 9123456789 1000` → send to 900

2. **Full USSD template** — complete one-line code sent at once
   - Example: `*737*1*1000*0123456789#`

**Excluded:**
```
*123#
→ menu → enter phone → enter amount
```

---

# MVP Enabled (Default ON)

These locales are verified and enabled by default.

---

## Russia — ru-RU
**Tier: 1 (SMS)**
**Status: verified**

| Bank | Method | Template | Number |
|------|--------|----------|--------|
| Sberbank (primary) | SMS | `ПЕРЕВОД {phone} {amount}` | 900 |

Parser examples:
- `СЧЁТ 8036: зачисление 2 500 ₽. Баланс 12 000 ₽.`
- `КАРТА 8036: покупка 499 ₽. Баланс 11 501 ₽.`
- `****8036: перевод +1 000 ₽. Баланс 15 200 ₽.`

Other RU banks (T-Bank, VTB, Alfa-Bank): parser only, no verified send template.

---

## Nigeria — en-NG
**Tier: 3 (USSD one-line)**
**Status: primary verified, others need verification**

| Bank | Method | Template | Status |
|------|--------|----------|--------|
| GTBank (primary) | USSD | `*737*1*{amount}*{account}#` | verified |
| FirstBank | USSD | `*894*{amount}*{account}#` | verified |
| Zenith Bank | USSD | `*966*{amount}*{account}#` | needs_verification |
| UBA | USSD | `*919*4*{account}*{amount}#` | needs_verification |
| Access Bank | USSD | `*901*{amount}*{account}#` | needs_verification |

Android URI format: `tel:*737*1*1000*0123456789%23`

Note: UBA has reversed variable order — account before amount.

---

# Enabled Behind Verification Flag (Default OFF)

These locales are in the database but require manual confirmation before production use.

---

## India — en-IN
**Tier: 2 (SMS + USSD)**
**Status: needs_verification**

| Bank | Method | Template | Number |
|------|--------|----------|--------|
| SBI (primary) | SMS | `IMPS {phone} {amount}` | — |
| SBI (primary) | USSD | `*99*1*{phone}*{amount}#` | — |

Parser examples:
- `INR 1,000 credited to A/C XX8036 via IMPS. Avl Bal INR 15,200.`
- `Acct XX8036 debited by INR 499. Avl Bal INR 11,501.`
- `A/c XX8036 me INR 2500 credit hua. Available balance INR 12000.`

Other IN banks (Axis, HDFC, ICICI): parser only, no verified send template.

---

## Pakistan — en-PK
**Tier: 1 (SMS)**
**Status: needs_verification**

| Bank | Method | Template | Number |
|------|--------|----------|--------|
| UBL Bank (primary) | SMS | `SEND {phone} {amount}` | — |

Parser examples:
- `Transaction successful.`
- `Available balance PKR 12,000.`

---

## Bangladesh — en-BD
**Tier: 1 (SMS)**
**Status: needs_verification**

| Bank | Method | Template | Number |
|------|--------|----------|--------|
| bKash (primary) | SMS | `SEND {phone} {amount}` | — |

Parser examples:
- `Cash In Successful.`
- `Available balance BDT 12,000.`

**Note:** bKash `*247#` is an interactive USSD menu — intentionally excluded per project policy.

---

## Indonesia — id-ID
**Tier: 1 (SMS)**
**Status: needs_verification**

| Bank | Method | Template | Number |
|------|--------|----------|--------|
| Bank Mandiri (primary) | SMS | `TRF {phone} {amount}` | — |

Parser examples:
- `Transfer berhasil.`
- `Saldo tersedia IDR 120000.`

---

## Philippines — en-PH
**Tier: 1 (SMS)**
**Status: needs_verification**

| Bank | Method | Template | Number |
|------|--------|----------|--------|
| GCash / Smart Money (primary) | SMS | `SEND {phone} {amount}` | — |

Parser examples:
- `You have sent PHP 500.`
- `Remaining balance PHP 1,200.`

---

## Vietnam — vi-VN
**Tier: parser-only**
**Status: excluded from command routing**

| Bank | Method | Command Template | Status |
|------|--------|------------------|--------|
| Vietcombank (primary) | Notification / balance parsing only | — | excluded |

Reason:
- official Vietcombank SMS Banking supports notifications, balance inquiries, top-up and service commands;
- money transfer via one-line SMS command is not supported;
- therefore Vietnam must not appear in command-capable country routing.

Parser examples:
- `Giao dich thanh cong.`
- `So du hien tai VND 1200000.`

---

## Ghana — en-GH *(new)*
**Tier: 3 (USSD one-line)**
**Status: needs_verification**

| Bank | Method | Template | Number |
|------|--------|----------|--------|
| Vodafone Cash / Telecel Cash | USSD | `*516*{phone}*{amount}*{pin}#` | — |

**Special:** PIN is embedded directly in the USSD string — user must enter their own PIN as a variable.

Parser examples:
- `GHS50.00 sent to 0241234567 successfully.`

---

## Armenia — hy-AM *(new)*
**Tier: 3 (USSD one-line)**
**Status: needs_verification**

| Bank | Method | Template | Number |
|------|--------|----------|--------|
| VivaCell-MTS (VivaMoney) | USSD | `*126*{phone}*{amount}#` | — |

Parser examples:
- `Փոխանցումը կատարվեց։`

---

# Currently Excluded (Research Notes)

| Country | System | Reason |
|---------|--------|--------|
| Kenya | M-Pesa *334# | Interactive USSD menu only |
| Tanzania | M-Pesa | USSD menu |
| Uganda | MTN MoMo | USSD menu |
| Thailand | Banking apps | No SMS/USSD transfer protocol |
| China | Alipay / WeChat | App-based, no SMS/USSD |
| Bangladesh | bKash *247# | Interactive USSD menu (SMS template kept separately) |

---

# Template Variable Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `{phone}` | Recipient phone number | `9123456789` |
| `{amount}` | Transfer amount (no currency) | `1000` |
| `{account}` | Recipient bank account number | `0123456789` |
| `{pin}` | User's own PIN (embedded in USSD) | `1234` |

---

# Runtime Flow (per Architecture Doc)

1. App detects device locale (e.g. `ru-RU`, `en-NG`)
2. App loads locale entry → gets `primary_bank_id`
3. App loads bank entry from registry
4. When user scans internal QR:
   - If SMS template exists → build SMS command
   - If USSD template exists → build one-line USSD → Android: `tel:...%23`
   - Both available → user chooses method
   - Neither → show unsupported message

---

# Recommended MVP Scope

| Locale | Country | Tier | Default |
|--------|---------|------|---------|
| ru-RU | Russia | 1 | ON |
| en-NG | Nigeria | 3 | ON |
| en-IN | India | 2 | OFF (verify) |
| en-PK | Pakistan | 1 | OFF (verify) |
| en-BD | Bangladesh | 1 | OFF (verify) |
| id-ID | Indonesia | 1 | OFF (verify) |
| en-PH | Philippines | 1 | OFF (verify) |
| en-GH | Ghana | 3 | OFF (verify) |
| hy-AM | Armenia | 3 | OFF (verify) |

**Excluded from command routing:** `vi-VN / Vietcombank`

**Total command-capable scope: 9 locales / 13 banks**

---

# Expansion Criteria

A new locale is added only if:
1. Full SMS command exists, **or** full one-line USSD template exists
2. At least one major national bank or licensed mobile money operator supports it
3. Template is manually verified or sourced from official bank documentation
