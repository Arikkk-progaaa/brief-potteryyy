# Постановки на дизайн · «Глина»

> **Этап 3.** Требования для UI/UX-дизайнера: что нарисовать, как должно вести себя
> в интерфейсе, какие тексты и состояния предусмотреть.

## Не путать с ТЗ на разработку

| | Постановка на дизайн (`3-design-brief/`) | ТЗ на реализацию (`5-mobile-app-spec/`) |
| :-- | :-- | :-- |
| **Аудитория** | UI/UX-дизайнер | Разработчик, QA |
| **Фокус** | Компоновка, поведение, микрокопия, состояния, a11y | API, логика, ошибки, критерии для кода |
| **Шаблон** | [`_DESIGN_BRIEF_TEMPLATE.md`](_DESIGN_BRIEF_TEMPLATE.md) · [`_DESIGN_BRIEF_SHEET_TEMPLATE.md`](_DESIGN_BRIEF_SHEET_TEMPLATE.md) | [`_SCREEN_TEMPLATE.md`](../5-mobile-app-spec/_SCREEN_TEMPLATE.md) |
| **Wireframe** | ASCII-схема блоков | Макет + привязка к компонентам и запросам |
| **Приёмка** | Чеклист макета в Figma | Gherkin / AC для тестирования |

Сквозные правила — [`00-foundations.md`](00-foundations.md).  
Индекс экранов — [`design-brief.md`](design-brief.md) · реестр — [`feature-list.md`](../5-mobile-app-spec/feature-list.md).

## Как заполнять новый экран

1. Скопировать [`_DESIGN_BRIEF_TEMPLATE.md`](_DESIGN_BRIEF_TEMPLATE.md) (экран) или [`_DESIGN_BRIEF_SHEET_TEMPLATE.md`](_DESIGN_BRIEF_SHEET_TEMPLATE.md) (шторка).
2. Заполнить секции **1–9** — только то, что нужно для макета.
3. Секция **10** — чеклист для ревью макета (не Gherkin).
4. Секция **11** — UX-решения, зафиксированные с аналитиком.
5. Секция **12** — ссылки на FR / US / UC (трассировка).
6. Не дублировать foundations; не описывать `operationId`, HTTP-коды, idempotency — это пойдёт в ТЗ позже.

## Сборка PDF/HTML

```bash
01-analysis/3-design-brief/_export/build.sh
```
