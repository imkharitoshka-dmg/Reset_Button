# Reset Button — целевая модель данных

## ResetCluster

Группа состояний на главном экране.

Поля:

- `id`
- `title`
- `stateIds`

Примеры кластеров:

- Успокоиться
- Восстановиться
- Разгрузить голову
- Сфокусироваться
- Переключиться после общения

## ResetState

Конкретное состояние пользователя внутри кластера.

Поля:

- `id`
- `clusterId`
- `title`

Пример:

- `id: tired`
- `clusterId: recovery`
- `title: Усталость`

Пользовательские названия состояний должны быть нейтральными и не предполагать пол пользователя.

## ResetScenario

Комбинация состояния и длительности.

Поля:

- `id`
- `stateId`
- `stateTitle`
- `durationMinutes`
- `defaultVariantId`
- `variants`

Для каждой комбинации состояние × длительность должно быть минимум 3 варианта.

## ResetScenarioVariant

Один конкретный чек-лист внутри сценария.

Поля:

- `id`
- `title`
- `shortDescription`
- `stateTitle` или `stateId`
- `durationMinutes`
- `checklistItems`

Default-вариант должен оставаться стабильным, чтобы первый запуск и текущий UI были предсказуемыми.

## ResetSession

Запись о завершённой reset-сессии в истории.

Поля:

- `id`
- `completedAt`
- `stateTitle`
- `scenarioTitle`
- `durationMinutes`
- `result`
- `note`
- `scenarioVariantId` в целевой версии controlled rotation

Сессии сохраняются локально через shared_preferences.

## ScenarioResult

Результат, который пользователь выбирает после сценария.

Значения:

- `helped` — помогло
- `partially` — частично
- `notHelped` — не помогло

В UI значения отображаются на русском:

- помогло
- частично
- не помогло
