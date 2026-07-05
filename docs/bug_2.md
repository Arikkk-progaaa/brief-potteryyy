# Bug 2: Race condition в `submitBooking()` — множественные вызовы и мутация `_seats` во время запроса

> **Дата обнаружения:** 2026-07-05  
> **Приоритет:** Критический  
> **Компонент:** `BookingViewModel.submitBooking()` + `BookingSheet` (UI)

---

## Симптом

При быстром двойном нажатии кнопки «Записаться» возможно создание **двух параллельных броней** (race condition). Кроме того, если пользователь меняет счётчик мест **во время** выполнения асинхронного запроса, количество забронированных мест может не соответствовать тому, что было выбрано изначально.

**Как воспроизвести:**
1. Открыть bottom sheet бронирования для слота с ≥3 местами.
2. Установить счётчик на «3».
3. Очень быстро нажать «Записаться» два раза подряд (до того, как Flutter перестроит кнопку в disabled-состояние).
4. Наблюдать: два параллельных вызова `bookSlot()`, каждый бронирует по 3 места = 6 мест вместо 3.

**Второй сценарий:**
1. Нажать «Записаться» (счётчик = 3).
2. Пока идёт запрос (800 мс), быстро нажать `+` на счётчике.
3. `_seats` меняется с 3 на 4 во время выполнения цикла `for (int i = 0; i < _seats; i++)`.
4. Бронируется 4 места вместо 3.

---

## Корневая причина

### Проблема 1: Отсутствие re-entry guard в `submitBooking()`

Метод `submitBooking()` — `async`. Он устанавливает `_isSubmitting = true` и вызывает `notifyListeners()`, но Flutter не гарантирует синхронный rebuild виджета. Если пользователь нажимает кнопку дважды до того, как `setState` обработается, второй вызов `submitBooking()` проходит, потому что `_isSubmitting` в **виджете** ещё `false`:

```dart
// Было (уязвимость):
Future<void> submitBooking() async {
  _isSubmitting = true;  // ← установлено, но widget ещё не перестроился
  _error = null;
  notifyListeners();

  try {
    // ... асинхронный код ...
  } finally {
    _isSubmitting = false;
    notifyListeners();
  }
}
```

### Проблема 2: `_seats` мутируется во время async-цикла

Цикл `for (int i = 0; i < _seats; i++)` читает `_seats` на каждой итерации. Если пользователь меняет счётчик во время запроса, количество итераций меняется «на лету»:

```dart
// Было (уязвимость):
for (int i = 0; i < _seats; i++) {  // _seats может измениться!
  lastBooking = await _apiService.bookSlot(...);
}
```

### Проблема 3: Счётчик и свитчер активны во время отправки

Пользователь может изменить `_seats` или `_needsRental` через UI, даже когда кнопка «Записаться» заблокирована, потому что `_SeatCounter` и `_RentalSwitch` не проверяли `isSubmitting`.

---

## Исправление

### 1. Re-entry guard в `submitBooking()` (ViewModel)

Добавлена проверка в начале метода. Если вызов уже выполняется — второй вызов игнорируется:

```dart
Future<void> submitBooking() async {
  // --- Re-entrance guard ---
  if (_isSubmitting) return;  // ← НОВОЕ: защита от race condition

  _isSubmitting = true;
  _error = null;
  notifyListeners();
  // ...
}
```

### 2. Снэпшот `_seats` до async-цикла (ViewModel)

Количество мест фиксируется в локальной переменной **до** первого `await`:

```dart
try {
  final seatsToBook = _seats;  // ← НОВОЕ: снэпшот до async

  Booking? lastBooking;
  for (int i = 0; i < seatsToBook; i++) {  // ← используем снэпшот
    lastBooking = await _apiService.bookSlot(...);
  }
  // ...
}
```

### 3. Guard в сеттерах формы (ViewModel)

Все методы изменения формы (`setSeats`, `incrementSeats`, `decrementSeats`, `toggleRental`) теперь проверяют `_isSubmitting`:

```dart
void setSeats(int value) {
  if (_isSubmitting) return;  // ← НОВОЕ
  // ...
}

void incrementSeats() {
  if (_isSubmitting) return;  // ← НОВОЕ
  // ...
}
// и т.д.
```

### 4. `enabled` параметр в `_SeatCounter` и `_RentalSwitch` (UI)

Виджеты теперь принимают параметр `enabled` и блокируют взаимодействие во время отправки:

```dart
// BookingSheet передаёт:
_SeatCounter(
  ...
  enabled: !_viewModel.isSubmitting,  // ← НОВОЕ
)

_RentalSwitch(
  ...
  enabled: !_viewModel.isSubmitting,  // ← НОВОЕ
)
```

```dart
// _SeatCounter использует:
_CounterButton(
  onTap: enabled && seats > 1 ? onDecrement : null,  // ← изменено
)

// _RentalSwitch использует:
Switch(
  onChanged: enabled && rentalAvailable ? onChanged : null,  // ← изменено
)
```

---

## Затронутые файлы

| Файл | Изменение |
|------|-----------|
| `lib/viewmodels/booking_viewmodel.dart` | Re-entry guard в `submitBooking()`; снэпшот `_seats`; guard в сеттерах формы |
| `lib/ui/widgets/booking_sheet.dart` | Параметр `enabled` в `_SeatCounter` и `_RentalSwitch`; передача `!_viewModel.isSubmitting` |

---

## Проверка исправления

После фикса:
1. Быстро нажать «Записаться» дважды → второй вызов игнорируется (re-entry guard).
2. Изменить счётчик во время запроса → значение игнорируется (guard в сеттерах + снэпшот).
3. Счётчик и свитчер визуально неактивны во время запроса (UI-блокировка).
4. После завершения запроса (успех или ошибка) — форма снова активна.

---

## Отправленные промпты

| # | Промпт | Результат |
|---|--------|-----------|
| 1 | "Проверь работу MockApiService и UI при асинхронных запросах. Найди баг, связанный с отображением состояния загрузки и возможностью повторной отправки формы. Проверь сценарий двойного нажатия кнопки 'Записаться'." | Обнаружен race condition: отсутствие re-entry guard в submitBooking(), мутация _seats во время async-цикла, активные счётчик/свитчер во время отправки. Исправлено: re-entry guard, снэпшот _seats, guard в сеттерах, enabled параметр в UI. |

---

## Commit

```
git add lib/viewmodels/booking_viewmodel.dart lib/ui/widgets/booking_sheet.dart
git commit -m "fix: race condition in submitBooking() — re-entry guard, snapshot _seats, guard in setters, UI disabled during submission"