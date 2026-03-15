# Bank Limits & Transfer Rules — Official Audit

> Status: `FUTURE`
> Updated: `2026-03-14`
> Purpose: сверка лимитов, комиссий и правил перевода по официальным публичным источникам банков / кошельков для последующего обновления инфопанели и `sms_banks.json`

## 1. Scope

Документ фиксирует только:
- официально опубликованные лимиты/комиссии/правила;
- публично подтвержденные каналы перевода (`SMS`, `USSD`, `app/web`, `parser-only`);
- случаи, где банк не публикует данные для нужного нам канала и нужна ручная верификация.

Не включается:
- пользовательский опыт без официального подтверждения;
- старые цифры без действующего источника;
- догадки о тарифах и лимитах.

## 2. Decision Rule For Info Panel

Для инфопанели допускаются только три статуса:
- `verified_public` — можно обновлять панель по официальному источнику;
- `limited_public` — источник есть, но не для нашего exact канала; можно показывать только с оговоркой;
- `manual_verification_required` — публичной официальной информации для канала недостаточно.

## 3. Audit Table

| Bank ID | Bank | Channel Status | Official Status | What can be safely shown in info panel | Official Sources |
|---|---|---|---|---|---|
| `sberbank_ru` | Sberbank | SMS historical / modern app-first | `limited_public` | Старые SMS-лимиты не подтверждены актуальной публичной страницей; безопаснее держать только `manual verification` до нового official source. | Нужен повторный официальный источник от Сбера по `900`; текущий corpus в проекте требует re-check. |
| `tbank_ru` | T-Bank | app/web transfers, no SMS transfer command | `verified_public` | Переводы по номеру телефона: до `1,000,000 RUB` за перевод, до `30` переводов/сутки; бесплатно до `20,000 RUB` в месяц без подписки, далее условия зависят от тарифа. | [T-Bank phone transfer](https://www.tbank.ru/bank/help/payments/transfers/russia/phone/), [T-Bank card transfer](https://www.tbank.ru/bank/help/payments/transfers/russia/c2c/), [T-Bank notifications](https://www.tbank.ru/bank/help/debit-cards/tinkoff-black/protect-card/notifications/) |
| `vtb_ru` | VTB | app/web / SBP / cross-border phone transfer | `verified_public` | Для переводов по номеру телефона из публичных разделов ВТБ подтверждается лимит до `1,000,000 RUB` в день и комиссии от `0.5%` для части направлений; SMS transfer channel не подтвержден. | [VTB transfers to Kazakhstan](https://www.vtb.ru/personal/platezhi-i-perevody/perevody-v-kazahstan/), [VTB money transfer](https://www.vtb.ru/personal/platezhi-i-perevody/money-transfer/), [VTB contacts](https://www.vtb.ru/about/contacts/) |
| `alfabank_ru` | Alfa-Bank | app/web / SBP, no SMS transfer command found | `verified_public` | Переводы по номеру телефона: бесплатно себе до `30 million RUB/month`; другому человеку до `100,000 RUB/month`, далее `0.5%`, max `1,500 RUB`. | [Alfa card help](https://alfabank.ru/help/articles/debit-cards/platezhnye-sistemy-bankovskih-kart/), [Alfa Click help](https://click.alfabank.ru/cs/groups/public/documents/document/alfa_help02_05.html) |
| `gtbank_ng` | GTBank | USSD `*737#` | `limited_public` | `*737*1*Amount*Account#` и `*737*2*Amount*Account#`; feature page дает `up to N1,000,000` с разделением по аутентификации, но старый FAQ все еще содержит `N200,000/day`. В инфопанели безопасно показывать обе цифры как конфликт официальных источников, а не одну как абсолютную. | [GTBank 737 FAQ](https://737.gtbank.com/faqs), [GTBank 737 features](https://737.gtbank.com/features), [GTBank 737 page](https://www.gtbank.com/personal-banking/services/e-banking/bank-737) |
| `firstbank_ng` | FirstBank Nigeria | USSD `*894#` | `limited_public` | Официально подтвержден канал `*894#`; публично найденный лимит `N100,000/day` опирается на официальный банк-пост/переиздание, но не на свежий dedicated limits page. Панель можно показывать только с пометкой `needs refresh`. | [FirstBank *894 article](https://www.firstbanknigeria.com/doing-more-beyond-lockdown-with-first-banks-magic-service-code/), [FirstBank products](https://www.firstbanknigeria.com/personal/our-products/) |
| `zenith_ng` | Zenith Bank | USSD `*966#` | `verified_public` | Cumulative transfer limit `N100,000/day`; airtime top-up `N3,000/day`; регистрация по AlertZ number + debit card + PIN. | [Zenith *966# FAQ](https://www.zenithbank.com/personal-banking/ways-to-bank/ussd-banking-star966/) |
| `uba_ng` | UBA | USSD `*919#` | `verified_public` | По `PIN` / `Secure Pass`: `N20,000` per transaction, `N100,000/day`; при `Secure Pass and Indemnity`: `N500,000` per transaction, `N1,000,000/day`; charges по бэндам опубликованы. | [UBA *919#](https://www.ubagroup.com/nigeria/personal-banking/digital-banking/919-ussd-banking/) |
| `access_ng` | Access Bank | USSD `*901#` / wallet / mobile banking | `verified_public` | Для `Access Money` USSD: `N20,000` single transaction; daily cumulative `N50,000 / N200,000 / N500,000` по tier. Для mobile banking EFT: до `N2,000,000` в четырех траншах по `N500,000`. Charges по `*901#` опубликованы отдельно. | [Access Money Account](https://www.accessbankplc.com/personal/savings-investing/access-money-account), [Access Rates Guide](https://www.accessbankplc.com/Rates-Guide/), [Access EFT FAQ](https://www.accessbankplc.com/help/frequently-asked-questions/electronic-funds-transfer) |
| `sbi_in` | State Bank of India | SMS IMPS + USSD + app | `limited_public` | Безопасно показывать только app/web IMPS `up to ₹5 lakh`; exact public figures для legacy SMS / USSD во время аудита не подтверждены отдельной свежей official page. | [SBI Contact Centre](https://sbi.co.in/web/customer-care/contact-centre), [SBI FAQ on e-mandate](https://sbi.co.in/web/personal-banking/faq-on-e-mandate-on-debit-cards) |
| `axisbank_in` | Axis Bank | IMPS app/web | `verified_public` | IMPS up to `INR 5 lakh` per transaction, 24x7; app/web channel подтвержден. SMS transfer channel не подтвержден. | [Axis IMPS](https://www.axisbank.com/bank-smart/internet-banking/transfer-funds/immediate-payment) |
| `hdfcbank_in` | HDFC Bank | IMPS app/web/mobile | `verified_public` | IMPS using account+IFSC: up to `INR 5 lakh` per transaction; via MMID on NetBanking/MobileBanking: `INR 5,000/day`; charges currently `INR 2.50 / 5 / 15` depending on band (excluding GST). | [HDFC IMPS limits](https://www.hdfcbank.com/personal/pay/money-transfer/immediate-payment-service-imps/limits), [HDFC fees](https://www.hdfcbank.com/personal/pay/money-transfer/immediate-payment-service-imps/fees-and-charges), [HDFC FAQs](https://www.hdfcbank.com/personal/pay/money-transfer/immediate-payment-service-imps/faqs) |
| `icicibank_in` | ICICI Bank | IMPS iMobile / Internet Banking | `verified_public` | IMPS account+IFSC: up to `INR 5 lakh` per transaction; mobile+MMID: up to `INR 10,000`; up to `INR 20 lakh/day` through iMobile. Published IMPS charges depend on amount band. | [ICICI NEFT/RTGS/IMPS](https://www.icicibank.com/personal-banking/online-services/funds-transfer/neft-rtgs) |
| `ubl_pk` | UBL | SMS alerts yes; direct transfer panel unclear | `limited_public` | Publicly confirmed SMS alerts and some remittance/card limits, but no clean public SMS-transfer rule set for our channel. Info panel should not claim a verified direct SMS transfer limit yet. | [UBL Pardes Account](https://ubldigital.com/NRP-Services/Remittances/UBLPardesAccount) |
| `bkash_bd` | bKash | USSD `*247#` / app | `verified_public` | `Send Money` through app / `*247#`; general send money limits published on official limits pages. Exact SMS confirmations and PRA flow are also official. | [bKash limits](https://www.bkash.com/index.php/en/help/limits), [bKash Send Money](https://www.bkash.com/en/products-services/send-money), [bKash PRA](https://www.bkash.com/en/page/personal-retail-account) |
| `mandiri_id` | Bank Mandiri | SMS service exists; modern transfer limits are app-first | `limited_public` | Official SMS FAQ exists, but current transfer limits are clearly published for Livin' by Mandiri, not for typed SMS command channel. Safe panel option: show `SMS exists / limits not publicly confirmed for SMS`, optionally show Livin' limits separately as app channel. | [Mandiri SMS FAQ](https://www.bankmandiri.co.id/en/faq-mandiri-sms), [Mandiri Livin' limits](https://www.bankmandiri.co.id/en/web/guest/livin/edukasi/limit-transfer-livin) |
| `gcash_ph` | GCash | app wallet, not SMS transfer | `verified_public` | Official wallet/outgoing limits published; SMS advisories are no longer primary channel. Safe panel should show wallet/send limits, not SMS command rules. | [GCash wallet limits](https://help.gcash.com/hc/en-us/articles/360021112894-What-are-my-GCash-wallet-and-transaction-limits), [GCash Express Send limit](https://help.gcash.com/hc/en-us/articles/44143833564185-What-is-the-GCash-Express-Send-Transaction-Limit), [GCash card limits](https://help.gcash.com/hc/en-us/articles/30286810141977-GCash-Card-fees-and-transaction-limits) |
| `vietcombank_vn` | Vietcombank | SMS Banking query/alerts only | `verified_public` | SMS Banking to `6167` supports inquiry / alerts only; transfer command must remain excluded. Can show service fee and parser-only note, not transfer limits. | [Vietcombank SMS Banking](https://www.vietcombank.com.vn/en/Personal/SPDV/Ngan-hang-so/SMS-Banking), [VCB-SMSB@nking](https://portal.vietcombank.com.vn/en-Us/Corporate/SMEs/E-Banking/Pages/vcb-smsb%40nking.aspx) |
| `vodafone_gh` | Telecel Cash | wallet / mobile money | `limited_public` | Official customer wallet caps published: daily transaction limits and balance caps by KYC tier. Good enough for wallet panel, but not enough to claim a verified one-line transfer template yet. | [Telecel wallet caps](https://support.telecel.com.gh/h/updated-customer-wallet-caps/) |
| `vivacell_am` | VivaCell-MTS (MobiDram) | parser-only / USSD unclear | `manual_verification_required` | Публичного официального current source по transfer limits/rules для нужного канала не найдено. В инфопанели лучше не показывать числовые лимиты до ручной верификации. | Public official limit source not found on `viva.am` / `mobidram.viva.am` during audit. |

## 4. Immediate Data Decisions

Что уже синхронизировано в `assets/data/sms_banks.json`:
- `tbank_ru`
- `vtb_ru`
- `alfabank_ru`
- `gtbank_ng`
- `firstbank_ng`
- `zenith_ng`
- `uba_ng`
- `access_ng`
- `sbi_in`
- `axisbank_in`
- `hdfcbank_in`
- `icicibank_in`
- `ubl_pk`
- `bkash_bd`
- `mandiri_id`
- `gcash_ph`
- `vietcombank_vn`
- `vodafone_gh`
- `vivacell_am`

Что по-прежнему нужно держать как `limited_public` / `manual verification` на уровне exact канала:
- `sberbank_ru`
- `gtbank_ng`
- `firstbank_ng`
- `sbi_in`
- `ubl_pk`
- `mandiri_id`
- `vodafone_gh`

## 5. Recommended Next Step For Data Layer

Сделано в data-layer:
1. в `assets/data/sms_banks.json` введены поля `official_sources`, `official_status`, `panel_channel`, `last_verified_at`;
2. лимиты и правила по возможности разделены по фактическому каналу (`SMS`, `USSD`, `app/web`, `wallet`, `parser-only`);
3. speculative значения заменены на official app/wallet limits или понижены до warning/manual-verification формулировок;
4. `Mandiri` исправлен на `83355`; `Vietcombank` и `Telecel Cash` зафиксированы как non-routing informational entries.

Что осталось следующим шагом:
1. научить UI инфопанели отображать `official_status` / `panel_channel`, а не только сырые `transfer_limits`;
2. для `limited_public` выводить явное предупреждение `Official public limits for this exact channel require manual verification`;
3. отдельно пройти hardcoded `Sberbank` page, потому что она не берёт данные из `sms_banks.json` и требует отдельного ручного re-check.
