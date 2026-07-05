# Feature 0: Core — Data Layer & Mock API

> **Дата:** 2026-07-04  
> **Ветка:** `feature/0-core`

---

## Реализовано

### 1. Структура проекта

Создана базовая архитектура Flutter-приложения с разделением на слои:

```
lib/
├── models/          # Модели данных (DTO)
│   ├── master.dart
│   ├── slot.dart
│   ├── booking.dart
│   └── models.dart  # barrel export
├── repositories/    # Репозитории (пока пусто)
├── services/        # Сервисы (API, локальное хранение)
│   ├── mock_api_service.dart
│   └── services.dart
├── viewmodels/      # ViewModels / State management (пока пусто)
├── ui/
│   ├── screens/     # Экраны приложения (пока пусто)
│   ├── widgets/     # Переиспользуемые виджеты (пока пусто)
│   └── common/      # Общие UI-компоненты (пока пусто)
└── main.dart        # Точка входа (сгенерирован Flutter)
```

### 2. Модели данных

| Модель | Файл | Ключевые поля |
|--------|------|---------------|
| `Master` | `lib/models/master.dart` | id, name, avatarUrl, bio, averageRating, totalRatings |
| `Slot` | `lib/models/slot.dart` | id, startTime, endTime, program (enum), master, totalSeats, availableSeats, rentalInventoryAvailable, status (enum), cancellationReason, address, description |
| `Booking` | `lib/models/booking.dart` | id, clientId, slot, needsRental, status (enum), createdAt, rating, cancellationReason |

**Enum'ы:**
- `ProgramType` — `handBuilding` / `wheelThrowing`
- `SlotStatus` — `available` / `fullyBooked` / `cancelledByWorkshop`
- `BookingStatus` — `active` / `cancelledByClient` / `cancelledByWorkshop` / `attended` / `noShow`

Все модели поддерживают `fromJson` / `toJson` для сериализации.

### 3. MockApiService

Файл: `lib/services/mock_api_service.dart`

Имитирует бэкенд с хардкодными данными:

- **12 слотов** на 7 дней, включая:
  - `s12` — слот со статусом `cancelledByWorkshop` (поломка печи, указана причина)
  - `s2` — слот со статусом `fullyBooked` (0 свободных мест)
  - `s6` — слот с 1 свободным местом (почти заполнен)
  - Остальные — обычные доступные слоты с разным количеством мест
- **4 мастера** с разными рейтингами (4.2 — 4.9)
- **Методы API:**
  - `getSchedule()` — возвращает список слотов
  - `bookSlot(...)` — бронирование с проверкой мест, статуса, времени и проката
  - `cancelBooking(...)` — отмена брони
  - `rateMaster(...)` — оценка мастера
  - `getClientBookings(...)` — возвращает 5 броней клиента (активные, отменённые мастерской, прошлые с оценкой и без)
- `ApiException` — кастомное исключение для бизнес-ошибок
- Симулированная задержка сети (500–800 мс)

### 4. Покрытые сценарии из требований

| Сценарий | Статус |
|----------|--------|
| US-01: Просмотр расписания на 7 дней | ✅ Данные готовы |
| US-04: Бронирование слота | ✅ Реализовано с проверками |
| US-05: Выбор проката инструментов | ✅ Поле `needsRental` + проверка `rentalInventoryAvailable` |
| US-08: Отмена брони | ✅ Метод `cancelBooking` |
| US-10: Оценка мастера | ✅ Метод `rateMaster` |
| EC-05: Нет мест при бронировании | ✅ `ApiException('На это занятие больше нет свободных мест.')` |
| EC-13: Отмена мастерской (форс-мажор) | ✅ Слот `s12` + проверка при бронировании |
| EC-21: Прокат недоступен | ✅ Проверка `rentalInventoryAvailable <= 0` |

---

## Отправленные промпты

| # | Промпт | Результат |
|---|--------|-----------|
| 1 | "Создай базовую структуру папок Flutter-приложения для гончарной мастерской. Напиши Data-слой: модели Master, Slot, Booking с JSON-сериализацией. Создай класс MockApiService с хардкодными данными: 12 слотов на 7 дней, 4 мастера, методы getSchedule/bookSlot/cancelBooking/rateMaster/getClientBookings. Добавь ApiException для бизнес-ошибок. Симулируй задержку сети 500-800 мс." | Создана структура lib/models/ (4 файла), lib/services/ (2 файла), lib/repositories/ (пусто). Модели с fromJson/toJson. MockApiService с 12 слотами (s1-s12), 4 мастерами, 5 методами API. ApiException. |

---

## Commit

```
git add lib/models/ lib/services/
git commit -m "feat: core data layer — models, mock API, project structure"