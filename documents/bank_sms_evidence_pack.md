# Bank SMS Evidence Pack

> Status: `FUTURE`
> Updated: `2026-03-14`
> Purpose: внешний evidence pack для независимой сверки SMS-примеров перед обновлением parser и `sms_banks.json`

## 1. Method

Для каждого банка фиксируется:
- `service evidence`: есть ли внешний источник, подтверждающий наличие SMS-уведомлений;
- `exact external sample`: опубликован ли точный текст SMS или устойчивый публичный образец;
- `channel drift`: не уехал ли банк из SMS в push / app inbox / WhatsApp;
- `confidence`:
  - `high` — официальный сайт/FAQ/банк;
  - `medium` — профильный источник или устойчивый публичный образец;
  - `low` — community / complaint / пользовательский источник.

Важно:
- не для каждого банка реально найти `4–6` точных публичных SMS-текстов даже при живом сервисе;
- по части банков доступны только подтверждения сервиса, а не exact message bodies;
- для parser bank-profile должен опираться либо на `high`, либо на повторяющиеся `medium/low` шаблоны;
- единичные complaint-сообщения можно использовать только как `provisional`, а не как окончательный контракт формата.

## 2. Coverage Snapshot

| Bank ID | Bank | Service Evidence | Exact External Samples | Notes |
|---|---|---:|---:|---|
| `sberbank_ru` | Sberbank | partial | 0 | Нужен отдельный русский community/help corpus. |
| `tbank_ru` | T-Bank | partial | 0 | Сервис уведомлений известен, но public transaction SMS corpus слабый. |
| `vtb_ru` | VTB | yes | 0 | Официально подтверждены operation notifications, без exact body. |
| `alfabank_ru` | Alfa-Bank | partial | 0 | Найдены общие упоминания уведомлений, без transaction body. |
| `gtbank_ng` | GTBank | yes | 2 | Есть structured debit samples вне проекта; пригодны для provisional parser rules. |
| `firstbank_ng` | FirstBank Nigeria | yes | 2 | Есть public credit/debit sample formats. |
| `zenith_ng` | Zenith Bank | yes | 2 | Есть public credit/debit sample formats. |
| `uba_ng` | UBA | yes | 3 | Есть format evidence + community debit/credit bodies. |
| `access_ng` | Access Bank | yes | 4 | Есть несколько debit/credit/public complaint samples. |
| `sbi_in` | State Bank of India | yes | 3 | 1 официальный sample + 2 public complaint transaction alerts. |
| `axisbank_in` | Axis Bank | yes | 4 | Exact samples найдены в complaint/community источниках; сервис подтвержден официально. |
| `hdfcbank_in` | HDFC Bank | yes | 3 | Есть debit/card-spend samples + официальный InstaAlert. |
| `icicibank_in` | ICICI Bank | yes | 1 | Exact external transaction body найден ограниченно. |
| `ubl_pk` | UBL | yes | 0 | Официально подтверждены alerts, exact transaction body не найден. |
| `bkash_bd` | bKash | yes | 3 | Есть официальный exact flow для send/receive. |
| `mandiri_id` | Bank Mandiri | yes | 0 | Channel drift: часть уведомлений переведена в WhatsApp / альтернативные каналы. |
| `gcash_ph` | GCash | yes | 0 | Внешние источники показывают уход от SMS advisories. |
| `vietcombank_vn` | Vietcombank | yes | 0 | SMS Banking есть, transfer SMS command отсутствует; parser-only. |
| `vodafone_gh` | Telecel Cash / Vodafone Ghana | partial | 0 | Нужен отдельный пакет источников по wallet/SMS уведомлениям. |
| `vivacell_am` | VivaCell-MTS (MobiDram) | partial | 0 | Нужны локальные help/community real SMS bodies. |

## 3. Exact Samples Collected

