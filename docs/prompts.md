# Промпты проекта

Все промпты, использованные при разработке приложения «Глина».

---

## Фича 0 — Core (Data-слой)

**Источник:** [feature_0_core.md](feature_0_core.md)

> Создай базовую структуру папок Flutter-приложения для гончарной мастерской. Напиши Data-слой: модели Master, Slot, Booking с JSON-сериализацией. Создай класс MockApiService с хардкодными данными: 12 слотов на 7 дней, 4 мастера, методы getSchedule/bookSlot/cancelBooking/rateMaster/getClientBookings. Добавь ApiException для бизнес-ошибок. Симулируй задержку сети 500-800 мс.

---

## Фича 1 — Расписание

**Источник:** [feature_1_schedule.md](feature_1_schedule.md)

> Фича 1 — Расписание. Разработай UI экран расписания мастер-классов. Используй ScheduleViewModel (ChangeNotifier) с состояниями loading/error/empty/data. Создай ScheduleScreen с 4 состояниями: скелетон-заглушка при загрузке, EmptyState при ошибке с кнопкой 'Повторить', EmptyState при пустом расписании, ListView с группировкой по датам при данных. Создай SlotCard с бейджем даты, временем, программой, мастером (аватар + имя + рейтинг), длительностью, свободными местами (красные если ≤2), статус-чипом. Создай EmptyState — переиспользуемый виджет. Обнови main.dart: тема Material 3, seed color #8B5E3C, home = ScheduleScreen.

---

## Фича 2 — Оформление записи

**Источник:** [feature_2_booking.md](feature_2_booking.md)

> Фича 2 — Оформление записи. Разработай экран или bottom sheet бронирования занятия. Создай BookingViewModel (ChangeNotifier) с состояниями формы (seats 1..availableSeats, needsRental) и отправки (isSubmitting, error, bookingResult). Создай BookingSheet — bottom sheet с drag handle, заголовком, _SlotSummary (программа, дата/время, мастер, адрес, места), _SeatCounter (+/- кнопки), _RentalSwitch (неактивен если rentalInventoryAvailable=0), блоком ошибки, кнопкой 'Записаться' (спиннер при загрузке). Создай BookingSuccessContent — иконка галочки, 'Вы записаны!', карточка деталей брони, кнопка 'Готово'. Обнови ScheduleScreen._onSlotTap — открывать BookingSheet вместо SnackBar.

---

## Фича 3 — Отменённые занятия

**Источник:** [feature_3_cancellation.md](feature_3_cancellation.md)

> Фича 3 — Отменённые занятия. Доработай UI карточки занятия (SlotCard) для отображения слотов, отменённых мастерской (SlotStatus.cancelledByWorkshop). Требования: 1) вся карточка с opacity 0.55 (greyed out), 2) название программы с TextDecoration.lineThrough, 3) статус-чип 'Отменено' с иконкой Icons.block_flipped, 4) баннер с причиной отмены (cancellationReason) — фон errorContainer 30%, рамка error 30%, иконка info_outline, 5) onTap = null (блокировка нажатия), 6) date badge — surfaceContainerHighest, master avatar — surfaceContainerHighest, рейтинг скрыт, свободные места скрыты.

---

## Баг 1 — Количество мест не передаётся в API

**Источник:** [bug_1.md](bug_1.md)

> Найди в написанном тобой коде экрана бронирования уязвимость или баг, связанный с несоответствием UI и бизнес-логики. Проверь, учитывается ли количество выбранных мест при отправке запроса в API.

---

## Баг 2 — Race condition при двойном нажатии

**Источник:** [bug_2.md](bug_2.md)

> Проверь работу MockApiService и UI при асинхронных запросах. Найди баг, связанный с отображением состояния загрузки и возможностью повторной отправки формы. Проверь сценарий двойного нажатия кнопки 'Записаться'.

---

## Баг 3 — Переполнение текста в UI

**Источник:** [bug_3.md](bug_3.md)

> Найди баг в UI. Например: длинное название программы или длинное имя мастера ломает вёрстку карточки (SlotCard). Проверь также bottom sheet (_SlotSummary._InfoRow) и success screen (_DetailRow).

