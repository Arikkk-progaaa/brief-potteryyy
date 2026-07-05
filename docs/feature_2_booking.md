# Feature 2: Booking — Оформление записи на занятие

> **Дата:** 2026-07-05  
> **Ветка:** `feature/2-booking`

---

## Цель

Реализовать flow бронирования: от выбора слота в расписании до подтверждения записи. Пользователь указывает количество мест, выбирает аренду инвентаря и отправляет запрос в API. В случае успеха — видит экран с деталями брони, в случае ошибки — алерт с описанием проблемы.

## Требования (кратко)

| ID | Требование |
|----|------------|
| US-04 | Клиент записывается на выбранный слот |
| US-05 | Клиент указывает, нужны ли инструменты и фартук напрокат |
| US-06 | Клиент получает подтверждение бронирования |
| EC-05 | Бэкенд вернул ошибку «Нет мест» — показать алерт |
| EC-06 | Бэкенд вернул 500/503 — показать алерт с предложением повторить |
| EC-07 | Двойное нажатие кнопки «Записаться» — блокировка после первого нажатия |
| EC-21 | Прокат инструментов недоступен — свитчер неактивен |

## Реализовано в коде

### 1. BookingViewModel (`lib/viewmodels/booking_viewmodel.dart`)

- Наследует `ChangeNotifier` для реактивного обновления UI
- **Параметры:** `Slot slot`, `String clientId`
- **Состояния формы:**
  - `seats` (int) — количество мест, от 1 до `slot.availableSeats`
  - `needsRental` (bool) — нужна ли аренда инвентаря
  - `maxSeats` / `minSeats` — границы счётчика
- **Состояния отправки:**
  - `isSubmitting` — флаг загрузки
  - `error` — текст ошибки (из `ApiException` или общая)
  - `bookingResult` — успешный `Booking` объект
  - `isSuccess` — true, если бронь создана
- **Методы:**
  - `incrementSeats()` / `decrementSeats()` — с проверкой границ
  - `setSeats(int)` — прямое задание количества
  - `toggleRental(bool)` — переключение аренды
  - `submitBooking()` — вызов `MockApiService.bookSlot()`, обработка `ApiException`
  - `reset()` — сброс формы для повторной попытки

### 2. BookingSheet (`lib/ui/widgets/booking_sheet.dart`)

- **`BookingSheet.show(context, slot)`** — статический метод, открывает `showModalBottomSheet`
- Bottom sheet с закруглёнными углами (radius 20), `isScrollControlled: true`
- **Содержимое:**
  - Drag handle (полоска для сворачивания)
  - Заголовок «Запись на занятие»
  - **`_SlotSummary`** — карточка с деталями слота: программа, дата/время, мастер, адрес, свободные места
  - **`_SeatCounter`** — счётчик мест с кнопками `+` / `−`, от 1 до `availableSeats`
    - Кнопки деактивируются при достижении границ
    - Стиль: `primaryContainer` для активной, `surfaceContainerHighest` для неактивной
  - **`_RentalSwitch`** — свитчер аренды инвентаря
    - Если `rentalInventoryAvailable == 0` — свитчер неактивен, подпись «Временно недоступно»
  - **Блок ошибки** — красный контейнер с иконкой и текстом (появляется при `error != null`)
  - **Кнопка «Записаться»** — `FilledButton` на всю ширину
    - Во время загрузки: спиннер, кнопка неактивна (защита от двойного нажатия)
- **Состояния:**
  - **Form** — форма бронирования
  - **Success** — `BookingSuccessContent` (после успешной отправки)
- Возвращает `Future<Booking?>` — `Booking` при успехе, `null` при закрытии

### 3. BookingSuccessContent (`lib/ui/screens/booking_success_screen.dart`)

- Показывается внутри bottom sheet после успешного бронирования
- **Содержимое:**
  - Зелёная круглая иконка с галочкой
  - Заголовок «Вы записаны!»
  - Подпись «Ждём вас в мастерской»
  - **Карточка с деталями брони:** занятие, мастер, дата, время, адрес, инвентарь (если выбран)
  - Кнопка «Готово» — закрывает bottom sheet и возвращает `Booking`

### 4. ScheduleScreen — изменения (`lib/ui/screens/schedule_screen.dart`)

- `_onSlotTap` теперь вызывает `BookingSheet.show(context, slot)` вместо SnackBar
- После успешного бронирования показывает SnackBar «Вы записаны на ...»

### 5. Покрытые сценарии из требований

| Сценарий | Статус |
|----------|--------|
| US-04: Запись на слот | ✅ Bottom sheet → submit → success screen |
| US-05: Выбор проката инструментов | ✅ Switch + проверка `rentalInventoryAvailable` |
| US-06: Подтверждение бронирования | ✅ `BookingSuccessContent` с деталями |
| EC-05: Нет мест при бронировании | ✅ `ApiException` → красный алерт в форме |
| EC-06: Ошибка сервера | ✅ Общий catch → сообщение об ошибке |
| EC-07: Двойное нажатие | ✅ Кнопка disabled + спиннер при `isSubmitting` |
| EC-21: Прокат недоступен | ✅ Switch неактивен, подпись «Временно недоступно» |

## Файлы

| Файл | Назначение |
|------|------------|
| `lib/viewmodels/booking_viewmodel.dart` | ViewModel с формой и логикой отправки |
| `lib/ui/widgets/booking_sheet.dart` | Bottom sheet бронирования |
| `lib/ui/screens/booking_success_screen.dart` | Экран успешного бронирования |
| `lib/ui/screens/schedule_screen.dart` | Изменён: `_onSlotTap` → открывает `BookingSheet` |

## UX Flow

```
SlotCard (tap)
  → BookingSheet (bottom sheet)
    → Форма: счётчик мест + свитчер аренды + кнопка
    → [Записаться]
      → Успех → SuccessContent (галочка + детали) → [Готово] → закрыть
      → Ошибка → красный алерт в форме → [повторная попытка]
```

---

## Отправленные промпты

| # | Промпт | Результат |
|---|--------|-----------|
| 1 | "Фича 2 — Оформление записи. Разработай экран или bottom sheet бронирования занятия. Создай BookingViewModel (ChangeNotifier) с состояниями формы (seats 1..availableSeats, needsRental) и отправки (isSubmitting, error, bookingResult). Создай BookingSheet — bottom sheet с drag handle, заголовком, _SlotSummary (программа, дата/время, мастер, адрес, места), _SeatCounter (+/- кнопки), _RentalSwitch (неактивен если rentalInventoryAvailable=0), блоком ошибки, кнопкой 'Записаться' (спиннер при загрузке). Создай BookingSuccessContent — иконка галочки, 'Вы записаны!', карточка деталей брони, кнопка 'Готово'. Обнови ScheduleScreen._onSlotTap — открывать BookingSheet вместо SnackBar." | Созданы: BookingViewModel (форма + submit + reset), BookingSheet (bottom sheet с 4 виджетами), BookingSuccessContent (подтверждение), ScheduleScreen (интеграция). |

---

## Commit

```
git add lib/viewmodels/booking_viewmodel.dart lib/ui/widgets/booking_sheet.dart lib/ui/screens/booking_success_screen.dart lib/ui/screens/schedule_screen.dart
git commit -m "feat: booking flow — bottom sheet, seat counter, rental switch, success screen"