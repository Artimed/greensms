# Documentation Registry

> Status: `ACTIVE`
> Updated: `2026-03-15`

## Статусы
- `ACTIVE` — обязательный источник требований. Код меняется только после обновления ACTIVE-документа.
- `FUTURE` — стратегия и данные для следующих волн. Не влияет на код напрямую.
- `ARCHIVE` — исторические снимки, только для справки.

## Правило конфликта
ACTIVE > FUTURE. Перед изменением кода — сначала обновить соответствующий ACTIVE-документ.

---

## ACTIVE документы (Source of Truth для MVP)

| Файл | Роль |
|------|------|
| `master_development_process_and_waves.md` | Главный: процесс, волны, decision log |
| `tasks.md` | Рабочий бэклог, статусы задач по волнам |
| `active_constraints_mvp.md` | Архитектурные ограничения (locked) |
| `design_v2_single_page.md` | UX/UI: экраны, QR-flow, сценарии |
| `zelenaya_sms_tz_v1.md` | Функциональные требования MVP |
| `device_smoke_checklist.md` | Ручной smoke-пакет на устройстве |

---

## FUTURE документы (Wave 2+)

| Файл | Волна | Роль |
|------|-------|------|
| `sms_banks.json` | Wave 2 | База банков/шаблонов (v2: 10 локалей, 14 банков) |
| `bank_limits_rules_official_audit.md` | Wave 2 | Официальный аудит лимитов/правил/каналов по банкам для инфопанели и data-layer |
| `bank_sms_evidence_pack.md` | Wave 2 | Внешний evidence-pack по банкам: ссылки, exact samples, confidence, gaps |
| `greensms_supported_locales.md` | Wave 2 | Tier-план локалей и банков с шаблонами |
| `greensms_banks_locales_architecture.md` | Wave 2 | Архитектура: LocaleConfigService, BankRegistryService, CommandBuilderService |
| `sms_parser_architecture.md` | Wave 1–2 | Целевая архитектура parser-слоя: normalizer, detector, bank profiles, fallback |
| `pro_architecture.md` | Wave 3–6 | **ACTIVE** — архитектура Pro: flavors, лицензия, forwarding, FCM, OTA парсер, Supabase |
| `green_sms_pro_and_monetization.md` | — | **ARCHIVE** — заменён на `pro_architecture.md` (устаревшая Ed25519-модель) |

---

## ARCHIVE

| Файл | Причина |
|------|---------|
| `project_review_2026-03-13.md` | Снимок Wave 0; findings перенесены в tasks.md |

---

## Change Control
Любое изменение в ACTIVE-документах должно содержать:
- обновлённую дату в заголовке;
- ссылку на задачу из `tasks.md`.