---

## Промты

Поэтапные мини-промпты от лица разработчика. Порядок повторяет реальную структуру проекта: сначала анализ (`docs/analysis/`), затем код (`lib/`).

### Анализ и проектирование (`docs/analysis/`)

> Точка входа — бриф заказчицы Марины: [`0-customer-brief/brief-pottery.md`](analysis/0-customer-brief/brief-pottery.md)

#### `0-customer-brief/` — бриф заказчика

1. Прочитай бриф Марины из `brief-pottery.md`. Выдели: боль (Instagram + ежедневник), ключевые объекты (слот, мастер, программа, прокат, бронь), правила отмены (10 мин), форс-мажор (поломка печи). Зафиксируй, что неясно и требует уточнения.

#### `1-elicitation/` — выявление требований

2. На основе брифа составь список уточняющих вопросов заказчику — как в `customer-questions.md`: лимиты мест (6 vs 10), прокат инвентаря, запись нескольких человек, порог отмены, оплата, push, лояльность.

3. По ответам заказчика напиши `domain-description.md`: описание бизнеса «Глина», процесс записи, ключевые объекты домена, цель клиентского приложения.

4. Зафиксируй в domain-description границы скоупа: только клиентское приложение + API; слоты/мастера read-only из бэкенда; офлайн-оплата; горизонт расписания 7 дней (R-027); отмена мастерской → статус «Отменено мастерской» + push (R-008).

#### `2-requirements/` — требования

5. Составь `user-stories.md`: таблица US-01…US-14 в формате «Как / Хочу / Чтобы» с приоритетами Must/Should и ссылками на FR.

6. Напиши `business-requirements.md`: BR-1 (устранить двойные записи), BR-2 (самостоятельная онлайн-запись), BR-3 (блок отмены <10 мин), BR-4 (оповещение при форс-мажоре), BR-5–BR-7 (сроки, офлайн-оплата, mobile-first).

7. Распиши `functional-requirements.md` по разделам: авторизация OTP (FR-1), просмотр/фильтрация слотов (FR-2–FR-5), бронирование и прокат (FR-6–FR-11), отмена (FR-13–FR-14), push (FR-16, FR-19–FR-20), оценка мастера (FR-21), лояльность (FR-22).

8. Сформулируй `non-functional-requirements.md`: mobile-first и skeleton (NFR-1), интеграция через API (NFR-2), 0 двойных броней на бэкенде (NFR-3), только свои брони (NFR-5), MVP-сроки и бюджет (NFR-6–NFR-7).

9. Опиши `use-cases.md`: UC-01 просмотр расписания, UC-02 бронирование, UC-03 отмена клиентом, UC-05 отмена мастерской — с основными, альтернативными потоками и исключениями (нет сети, слот заполнен, slot_cancelled).

#### `3-design-brief/` — бриф для дизайнера

10. Создай `design-brief.md` с реестром экранов: SCR-001 регистрация, SCR-002 список слотов, BS-001 фильтры, SCR-003 карточка, SCR-004 бронирование, BS-002 успех, SCR-005 мои брони, SCR-006 детали, BS-003 отмена.

11. Напиши `00-foundations.md`: принципы mobile-first, путь к записи ≤3 экранов, тач-зоны ≥44 pt, паттерн состояний loading/content/empty/error, микрокопия для ошибок.

12. Опиши дизайн `SCR-002-slot-list.md`: группировка по датам, pull-to-refresh, skeleton при загрузке, empty state «Пока нет доступных занятий», кнопка фильтров.

13. Опиши дизайн `SCR-003-slot-card.md` и отменённого слота: программа, мастер с рейтингом, места (красным если ≤2), длительность, адрес; для отмены — greyed out, зачёркнутое название, баннер с причиной, без tap.

14. Опиши дизайн `SCR-004-booking.md` и `BS-002-booking-success.md`: счётчик мест, переключатель проката, CTA «Записаться», экран «Вы записаны» с деталями брони.

#### `4-design/` — проектирование API и данных

15. Спроектируй `data-model.md`: сущности Master, Slot (ProgramType, SlotStatus), Booking (BookingStatus), Client; геттеры `isBookable`, `isCancellable`, `durationMinutes`; JSON-поля и жизненные циклы статусов.

