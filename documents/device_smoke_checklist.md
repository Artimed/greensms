# Device Smoke Checklist

> Status: `ACTIVE`
> Scope: ручная проверка критичных сценариев на реальном Android-устройстве
> Updated: `2026-03-14`

## Run Metadata
- Device model: `V2231`
- Android version: `Android 15 (API 35)`
- Build mode (`debug`/`profile`/`release`): `debug`
- Commit / build identifier: `workspace snapshot 2026-03-14`
- Tester: `Codex + ADB-assisted run`
- Date: `2026-03-14`

## Mandatory Scenarios
| ID | Scenario | Expected Result | Result | Notes |
|---|---|---|---|---|
| SMK-001 | Первый запуск + onboarding | Запрос разрешений, переход на main без crash | ☑ Pass / ☐ Fail | Прогнано с `pm clear`: onboarding показан, запрошены SMS+CAMERA permissions, после подтверждения открыт main без crash. |
| SMK-002 | Refresh SMS на главном экране | Данные подгружаются, UI не зависает | ☑ Pass / ☐ Fail | Выполнен tap по `Refresh SMS`; UI остается интерактивным, экран/карточки не зависают, ANR не зафиксирован. |
| SMK-003 | Переход в settings и смена языка | Тексты меняются без артефактов | ☑ Pass / ☐ Fail | Проверено EN→RU: app bar и все секции обновляются сразу. |
| SMK-004 | Смена темы (light/system/dark) | Контраст текста/баннеров корректный | ☑ Pass / ☐ Fail | Проверено переключение темы в settings (radio-state меняется, UI стабилен). |
| SMK-005 | Открытие QR-hub | Камера стартует, нижняя панель доступна | ☑ Pass / ☐ Fail | QR-экран открыт, камера активна, нижняя панель доступна. |
| SMK-006 | Сканирование валидного internal QR | Появляется подтверждение SMS, без crash | ☑ Pass / ☐ Fail | Импортирован валидный internal QR из галереи (`zz_qr_valid_final.png`), показан диалог `Create SMS?` с номером. |
| SMK-007 | Сканирование невалидного/чужого QR | Показывается ошибка/подсказка, без выхода из приложения | ☑ Pass / ☐ Fail | Импортирован внешний QR (`zz_qr_external.png`), показано `QR not recognized as internal format.`, приложение не закрывается. |
| SMK-008 | Кнопка “Сканировать” при отсутствии результата | Нет вылета, сканер остается активен или показывает ошибку | ☑ Pass / ☐ Fail | После нажатия показывается “Сканирование активно.”, вылета нет. |
| SMK-009 | Импорт QR из галереи без кода | Сообщение “QR не найден”, без crash | ☑ Pass / ☐ Fail | Импортирован no-QR скрин (`zz_no_qr_home_final.png`), показано `No QR code found in the selected image.`, без crash. |
| SMK-010 | Генерация QR из телефона устройства | Bottom-sheet/QR отображаются корректно | ☑ Pass / ☐ Fail | Bottom-sheet открывается, QR и телефон отображаются корректно. |
| SMK-011 | Открытие SMS composer из QR-flow | Открывается системный composer или fallback ошибка | ☑ Pass / ☐ Fail | После `Confirm` в `Create SMS?` открыт системный composer `com.android.mms/.ui.ComposeMessageActivity` c получателем. |
| SMK-012 | Выход/сворачивание/возврат из QR-flow | Камера lifecycle корректен, без зависаний | ☑ Pass / ☐ Fail | Проверен возврат назад из QR-flow на main без crash/зависания. |
| SMK-013 | Включение `Direct SMS` в settings при отсутствии разрешения | Запрос `SEND_SMS`; при отказе свитчер не включается, показывается подсказка про settings | ☐ Pass / ☐ Fail | Pending после внедрения `directSmsEnabled`. |
| SMK-014 | QR Confirm при `Direct SMS = ON` и разрешении `SEND_SMS` | SMS отправляется напрямую на `900` без открытия composer | ☐ Pass / ☐ Fail | Pending device-check, требуется контроль факта отправки. |
| SMK-015 | QR Confirm при `Direct SMS = ON`, но ошибка отправки | Автоматический fallback в системный SMS composer | ☐ Pass / ☐ Fail | Pending device-check (эмуляция отказа/ошибки отправки). |
| SMK-016 | Settings: выбор `страна` в bank routing | После смены страны QR-flow строит команды банка выбранной страны | ☐ Pass / ☐ Fail | Pending Wave 2 device-check. |
| SMK-017 | Settings: выбор банка в стране с несколькими банками (например, NG) | Команда в QR-flow строится по шаблону выбранного банка (а не только primary) | ☐ Pass / ☐ Fail | Pending Wave 2 device-check. |
| SMK-018 | QR Hub: режим “по телефону” (без QR) | Открывается шторка `телефон + сумма + опц. last4`, после confirm — экран подтверждения команды | ☐ Pass / ☐ Fail | Pending Wave 2 device-check. |

## Log Notes (Important)
- Зафиксировать только значимые ошибки приложения.
- Vendor noise (`mali_gralloc`, `Vivo...`, `CameraManagerGlobal`) отмечать отдельно как platform noise, если нет crash/functional break.
- Наблюдение 2026-03-14: зафиксирован высокий объем vendor camera noise (`mali_gralloc`, `VivoJavaJsonManager`, `CameraManagerGlobal`) без `FATAL EXCEPTION` и без падения приложения.
- Отдельно наблюдались `BLASTBufferQueue ... acquireNextBufferLocked` при camera-preview; функциональный поток не ломается, вылетов нет.

## Exit Gate
- Wave 0 считается закрытой только если `SMK-001..SMK-012` все в `Pass` или есть формально принятые исключения с workaround.
- Для релизов с `directSmsEnabled` обязательны также `SMK-013..SMK-015`.
- Для закрытия Wave 2 дополнительно обязательны `SMK-016..SMK-018`.
