# Бриф для UI/UX дизайнера · «Глина»

> Требования на дизайн клиентского мобильного приложения гончарной мастерской «Глина»
> (самостоятельная запись на групповые мастер-классы). **Для дизайнера**, не ТЗ на код.
>
> **Шаблоны:** экран — [`_DESIGN_BRIEF_TEMPLATE.md`](_DESIGN_BRIEF_TEMPLATE.md);
> шторка — [`_DESIGN_BRIEF_SHEET_TEMPLATE.md`](_DESIGN_BRIEF_SHEET_TEMPLATE.md).
> Сквозные правила — [00-foundations.md](00-foundations.md).
> ТЗ на реализацию — отдельно в [`5-mobile-app-spec/`](../5-mobile-app-spec/) (шаблон `_SCREEN_TEMPLATE.md`).

**Статус:** Черновик · **Версия:** 0.1 · **Дата:** 2026-07-04

**Источники:**
[Фича-лист / реестр экранов](../5-mobile-app-spec/feature-list.md) ·
[Описание домена](../1-elicitation/domain-description.md) ·
[Бизнес-требования](../2-requirements/business-requirements.md) ·
[Функциональные требования](../2-requirements/functional-requirements.md) ·
[Нефункциональные требования](../2-requirements/non-functional-requirements.md) ·
[Use cases](../2-requirements/use-cases.md) ·
[User stories](../2-requirements/user-stories.md)

---

## Цель и контекст

**«Глина»** заменяет ручную запись через Instagram Direct и ежедневник, устраняя двойные брони
и переполненные группы. Клиент самостоятельно просматривает слоты, фильтрует, записывается
(себя), выбирает прокат, отменяет записи, оценивает мастера, видит лояльность и получает напоминания.

**Платформа:** mobile-first клиентское приложение; данные — из существующего бэкенда через API.

**Скоуп — только роль «Клиент».** Оплата офлайн; приложение показывает цену и фиксирует запись.

## Реестр экранов

| ID | Экран / Шторка | Тип | Зона | Приоритет | Документ |
|----|----------------|-----|------|-----------|----------|
| — | Сквозные правила | — | НЗ+АЗ | — | [00-foundations.md](00-foundations.md) |
| SCR-001 | Регистрация / Вход | Экран | НЗ | Critical | [SCR-001-registration.md](SCR-001-registration.md) |
| SCR-002 | Список слотов | Экран | АЗ | Critical | [SCR-002-slot-list.md](SCR-002-slot-list.md) |
| BS-001 | Фильтры | Bottom Sheet | АЗ | High | [BS-001-filters.md](BS-001-filters.md) |
| SCR-003 | Карточка слота | Экран | АЗ | Critical | [SCR-003-slot-card.md](SCR-003-slot-card.md) |
| SCR-004 | Оформление записи | Экран | АЗ | Critical | [SCR-004-booking.md](SCR-004-booking.md) |
| BS-002 | Подтверждение записи | Экран | АЗ | High | [BS-002-booking-success.md](BS-002-booking-success.md) |
| SCR-005 | Мои бронирования | Экран | АЗ | Critical | [SCR-005-my-bookings.md](SCR-005-my-bookings.md) |
| SCR-006 | Детали брони + отмена | Экран | АЗ | Critical | [SCR-006-booking-details.md](SCR-006-booking-details.md) |
| BS-003 | Подтверждение отмены | Bottom Sheet | АЗ | High | [BS-003-cancel-confirm.md](BS-003-cancel-confirm.md) |

> Полный реестр с трассировкой — [feature-list.md §4](../5-mobile-app-spec/feature-list.md).

## Ключевые user flows

- **Вход:** SCR-001 (имя + телефон) → SCR-002
- **Запись (UC-02):** SCR-002 → SCR-003 → SCR-004 → BS-002
- **Фильтрация (UC-01):** SCR-002 → BS-001 → SCR-002
- **Отмена (UC-03):** SCR-005 → SCR-006 → BS-003 → SCR-006
- **Оценка (UC-04):** SCR-005 (История) → оценка мастера
- **Форс-мажор (UC-05):** push → SCR-006 (статус «Отменено мастерской»)

## Что не делаем в MVP

Онлайн-оплата, экран профиля (кроме лояльности), карты маршрута, интерфейсы
мастера/владельца, публичный рейтинг мастеров — см. [feature-list §6](../5-mobile-app-spec/feature-list.md).
