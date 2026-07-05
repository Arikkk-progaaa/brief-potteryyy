# Feature 3: Cancellation — Отображение отменённых занятий

> **Дата:** 2026-07-05  
> **Ветка:** `feature/3-cancellation`

---

## Цель

Обеспечить корректное отображение занятий, отменённых мастерской (форс-мажор: поломка печи, отключение электричества и т.д.). Такие слоты остаются в расписании, но визуально отличаются от доступных: карточка выглядит неактивной, причина отмены видна, запись невозможна.

## Требования (кратко)

| ID | Требование |
|----|------------|
| R-008 | Если занятие отменяет мастерская, бронь получает статус «Отменено мастерской» с указанием причины; повторная запись на отменённый слот запрещена |
| US-01 | Клиент видит расписание — отменённые слоты тоже видны, но неактивны |
| EC-13 | Занятие отменено мастерской — бронь со статусом, причина, повторная запись запрещена |

## Реализовано в коде

### Изменения в SlotCard (`lib/ui/widgets/slot_card.dart`)

Карточка отменённого занятия (`SlotStatus.cancelledByWorkshop`) теперь имеет следующие визуальные отличия:

#### 1. Пониженная непрозрачность (greyed out)

Вся карточка обёрнута в `Opacity(opacity: 0.55)`, что делает её визуально неактивной и «серой» по сравнению с доступными слотами.

```dart
if (_isCancelled) {
  return Opacity(
    opacity: 0.55,
    child: card,
  );
}
return card;
```

#### 2. Зачёркнутое название программы

Название программы отображается с `TextDecoration.lineThrough`, чтобы подчеркнуть, что занятие не состоится.

```dart
Text(
  slot.program.displayName,
  style: style?.copyWith(
    decoration: TextDecoration.lineThrough,
    color: theme.colorScheme.onSurfaceVariant,
  ),
)
```

#### 3. Статус-чип «Отменено» с иконкой блокировки

Чип теперь содержит иконку `Icons.block_flipped` для дополнительной визуальной подсказки:

```
[🚫 Отменено]  ← красный чип с иконкой
```

#### 4. Баннер с причиной отмены

Под временем и местами добавляется баннер с причиной отмены (поле `cancellationReason` из `Slot`):

```
⚠ Поломка печи для обжига. Занятие переносится.
  Приносим извинения за неудобства.
```

Баннер имеет:
- Фон `errorContainer` с прозрачностью 30%
- Рамку `error` с прозрачностью 30%
- Иконку `info_outline`
- Текст причины

#### 5. Блокировка навигации

- `onTap` карточки — `null` (не передаётся), так как `slot.isBookable` возвращает `false` для `cancelledByWorkshop`
- `InkWell` не реагирует на нажатия
- Bottom sheet бронирования не открывается

#### 6. Дополнительные визуальные изменения

| Элемент | Обычный слот | Отменённый слот |
|---------|-------------|-----------------|
| Date badge | `primaryContainer` | `surfaceContainerHighest` |
| Master avatar | `secondaryContainer` | `surfaceContainerHighest` |
| Рейтинг мастера | Показывается | Скрыт |
| Свободные места | Показываются | Скрыты |
| Программа | Обычный текст | Зачёркнутый текст |

### Проверка: booking уже заблокирован на уровне модели

`Slot.isBookable` (в `lib/models/slot.dart`) уже возвращает `false` для `cancelledByWorkshop`:

```dart
bool get isBookable =>
    status == SlotStatus.available &&
    availableSeats > 0 &&
    !hasStarted;
```

### Проверка: MockApiService блокирует запись на отменённый слот

`MockApiService.bookSlot()` (в `lib/services/mock_api_service.dart`) выбрасывает `ApiException`:

```dart
if (slot.status == SlotStatus.cancelledByWorkshop) {
  throw const ApiException('Это занятие отменено мастерской. Запись невозможна.');
}
```

### Покрытые сценарии из требований

| Сценарий | Статус |
|----------|--------|
| R-008: Слот отменён мастерской, причина указана | ✅ Баннер с `cancellationReason` |
| R-008: Повторная запись запрещена | ✅ `isBookable == false` + `ApiException` |
| EC-13: Отмена мастерской — слот виден в расписании | ✅ Карточка отображается с opacity 0.55 |
| EC-13: Кнопка записи неактивна | ✅ `onTap: null`, `InkWell` не реагирует |

## Файлы

| Файл | Изменение |
|------|-----------|
| `lib/ui/widgets/slot_card.dart` | Добавлена обработка `cancelledByWorkshop`: opacity, line-through, баннер причины, блокировка |

---

## Отправленные промпты

| # | Промпт | Результат |
|---|--------|-----------|
| 1 | "Фича 3 — Отменённые занятия. Доработай UI карточки занятия (SlotCard) для отображения слотов, отменённых мастерской (SlotStatus.cancelledByWorkshop). Требования: 1) вся карточка с opacity 0.55 (greyed out), 2) название программы с TextDecoration.lineThrough, 3) статус-чип 'Отменено' с иконкой Icons.block_flipped, 4) баннер с причиной отмены (cancellationReason) — фон errorContainer 30%, рамка error 30%, иконка info_outline, 5) onTap = null (блокировка нажатия), 6) date badge — surfaceContainerHighest, master avatar — surfaceContainerHighest, рейтинг скрыт, свободные места скрыты." | SlotCard обновлён: Opacity(0.55), lineThrough, чип с block_flipped, баннер причины, блокировка onTap, визуальные изменения бейджа/аватара/рейтинга/мест. |

---

## Commit

```
git add lib/ui/widgets/slot_card.dart
git commit -m "feat: cancelled slot UI — greyed out, line-through, reason banner, tap blocked"