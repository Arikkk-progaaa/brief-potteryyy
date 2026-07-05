# Bug 1: Счётчик мест не влияет на API-запрос при бронировании

> **Дата обнаружения:** 2026-07-05  
> **Приоритет:** Критический  
> **Компонент:** `BookingViewModel.submitBooking()`

---

## Симптом

Пользователь выбирает в счётчике **3 места**, нажимает «Записаться» — бронь создаётся, success screen показывает детали, но в `MockApiService` уходит **только 1 запрос** на 1 место. Фактически резервируется 1 место вместо 3.

**Как воспроизвести:**
1. Открыть bottom sheet бронирования для любого доступного слота (например, s1 с 3 местами).
2. Нажать `+` два раза — счётчик показывает «3».
3. Нажать «Записаться».
4. Дождаться success screen.
5. Проверить — в `MockApiService.bookSlot()` был вызван 1 раз, а не 3.

---

## Корневая причина

В `BookingViewModel.submitBooking()` (строка 91) был жёстко закодирован вызов API без учёта `_seats`:

```dart
// Было (баг):
final booking = await _apiService.bookSlot(
  slotId: _slot.id,
  clientId: _clientId,
  needsRental: _needsRental,
);
// _seats никак не используется!
```

Комментарий в коде гласил: `// For simplicity, we book 1 slot per call.` — но UI при этом позволял выбрать >1 места, создавая ложное ожидание у пользователя. Рассогласование между UI (счётчик мест) и бизнес-логикой (всегда 1 место).

---

## Исправление

### 1. `BookingViewModel.submitBooking()` — учитывает `_seats`

```dart
// Стало (исправление):
Booking? lastBooking;
for (int i = 0; i < _seats; i++) {
  lastBooking = await _apiService.bookSlot(
    slotId: _slot.id,
    clientId: _clientId,
    needsRental: _needsRental,
  );
}
_bookingResult = lastBooking;
```

Теперь для каждого выбранного места выполняется отдельный вызов `bookSlot()`. Последний успешный `Booking` сохраняется как результат.

### 2. `BookingViewModel.reset()` — сбрасывает форму полностью

Раньше `reset()` не сбрасывал `_seats` и `_needsRental`:

```dart
// Было:
void reset() {
  _isSubmitting = false;
  _error = null;
  _bookingResult = null;
  notifyListeners();
}

// Стало:
void reset() {
  _seats = 1;          // + сброс счётчика
  _needsRental = false; // + сброс аренды
  _isSubmitting = false;
  _error = null;
  _bookingResult = null;
  notifyListeners();
}
```

### 3. Очистка ошибки при изменении формы (сопутствующее улучшение)

Раньше, если пользователь получал ошибку (например, «Прокат инструментов недоступен») и затем выключал свитчер аренды, ошибка продолжала висеть на экране. Теперь все методы изменения формы (`setSeats`, `incrementSeats`, `decrementSeats`, `toggleRental`) вызывают `_clearError()`:

```dart
void _clearError() {
  if (_error != null) {
    _error = null;
    notifyListeners();
  }
}
```

---

## Затронутые файлы

| Файл | Изменение |
|------|-----------|
| `lib/viewmodels/booking_viewmodel.dart` | `submitBooking()` теперь вызывает `bookSlot()` в цикле по `_seats`; `reset()` сбрасывает форму полностью; добавлен `_clearError()` при изменении полей |

---

## Проверка исправления

После фикса:
1. Выбрать 3 места → нажать «Записаться» → `bookSlot()` вызывается 3 раза → резервируется 3 места.
2. Выбрать 1 место → нажать «Записаться» → `bookSlot()` вызывается 1 раз.
3. Получить ошибку → изменить счётчик или свитчер → ошибка исчезает.
4. Нажать «Повторить» (через `reset()`) → счётчик = 1, аренда = false, ошибка очищена.

---

## Отправленные промпты

| # | Промпт | Результат |
|---|--------|-----------|
| 1 | "Найди в написанном тобой коде экрана бронирования уязвимость или баг, связанный с несоответствием UI и бизнес-логики. Проверь, учитывается ли количество выбранных мест при отправке запроса в API." | Обнаружен баг: `submitBooking()` всегда вызывал `bookSlot()` 1 раз, игнорируя `_seats`. Исправлено: цикл по `_seats`, `reset()` сбрасывает форму, добавлен `_clearError()`. |

---

## Commit

```
git add lib/viewmodels/booking_viewmodel.dart
git commit -m "fix: seat count not passed to API — loop over _seats in submitBooking(), reset() clears form, _clearError() on field change"