16. Нарисуй `api-sequence.md` для createBooking: POST /bookings → 201 Created / 409 Conflict (slot_full) / 410 Gone (slot_cancelled); Idempotency-Key, price_total с сервера.

17. Зафиксируй маппинг терминов домена на OpenAPI: Program→Route, Master→Instructor, meeting_point→address, club_cancelled→cancelledByWorkshop, free_rental_boards→rentalInventoryAvailable.

#### `5-mobile-app-spec/` — ТЗ на разработку

18. Составь `feature-list.md`: реестр экранов с трассировкой к US/FR, глоссарий (слот, прокат, своё, ранняя/поздняя отмена).

19. Напиши ТЗ `SCR-002-slot-list.md` + `LOGIC-008_Паттерн-состояний-экрана.md`: ScheduleViewModel, 4 состояния UI, группировка `_byDay`, критерии приёмки.

20. Напиши ТЗ `SCR-004-booking.md` + `LOGIC-002` (лимиты мест/проката) + `LOGIC-003` (preview цены): BookingViewModel, submitBooking, обработка 409/410.

21. Напиши ТЗ `SCR-003-slot-card.md` для SlotCard: accent-полоска по статусу, `_statusLabel`, блок `_cancelReason`, блокировка onTap если `!slot.isBookable`.

### Инициализация Flutter-проекта и тема

22. Создай Flutter-проект `brief_pottery` для гончарной мастерской «Глина». Разложи папки: `lib/models/`, `lib/services/`, `lib/viewmodels/`, `lib/ui/screens/`, `lib/ui/widgets/`, `lib/ui/common/`.

23. Сделай `AppTheme.light()` — Material 3, светлая тема: sage `#3D5A45`, clay `#B8734A`, cream `#F5F0E8`. Настрой `FilledButton`, `OutlinedButton`, `Switch`, `SnackBar`.

24. Добавь в `AppTheme` константы акцентов карточки: `slotAccentAvailable`, `slotAccentFull`, `slotAccentCancelled`.

25. Настрой `main.dart`: `BriefPotteryApp`, `MaterialApp`, `debugShowCheckedModeBanner: false`, тема из `AppTheme.light()`.

### Модели

26. Напиши класс `Master` с полями `id`, `name`, `avatarUrl`, `bio`, `averageRating`, `totalRatings`. Добавь `fromJson`/`toJson`, `==`, `hashCode`, `toString`.

27. Создай enum `ProgramType` (`handBuilding`, `wheelThrowing`) с геттерами `displayName`, `apiValue` и фабрикой `fromApi`.

28. Создай enum `SlotStatus` (`available`, `fullyBooked`, `cancelledByWorkshop`) с `displayName`, `apiValue`, `fromApi`.

29. Напиши класс `Slot`: даты, программа, мастер, места, прокат, статус, адрес. Добавь геттеры `hasStarted`, `hasEnded`, `isBookable`, `durationMinutes` и JSON-сериализацию.

30. Создай enum `BookingStatus` и класс `Booking` с геттерами `isCancellable`, `isRateable`, `isUpcoming`, `isPast`. Реализуй `fromJson`/`toJson`.

31. Сделай barrel-файл `lib/models/models.dart` с экспортом всех моделей.

### Mock API

32. Добавь класс `ApiException` с полем `message` и переопредели `toString`.

33. Создай `MockApiService`: 4 мастера в `_masters`, константа адреса. Реализуй `getSchedule()` — 12 слотов на 7 дней (доступные, без мест, отменённый s12).

34. Допиши `bookSlot(slotId, clientId, needsRental)`: задержка ~800 мс, проверки на отмену, нет мест, занятие началось, нет проката. Возвращай `Booking`.

35. Добавь в `MockApiService` методы `cancelBooking(bookingId)` и `rateMaster(bookingId, rating)` с валидацией оценки 1–5.

36. Реализуй `getClientBookings(clientId)` — 5 броней: активные, отменённая мастерской, прошлые с оценкой и без.

37. Сделай barrel `lib/services/services.dart` с экспортом `MockApiService`.