### 3.1 SBI (`sbi_in`)
Sources:
- [SBI FAQ on E-Mandate on Debit Cards](https://sbi.co.in/web/personal-banking/faq-on-e-mandate-on-debit-cards)
- [Complaint sample 1](https://consumercomplaintscourt.com/sbi-auto-debit-on-sbi-account/)
- [Complaint sample 2](https://consumercomplaintscourt.com/two-transactions-to-razorpay-without-my-permission/)

Collected external samples:
1. `Dear Customer, ... e-mandate ... payment for Rs ... is due ... and will be processed through SBI Debit Card ending xxxx.`
2. `Dear Customer, your a/c no. XXXXXXXX has a debit by transfer of Rs ... on date ...`
3. `INR ... debited from A/c No XX... towards ... Ref No ...`

Confidence:
- `high` for sample 1
- `low` for samples 2-3

Usefulness for parser:
- useful for `mandate_due`, `debit`, `autopay`;
- transaction corpus still needs more official or repeated sources.

### 3.2 bKash (`bkash_bd`)
Source:
- [bKash Personal Retail Account](https://www.bkash.com/en/page/personal-retail-account)

Collected exact samples:
1. `Send Money Tk <amount> to <payee_Account_no> successful. Ref <reference>. Fee Tk <fee>. Balance Tk <curr_bal>. TrxID <trxRef>`
2. `Send Money Tk <amount> to <payee_Account_no> successful. Ref <reference>. Fee Tk <fee>. Balance Tk <curr_bal>. TrxID <trxRef> at <DD/MM/YYYY hh:mm>`
3. `You have received Tk <amount> from <payer_Account_no>. Ref <reference>. Fee Tk <fee>. Balance Tk <curr_bal>. TrxID <trxRef> at <DD/MM/YYYY hh:mm>`

Confidence: `high`

Usefulness for parser:
- directly usable;
- should be part of bank-specific regression set.

### 3.3 Axis Bank (`axisbank_in`)
Sources:
- [Axis Bank alerts reference](https://www.axisbank.com/retail/accounts/salary-account/defence-salary-account)
- [Complaint sample 1](https://consumercomplaintscourt.com/600-debited-from-my-axis-bank-account-without-my-permission/)
- [Complaint sample 2](https://consumercomplaintscourt.com/unauthorised-transaction-from-axis-bank-3/)
- [Complaint sample 3](https://consumercomplaintscourt.com/for-upcoming-mandate-due-on-06-04-24-your-a-c-will-be-debited-with-inr-149-00-towards-novi-digital-entertainment-private-ltd-for-merchantmandate-null-axis-bank/)
- [Complaint sample 4](https://consumercomplaintscourt.com/regarding-money-deducted-without-my-consent/)

Collected external samples:
1. `Your A/c ... is debited with Rs ... Avbl Bal is Rs ... - Axis Bank`
2. `Debit / INR ... / A/c no. XX... / ... / Bal INR ...`
3. `For upcoming mandate due on ... your A/c will be debited with INR ... - Axis Bank`
4. `Debit INR ... / Axis Bank A/c XX... / ACH-DR-...`

Confidence:
- `high` for service evidence
- `low` for exact bodies

Usefulness for parser:
- useful for `debit`, `autopay`, `mandate_due`;
- confirms masked account, `Bal`, and date/time style variants.

### 3.4 HDFC Bank (`hdfcbank_in`)
Sources:
- [HDFC InstaAlert](https://v.hdfcbank.com/htdocs/mobile/instaAlert.html)
- [Complaint sample 1](https://consumercomplaintscourt.com/fraud-2582/)
- [Complaint sample 2](https://consumercomplaintscourt.com/amount-debited-but-status-showing-as-pending-and-amount-not-credited-to-beneficiary/)
- [Complaint sample 3](https://consumercomplaintscourt.com/unauthorised-transaction-of-rs-1499-made-by-amazon-india-cybs-si-from-my-hdfc-bank-debit-card/)

Collected external samples:
1. `HDFC Bank: Rs ... debited from a/c **.... to VPA ... (UPI Ref No ...)`
2. `HDFC Bank: Rs ... debited from a/c **.... to VPA ...`
3. `Rs.... spent on HDFC Bank Card x.... Avl bal: ...`

Confidence:
- `high` for service evidence
- `low` for exact bodies

Usefulness for parser:
- useful for `upi_debit` and `card_spend`;
- suggests separate HDFC account-vs-card profiles or sub-patterns.

### 3.5 ICICI Bank (`icicibank_in`)
Sources:
- [ICICI SMS Alerts & Requests](https://www.icicibank.com/mobile-banking/alerts.page)
- [Complaint sample](https://consumercomplaintscourt.com/your-account-has-been-successfully-debited-with-rs-149-00-on-10-mar-25-towards-nov-digital-ent-for-create-mandate-autopay-rrn-100146771939-icici-bank/)

Collected external sample:
1. `Your account has been successfully debited with Rs ... towards ... AutoPay, RRN ... - ICICI Bank`

Confidence:
- `high` for service evidence
- `low` for exact body

Usefulness for parser:
- useful for `autopay_debit`;
- still not enough to lock a full retail debit/credit grammar.

### 3.6 GTBank (`gtbank_ng`)
Sources:
- [GTBank GeNS](https://www.gtbank.com/business-banking/services/e-business-services/gens)
- [GTBank debit alert format](https://smartsmssolutions.com/blog/81-tutorial/1415-gtbank-debit-alert-format)
- [Community sample](https://twstalker.com/goziephillips)

Collected external samples:
1. `Acct: ... / Amt: NGN..., DR / Desc: ... / Avail Bal: NGN... / Date: ...`
2. `Acct: ... Amt: NGN... DR Desc: ... Avail Bal: NGN... Date: ...`

Confidence:
- `high` for service evidence
- `medium` for structured sample
- `low` for community body

Usefulness for parser:
- directly useful for `debit` extraction;
- confirms stable ordering `Acct -> Amt -> Desc -> Avail Bal -> Date`.

### 3.7 Access Bank (`access_ng`)
Sources:
- [Access Bank SMS alert help](https://freshworksdrc.accessbankplc.com/support/solutions/articles/501000246638-sms-alert)
- [Access debit alert format](https://smartsmssolutions.com/blog/81-tutorial/1412-access-bank-debit-alert-format)
- [Debit alert anatomy](https://smartsmssolutions.com/blog/81-tutorial/1411-what-does-a-debit-alert-message-look-like)
- [Credit sample](https://www.nigeriastartupact.ng/njfp-stipend-increases-to-n150000-as-october-payments-begin/)
- [Community sample](https://www.nairaland.com/7633522/bank-account-opened-without-consent)

Collected external samples:
1. `Debit / Amt: NGN... / Acc:... / Desc:... / Time:... / Avail Bal: ... / Total: ...`
2. `Debit / Amt: NGN... / Acct:... / Desc: Transfer to ... / Date: ... / Avail Bal: ...`
3. `Credit / Amt: NGN... / Acc:... / Desc:... / Date: ... / Avail Bal: ...`
4. `Debit / Amt: NGN... / Acc:... / Desc:... / Time:... / Avail Bal:... / Total:...`

Confidence:
- `high` for service evidence
- `medium` for structured samples
- `low` for complaint/community bodies

Usefulness for parser:
- strong evidence for `debit` and `credit`;
- good candidate for bank-specific regression pack even before official screenshots appear.

### 3.8 FirstBank Nigeria (`firstbank_ng`)
Sources:
- [FirstBank FirstAlert](https://www.firstbanknigeria.com/home/individual-banking/ways-to-bank/firstalert/)
- [Credit alert sample](https://smartsmssolutions.com/blog/81-tutorial/1353-first-bank-credit-alert-sample)
- [Debit alert format](https://smartsmssolutions.com/blog/81-tutorial/1414-firstbank-debit-alert-format)

Collected external samples:
1. `Your Acct ... has been credited with NGN... ... Bal:...CR`
2. `Debit ... / Amt: NGN... / Date: ... / Desc: ...`

Confidence:
- `high` for service evidence
- `medium` for exact bodies

Usefulness for parser:
- directly useful for `credit` and `debit`;
- useful for `Bal:...CR` suffix handling.

### 3.9 Zenith Bank (`zenith_ng`)
Sources:
- [Zenith AlertZ](https://www.zenithbank.com/personal-banking/alertz/)
- [Credit alert sample](https://smartsmssolutions.com/blog/81-tutorial/1382-things-to-look-for-in-a-zenith-bank-credit-alert-that-helps-you-know-if-it-is-a-fake-alert)
- [Debit alert format](https://smartsmssolutions.com/blog/81-tutorial/1406-zenith-bank-debit-alert-format)

Collected external samples:
1. `Acct:... / DT: ... / ... / CR Amt:... / Bal:... / REF:...`
2. `Acct:... / DT: ... / ... / DR Amt:... / Bal:... / REF:...`

Confidence:
- `high` for service evidence
- `medium` for exact bodies

Usefulness for parser:
- directly useful for `CR Amt` and `DR Amt`;
- confirms `REF` as an extractable field.

### 3.10 UBA (`uba_ng`)
Sources:
- [UBA Notification Services](https://www.ubagroup.com/nigeria/personal-banking/digital-banking/notification-services/)
- [UBA credit alert format](https://smartsmssolutions.com/blog/81-tutorial/1351-uba-bank-credit-alert-sample)
- [Community sample 1](https://www.nairaland.com/8564754/careful-fake-leo-uba-online)
- [Community sample 2](https://www.nairaland.com/6588412/im-suicidal-bet9ja-hacked-account)
- [Community sample 3](https://www.nairaland.com/2685777/ubth-security-ubth-cmd-pay)

Collected external samples:
1. `Txn:DR / Ac:... / Amt:NGN ... / Des:... / Date:... / Bal:NGN ...`
2. `Txn: Debit / Ac:... / Amt:NGN ... / Des:... / Date:... / Bal:NGN ...`
3. `Alert: credit / Act:... / Amt:... / Rmks:... / Bal:...`

Confidence:
- `high` for service evidence
- `low` for exact bodies

Usefulness for parser:
- enough to justify provisional `Txn/Ac/Amt/Des/Date/Bal` extraction;
- still needs a broader pool before high-confidence regression locking.

## 4. Service Confirmed, Exact Samples Still Missing Or Weak

### 4.1 VTB (`vtb_ru`)
Sources:
- [VTB operation notifications](https://www.vtb.ru/personal/online-servisy/sms-opovesheniya/)

What is confirmed:
- VTB officially provides operation notifications for cards and accounts;
- SMS/push notifications are configurable.

Gap:
- no public exact debit/credit SMS bodies found yet.

### 4.2 UBL (`ubl_pk`)
Sources:
- [UBL SMS Alert Service](https://www.ubldigital.com/Banking/UBL-Ameen/Self-Service-Banking/SMSAlertService)
- [UBL Go Green SMS Alerts](https://www.ubldigital.com/UBL-Digital/UBL-Go-Green-Product/UBL-Go-Green-SMS-Alert-service)

What is confirmed:
- UBL sends real-time debit and credit alerts;
- alert service is officially documented.

Gap:
- no public exact debit/credit SMS body found yet.

### 4.3 Bank Mandiri (`mandiri_id`)
Sources:
- [Mandiri SMS FAQ](https://www.bankmandiri.co.id/en/faq-mandiri-sms)
- [Mandiri two-way notification](https://www.bankmandiri.co.id/en/two-way-notification-transaksi-online)
- [Mandiri card notification channel change](https://www.mandirikartukredit.com/informasi-perubahan-channel-notifikasi-transaksi-mandiri-kartu-kredit)

What is confirmed:
- Mandiri SMS service exists historically and for command flows;
- part of transaction notifications have moved to WhatsApp or alternative channels.

Gap:
- exact current SMS transaction bodies are not publicly stable;
- parser rules should remain provisional until device-captured evidence appears.

### 4.4 GCash (`gcash_ph`)
Sources:
- [GCash no longer sends SMS advisories](https://www.philstarlife.com/geeky/601044-gcash-no-more-sms-advisories)

What is confirmed:
- older SMS advisory model changed materially;
- current evidence suggests push/app inbox replaced many SMS notices.

Gap:
- exact current SMS transaction texts require manual capture on device or updated official guidance.

### 4.5 Vietcombank (`vietcombank_vn`)
Sources:
- [Vietcombank SMS Banking](https://vietcombank.com.vn/vi-VN/KHCN/SPDV/Ngan-hang-so/SMS-Banking)
- [VCB SMS Banking registration guide PDF](https://www.vietcombank.com.vn/-/media/Project/VCB-Sites/VCB/KHCN/San-pham-Dich-vu/Ngan-hang-so/Tai-lieu-Ngan-hang-so/VCB-SMS-Banking/Vietcombank_Huong-dan-dang-ky-SMS-Banking.pdf)

What is confirmed:
- SMS Banking exists for notifications and balance/inquiry flows;
- one-line transfer SMS command is not supported.

Gap:
- exact public notification texts are limited;
- command-routing remains excluded.

### 4.6 Telecel Cash / Vodafone Ghana (`vodafone_gh`)
Sources:
- [Telecel Cash registration help](https://asetenapa.com/register-telecel-cash/)
- [Sender reference message launch coverage](https://www.telecompaper.com/news/vodafone-ghana-launches-sender-reference-message-option-for-mobile-money--1292376)

What is confirmed:
- wallet users receive SMS confirmations in some flows;
- balance inquiry and registration flows mention SMS response or confirmation.

Gap:
- no stable public transaction-body corpus found;
- still not enough to mark the bank as parser-ready.

### 4.7 VivaCell / MobiDram (`vivacell_am`)
Sources:
- [MobiDram promo note](https://mobidram.viva.am/en/news/2022/08/18/get-10-of-the-your-paid-sum-for-payments-via-mobidram-using-my-viva-mts-app)

What is confirmed:
- MobiDram sends SMS notifications in at least some payment/cashback flows.

Gap:
- no public exact debit/credit wallet notification pool found;
- still needs device-captured evidence or local help-source collection.

### 4.8 Russian secondary banks
Banks:
- `sberbank_ru`
- `tbank_ru`
- `alfabank_ru`

What is confirmed:
- notification services exist or are very likely active;
- public exact transaction-body corpus remains poor compared with IN/NG/BD sources.

Gap:
- need Russian-language community captures or official screenshots before parser-specific support can be raised above generic/fallback.

## 5. Immediate Next Collection Targets

Priority order for exact sample harvesting:
1. `ubl_pk`
2. `mandiri_id`
3. `gcash_ph`
4. `sberbank_ru`
5. `tbank_ru`
6. `alfabank_ru`
7. `vodafone_gh`
8. `vivacell_am`
9. `vtb_ru`

Recommended acquisition channels:
- official FAQ/help PDFs;
- public complaint portals or bank knowledge bases;
- archived screenshots / community forum posts;
- manual device captures from real users.

## 6. Decision For Parser Work

До пополнения exact external sample pool:
- parser можно усиливать только по тем банкам, где уже есть устойчивые реальные шаблоны и тесты;
- для остальных банков новые regex должны маркироваться как `provisional`;
- `bKash` и `SBI` уже имеют официальный внешний sample material, пригодный для расширения test set;
- `GTBank`, `Access`, `FirstBank`, `Zenith`, `UBA`, `Axis`, `HDFC`, `ICICI` уже имеют внешний sample material, но часть корпуса имеет `low confidence` и требует cross-check по повторяемости;
- `Vietcombank` остается `parser-only / command-excluded`.
