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

## Поэтапные мини-промпты (с нуля до готового проекта)

Небольшие промпты от лица разработчика — по одному шагу за раз. Порядок повторяет реальную структуру `lib/`.

### Инициализация и тема

1. Создай Flutter-проект `brief_pottery` для гончарной мастерской «Глина». Разложи папки: `lib/models/`, `lib/services/`, `lib/viewmodels/`, `lib/ui/screens/`, `lib/ui/widgets/`, `lib/ui/common/`.

2. Сделай `AppTheme.light()` — Material 3, светлая тема: sage `#3D5A45`, clay `#B8734A`, cream `#F5F0E8`. Настрой `FilledButton`, `OutlinedButton`, `Switch`, `SnackBar`.

3. Добавь в `AppTheme` константы акцентов карточки: `slotAccentAvailable`, `slotAccentFull`, `slotAccentCancelled`.

4. Настрой `main.dart`: `BriefPotteryApp`, `MaterialApp`, `debugShowCheckedModeBanner: false`, тема из `AppTheme.light()`.

### Модели

5. Напиши класс `Master` с полями `id`, `name`, `avatarUrl`, `bio`, `averageRating`, `totalRatings`. Добавь `fromJson`/`toJson`, `==`, `hashCode`, `toString`.

6. Создай enum `ProgramType` (`handBuilding`, `wheelThrowing`) с геттерами `displayName`, `apiValue` и фабрикой `fromApi`.

7. Создай enum `SlotStatus` (`available`, `fullyBooked`, `cancelledByWorkshop`) с `displayName`, `apiValue`, `fromApi`.

8. Напиши класс `Slot`: даты, программа, мастер, места, прокат, статус, адрес. Добавь геттеры `hasStarted`, `hasEnded`, `isBookable`, `durationMinutes` и JSON-сериализацию.

9. Создай enum `BookingStatus` и класс `Booking` с геттерами `isCancellable`, `isRateable`, `isUpcoming`, `isPast`. Реализуй `fromJson`/`toJson`.

10. Сделай barrel-файл `lib/models/models.dart` с экспортом всех моделей.

### Mock API

11. Добавь класс `ApiException` с полем `message` и переопредели `toString`.

12. Создай `MockApiService`: 4 мастера в `_masters`, константа адреса. Реализуй `getSchedule()` — 12 слотов на 7 дней (доступные, без мест, отменённый s12).

13. Допиши `bookSlot(slotId, clientId, needsRental)`: задержка ~800 мс, проверки на отмену, нет мест, занятие началось, нет проката. Возвращай `Booking`.

14. Добавь в `MockApiService` методы `cancelBooking(bookingId)` и `rateMaster(bookingId, rating)` с валидацией оценки 1–5.

15. Реализуй `getClientBookings(clientId)` — 5 броней: активные, отменённая мастерской, прошлые с оценкой и без.

16. Сделай barrel `lib/services/services.dart` с экспортом `MockApiService`.

### ViewModel расписания

17. Создай `ScheduleViewModel extends ChangeNotifier`: поля `_slots`, `_loading`, `_error`, геттеры `isLoading`, `isEmpty`, `error`.

18. Реализуй `loadSchedule()`: loading → вызов `_api.getSchedule()` с задержкой → обработка ошибки. Добавь `retry()` как алиас.

### UI — пустые состояния и экран расписания

19. Сделай переиспользуемый виджет `EmptyState`: иконка, заголовок, подзаголовок, опциональная кнопка `OutlinedButton.icon` с `onAction`.

20. Создай `ScheduleScreen` как `StatefulWidget`: в `initState` — `ScheduleViewModel`, подписка на listener, вызов `loadSchedule()`.

21. Добавь шапку экрана: подпись «Глина» и заголовок «Расписание» в `SafeArea`.

22. Реализуй `_LoadingSkeleton` — 4 карточки-заглушки с `_bar` для имитации загрузки.

23. В `_body()` подключи 4 состояния: skeleton, `EmptyState` с ошибкой и кнопкой «Обновить», пустое расписание, список слотов.

24. Напиши `_byDay(slots)` — группировка слотов по дате. Сделай `_DaySection` с подписью «Сегодня · …» или «Пн · …».

25. Оберни список в `RefreshIndicator` с `onRefresh: _vm.loadSchedule`.

### UI — карточка занятия

26. Создай `SlotCard`: левая цветная полоска через `_accentColor()`, `InkWell` только если `slot.isBookable`.

27. Добавь `_headerRow` — дата `_shortDate`, время `_hhmm`, `_statusLabel`. Добавь `_programTitle` с `maxLines: 2` и ellipsis.

28. Реализуй `_masterLine`: аватар с первой буквой имени, имя мастера, бейдж рейтинга со звездой (если не отменено).

29. Сделай `_footerRow`: длительность из `durationMinutes`, свободные места красным при `availableSeats <= 2`.

30. Добавь `_pill` для чипов «Отменено» и «Нет мест». Для отменённых — `Opacity(0.5)`, `lineThrough` у названия, `_cancelReason` с иконкой info.

### UI — бронирование

31. Создай `BookingViewModel`: `_seats`, `_needsRental`, `_submitting`, `_error`, `_result`. Геттеры `maxSeats`, `minSeats`, `isSuccess`.

32. Добавь `setSeats`, `incrementSeats`, `decrementSeats`, `toggleRental` — с блокировкой при `_submitting` и вызовом `_dropError()`.

33. Реализуй `submitBooking()`: re-entry guard, цикл `bookSlot` по количеству `_seats`, обработка `ApiException`. Добавь `reset()`.

34. Сделай `BookingSheet.show(context, slot)` через `showModalBottomSheet`. Внутри — drag handle, заголовок «Запись».

35. Добавь `_SummaryBlock` с `_line`: дата/время, мастер, адрес, свободные места.

36. Сделай `_SeatPicker` с круглыми кнопками `_roundBtn` (+/−) и `_RentalRow` на `SwitchListTile` (неактивен, если прокат = 0).

37. Добавь `_ErrorBanner` и кнопку «Подтвердить запись» со спиннером при `isSubmitting`.

38. Создай `BookingSuccessContent`: иконка галочки, «Запись подтверждена», карточка с `_row` (занятие, мастер, дата, время, адрес, аренда), кнопка «Закрыть».

39. В `ScheduleScreen._openBooking` открывай `BookingSheet.show` только для `slot.isBookable`. После успеха покажи `SnackBar`.

### Доработки и тесты

40. Проверь overflow текста: в `SlotCard._programTitle` и `_masterLine`, в `BookingSheet._line`, в `BookingSuccessContent._row` — везде `Expanded` + `TextOverflow.ellipsis`.

41. Проверь двойное нажатие «Подтвердить запись»: `_submitting` guard в `submitBooking`, `enabled: !_vm.isSubmitting` в `_SeatPicker` и `_RentalRow`.

42. Напиши widget-тест: `BriefPotteryApp` открывает экран с текстом «Расписание», дождись загрузки через `pumpAndSettle`.
