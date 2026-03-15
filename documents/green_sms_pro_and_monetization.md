# Green SMS — Pro License & Monetization

> Status: `FUTURE`
> Scope: Wave 3 + Wave 5
> Updated: `2026-03-14`

---

## Model

**Free** — весь основной функционал (SMS, баланс, QR, формирование команд).

**Donate** — добровольная поддержка через сайт (coffee $3 / support $5 / big thanks $10).

**Pro** — `SMS Forwarding Pro`, разовая лицензия на установку (lifetime, не подписка).

---

## Pro Feature — SMS Forwarding

Правила: пользователь задаёт фильтр (отправитель / ключевое слово) + номер назначения.
При получении совпавшего SMS — автоматическая пересылка.

**Pro-gate:** функция недоступна без валидной лицензии.

---

## License Model

Лицензия привязана к `installationId` — UUID, генерируется при первой установке, хранится в `flutter_secure_storage`.

**Тариф:** Forward Pro — 1 device lifetime. (Позже: 3 и 5 устройств = N отдельных license файлов.)

**Файл лицензии** `greensms-license.json`:
```json
{
  "payload": {
    "licenseVersion": 1,
    "appId": "com.green.sms",
    "product": "sms_forwarding_pro",
    "plan": "forward_1_device_lifetime",
    "installationId": "<uuid>",
    "issuedAt": "2026-03-14T12:00:00Z",
    "expiresAt": null
  },
  "signature": "<BASE64_ED25519>"
}
```

**Криптография:** Ed25519. Приватный ключ — на стороне продавца/сайта. Публичный ключ вшит в приложение. Проверка — офлайн, без сервера.

---

## Purchase Flow

1. Пользователь открывает экран Pro → видит `installationId` → копирует
2. Переходит на сайт (`greensms.app/pro`)
3. Вставляет ID → выбирает тариф → оплачивает
4. Получает `greensms-license.json` → импортирует в приложение
5. Приложение проверяет подпись → активирует Pro

**Старт:** ручная выдача лицензий (email / Telegram). Автоматизация — позже.

---

## Pro Screen UI

- Status: Free / Pro
- Installation ID + кнопка Copy
- Import License (file picker)
- Buy Pro → ссылка на сайт
- Support Project → ссылка на донаты
- При активном Pro: Plan: Lifetime, Activated for this installation

---

## Verification Logic (in-app)

1. Читает `payload` и `signature` из файла
2. Проверяет Ed25519-подпись через встроенный публичный ключ
3. Проверяет: `appId`, `product`, `installationId` == текущий, `expiresAt` (если не null)
4. Если всё валидно → Pro активирован

---

## Key Decisions

- Не подписка — lifetime per install (нет облака, нет регулярных расходов у пользователя)
- Не текстовый ключ — license file с подписью (нельзя изменить payload вручную)
- Не IMEI — UUID в secure storage (приватность, Android ограничения)
- При переустановке — перенос через поддержку / перевыдача (предупреждение в UX)
- 3/5 устройств = N отдельных license файлов (проще реализовать)
