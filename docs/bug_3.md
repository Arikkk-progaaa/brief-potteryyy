# Bug 3: Длинный текст ломает вёрстку карточек (отсутствует `overflow: ellipsis`)

> **Дата обнаружения:** 2026-07-05  
> **Приоритет:** Средний  
> **Компонент:** `SlotCard`, `_SlotSummary`, `_DetailRow` (UI)

---

## Симптом

При длинном названии программы (например, «Мастер-класс по созданию декоративной керамической тарелки с росписью ангобами») или длинном имени мастера текст вылезает за границы карточки, накладывается на соседние элементы или обрезается без многоточия.

**Как воспроизвести:**
1. Изменить в `MockApiService` название программы на длинное (например, 60+ символов).
2. Открыть экран расписания.
3. Наблюдать: текст программы выходит за правый край карточки.
4. Нажать на слот — в bottom sheet адрес или имя мастера также обрезаны без многоточия.
5. Успешно забронировать — на success screen адрес выталкивает иконку за пределы экрана.

---

## Корневая причина

В четырёх местах отсутствовала обработка переполнения текста:

### 1. `SlotCard._buildProgramName()` — название программы

`Text` без `maxLines` и `overflow`. Длинное название вылезает за границы карточки:

```dart
// Было:
return Text(
  slot.program.displayName,
  style: style,
);
```

### 2. `SlotCard._buildTopRow()` — строка времени

`Text` со временем не был обёрнут в `Flexible`. На узких экранах время конкурировало за пространство с чипом статуса:

```dart
// Было:
Text(
  timeStr,
  style: ...,
),
// → нет Flexible, нет overflow
```

### 3. `_SlotSummary._InfoRow()` — адрес/мастер в bottom sheet

`Text` внутри `Expanded` не имел `overflow: TextOverflow.ellipsis`. Длинный адрес обрезался без многоточия:

```dart
// Было:
Expanded(
  child: Text(
    text,
    style: ...,
  ),
  // → нет overflow
),
```

### 4. `BookingSuccessContent._DetailRow()` — значение на success screen

`Column` со значением не был обёрнут в `Expanded`. Длинный адрес выталкивал иконку за пределы экрана:

```dart
// Было:
Row(
  children: [
    Icon(...),
    SizedBox(width: 12),
    Column(  // ← не в Expanded!
      children: [
        Text(label, ...),
        Text(value, ...),  // ← вылезает за экран
      ],
    ),
  ],
),
```

---

## Исправление

### 1. `SlotCard._buildProgramName()` — `maxLines: 2` + `overflow: TextOverflow.ellipsis`

```dart
// Стало:
return Text(
  slot.program.displayName,
  style: style,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
);
```

### 2. `SlotCard._buildTopRow()` — `Flexible` + `overflow: TextOverflow.ellipsis`

```dart
// Стало:
Flexible(
  child: Text(
    timeStr,
    style: ...,
    overflow: TextOverflow.ellipsis,
  ),
),
```

### 3. `_SlotSummary._InfoRow()` — `overflow: TextOverflow.ellipsis`

```dart
// Стало:
Expanded(
  child: Text(
    text,
    style: ...,
    overflow: TextOverflow.ellipsis,  // ← добавлено
  ),
),
```

### 4. `BookingSuccessContent._DetailRow()` — `Expanded` + `overflow: TextOverflow.ellipsis`

```dart
// Стало:
Row(
  children: [
    Icon(...),
    SizedBox(width: 12),
    Expanded(  // ← добавлено
      child: Column(
        children: [
          Text(label, ...),
          Text(
            value,
            ...,
            overflow: TextOverflow.ellipsis,  // ← добавлено
          ),
        ],
      ),
    ),
  ],
),
```

---

## Затронутые файлы

| Файл | Изменение |
|------|-----------|
| `lib/ui/widgets/slot_card.dart` | `_buildProgramName()`: `maxLines: 2` + `overflow`; `_buildTopRow()`: `Flexible` + `overflow` |
| `lib/ui/widgets/booking_sheet.dart` | `_InfoRow()`: `overflow: TextOverflow.ellipsis` |
| `lib/ui/screens/booking_success_screen.dart` | `_DetailRow()`: `Expanded` + `overflow: TextOverflow.ellipsis` |

---

## Проверка исправления

После фикса:
1. Задать программе название из 60+ символов → текст обрезается с многоточием на 2 строках.
2. Уменьшить ширину экрана → время обрезается с многоточием, чип статуса виден.
3. Задать адрес из 50+ символов → в bottom sheet адрес обрезается с многоточием.
4. На success screen длинный адрес → текст обрезается, иконка не выталкивается.

---

## Отправленные промпты

| # | Промпт | Результат |
|---|--------|-----------|
| 1 | "Найди баг в UI. Например: длинное название программы или длинное имя мастера ломает вёрстку карточки (SlotCard). Проверь также bottom sheet (_SlotSummary._InfoRow) и success screen (_DetailRow)." | Обнаружены 4 места без overflow: _buildProgramName (нет maxLines/overflow), _buildTopRow (нет Flexible), _InfoRow (нет overflow), _DetailRow (нет Expanded + overflow). Исправлено: maxLines:2 + ellipsis, Flexible + ellipsis, Expanded + ellipsis. |

---

## Commit

```
git add lib/ui/widgets/slot_card.dart lib/ui/widgets/booking_sheet.dart lib/ui/screens/booking_success_screen.dart
git commit -m "fix: text overflow in SlotCard, _InfoRow, _DetailRow — add maxLines, Flexible, Expanded, TextOverflow.ellipsis"