### ViewModel расписания

38. Создай `ScheduleViewModel extends ChangeNotifier`: поля `_slots`, `_loading`, `_error`, геттеры `isLoading`, `isEmpty`, `error`.

39. Реализуй `loadSchedule()`: loading → вызов `_api.getSchedule()` с задержкой → обработка ошибки. Добавь `retry()` как алиас.

### UI — пустые состояния и экран расписания

40. Сделай переиспользуемый виджет `EmptyState`: иконка, заголовок, подзаголовок, опциональная кнопка `OutlinedButton.icon` с `onAction`.

41. Создай `ScheduleScreen` как `StatefulWidget`: в `initState` — `ScheduleViewModel`, подписка на listener, вызов `loadSchedule()`.

42. Добавь шапку экрана: подпись «Глина» и заголовок «Расписание» в `SafeArea`.

43. Реализуй `_LoadingSkeleton` — 4 карточки-заглушки с `_bar` для имитации загрузки.

44. В `_body()` подключи 4 состояния: skeleton, `EmptyState` с ошибкой и кнопкой «Обновить», пустое расписание, список слотов.

45. Напиши `_byDay(slots)` — группировка слотов по дате. Сделай `_DaySection` с подписью «Сегодня · …» или «Пн · …».

46. Оберни список в `RefreshIndicator` с `onRefresh: _vm.loadSchedule`.

### UI — карточка занятия

47. Создай `SlotCard`: левая цветная полоска через `_accentColor()`, `InkWell` только если `slot.isBookable`.

48. Добавь `_headerRow` — дата `_shortDate`, время `_hhmm`, `_statusLabel`. Добавь `_programTitle` с `maxLines: 2` и ellipsis.

49. Реализуй `_masterLine`: аватар с первой буквой имени, имя мастера, бейдж рейтинга со звездой (если не отменено).

50. Сделай `_footerRow`: длительность из `durationMinutes`, свободные места красным при `availableSeats <= 2`.

51. Добавь `_pill` для чипов «Отменено» и «Нет мест». Для отменённых — `Opacity(0.5)`, `lineThrough` у названия, `_cancelReason` с иконкой info.

### UI — бронирование

52. Создай `BookingViewModel`: `_seats`, `_needsRental`, `_submitting`, `_error`, `_result`. Геттеры `maxSeats`, `minSeats`, `isSuccess`.

53. Добавь `setSeats`, `incrementSeats`, `decrementSeats`, `toggleRental` — с блокировкой при `_submitting` и вызовом `_dropError()`.

54. Реализуй `submitBooking()`: re-entry guard, цикл `bookSlot` по количеству `_seats`, обработка `ApiException`. Добавь `reset()`.

55. Сделай `BookingSheet.show(context, slot)` через `showModalBottomSheet`. Внутри — drag handle, заголовок «Запись».

56. Добавь `_SummaryBlock` с `_line`: дата/время, мастер, адрес, свободные места.

57. Сделай `_SeatPicker` с круглыми кнопками `_roundBtn` (+/−) и `_RentalRow` на `SwitchListTile` (неактивен, если прокат = 0).

58. Добавь `_ErrorBanner` и кнопку «Подтвердить запись» со спиннером при `isSubmitting`.

59. Создай `BookingSuccessContent`: иконка галочки, «Запись подтверждена», карточка с `_row` (занятие, мастер, дата, время, адрес, аренда), кнопка «Закрыть».

60. В `ScheduleScreen._openBooking` открывай `BookingSheet.show` только для `slot.isBookable`. После успеха покажи `SnackBar`.

### Доработки и тесты

61. Проверь overflow текста: в `SlotCard._programTitle` и `_masterLine`, в `BookingSheet._line`, в `BookingSuccessContent._row` — везде `Expanded` + `TextOverflow.ellipsis`.

62. Проверь двойное нажатие «Подтвердить запись»: `_submitting` guard в `submitBooking`, `enabled: !_vm.isSubmitting` в `_SeatPicker` и `_RentalRow`.

63. Напиши widget-тест: `BriefPotteryApp` открывает экран с текстом «Расписание», дождись загрузки через `pumpAndSettle`.
