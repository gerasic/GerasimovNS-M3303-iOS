# Tracker (приложение для удобного отслеживания метрик)

## Идея
Личное iOS-приложение для ведения любых пользовательских метрик без жесткой привязки к конкретной доменной модели.

Главная цель:
- хранить и обновлять набор метрик пользователя;
- структурировать метрики по тегам на главном экране;
- поддерживать как предустановленные разделы, так и полностью пользовательские;
- убрать шум в интерфейсе за счет группировки метрик по единственному тегу.

## Функциональные требования
- У каждой метрики ровно один тег.
- Тег метрики можно изменить в любой момент.
- Раздел на главном экране формируется по тегу.
- Разделы можно сворачивать/разворачивать.
- Чтобы появился новый пользовательский раздел, нужен новый тег и хотя бы одна метрика с этим тегом.
- Метрики по умолчанию распределены по разделам `Тело`, `Силовые`, `Здоровье` и другим системным тегам.
- У каждой метрики всегда один активный тег.
- Любая метрика может быть перемещена между разделами сменой тега.
- Пользовательские разделы формируются автоматически, если есть тег и хотя бы одна метрика с ним.
- Пустые пользовательские разделы не показываются на главном экране.
- Состояние сворачивания/разворачивания секций сохраняется для пользователя.

## Фичи (MVP)
- авторизация;
- первый экран после логина: `EntriesList` (главный экран);
- на главном экране всегда доступна кнопка `Редактировать метрики`;
- предустановленные теги (`Тело`, `Силовые`, `Здоровье` и др.);
- добавление существующих метрик в профиль;
- создание пользовательских тегов и метрик;
- изменение тега у любой метрики;
- главный экран со сворачиваемыми секциями по тегам;
- быстрое добавление значения по иконке `+` прямо из списка метрик;
- экран `MetricDetails` с вводом значения, сменой тега и графиком выбранной метрики.

## Конкретные сценарии
1. Пользователь логинится.
2. Сразу после логина открывается главный экран (`EntriesList`).
3. Если метрик еще нет, экран отображается пустым, но с кнопкой `Редактировать метрики`.
4. Пользователь нажимает `Редактировать метрики` и попадает на `TrackingSettings`.
5. В `TrackingSettings` пользователь добавляет существующие метрики или создает новые.
6. Пользователь назначает каждой метрике один тег или создает новый тег (новый раздел).
7. После сохранения пользователь возвращается на главный экран, где метрики сгруппированы по тегам в сворачиваемых секциях.
8. Пользователь быстро добавляет значение метрики прямо из списка через иконку `+`.
9. Пользователь нажимает на метрику и открывает `MetricDetails`.
10. На экране `MetricDetails` пользователь видит график метрики, может изменить тег и заполнить/отредактировать значение.
11. Пользователь в любой момент может менять тег метрики, тем самым перемещая ее в другой раздел на главном экране.

## Архитектура
**Выбранная архитектура:** `MVVM + Coordinator + Feature-first`.

**Как она устроена:**
- каждый экран оформлен как отдельная фича: `EntriesList`, `TrackingSettings`, `MetricDetails`;
- внутри фичи лежат `ViewController`, `ViewModel`, экранные модели и навигация;
- `ViewModel` управляет состоянием экрана и реакцией на действия пользователя;
- `Coordinator` отвечает за переходы между экранами и жизненный цикл flow;
- общие сервисы, репозитории и только действительно общие доменные сущности вынесены в `Core`.

**Почему выбрана именно она:**
- приложение естественно делится на независимые фичи: `EntriesList`, `TrackingSettings`, `MetricDetails`;
- код удобнее читать и поддерживать по экранам, а не переключаться между глобальными `Presentation / Domain / Data`;
- `ViewModel` отвечает за состояние экрана, `Coordinator` за переходы, а общие сервисы можно вынести в `Core`;
- для лабораторной это ближе к тому, как реально организуют продуктовые iOS-проекты.

## Модули и ответственности
- `Auth`: авторизация пользователя, валидация учетных данных, получение пользовательской сессии.
- `EntriesList`: главный экран со списком метрик, группировкой по тегам, быстрым вводом значения и переходами в другие фичи.
- `TrackingSettings`: добавление существующих метрик, создание новых метрик и тегов, изменение структуры разделов.
- `MetricDetails`: просмотр детальной информации по метрике, изменение тега, сохранение значения и просмотр графика.

## Скелет

### 1) Auth (экран авторизации)
**Вход:**
- сохраненная сессия пользователя (опционально);
- данные для предварительного заполнения email (опционально).

**Выход:**
- `onLoginSuccess(userId)`: пользователь успешно авторизовался, нужно открыть главный экран.
- `onOpenEntriesList`: если сессия уже валидна, можно сразу перейти к списку метрик без повторного логина.
- `onLoginFailed(error)`: попытка входа завершилась ошибкой, состояние нужно показать на экране.

**Состояния UI:**
- `initial`: экран показан впервые, пользователь видит пустую форму входа.
- `editing`: пользователь заполняет или изменяет поля email/password.
- `loading`: выполняется запрос на авторизацию, форма временно недоступна.
- `content(session)`: вход успешен, состояние используется как переходное перед открытием следующего экрана.
- `error(message)`: авторизация не удалась, экран показывает текст ошибки и дает повторить попытку.

**Сценарии:**
1. Успешный вход:
   - пользователь вводит email и пароль;
   - экран отправляет событие логина во `ViewModel`;
   - при успехе формируется пользовательская сессия;
   - coordinator открывает `EntriesList`.
2. Ошибка авторизации:
   - пользователь вводит неверные данные;
   - запрос завершается ошибкой;
   - экран переходит в `error(message)` и показывает причину.
3. Автовход по сохраненной сессии:
   - при открытии экрана проверяется существующая сессия;
   - если сессия валидна, ручной ввод не требуется;
   - coordinator сразу открывает `EntriesList`.

### 2) EntriesList (главный экран)
**Вход:**
- `userId`;
- текущий `TrackingProfile` (теги, метрики, состояние секций);
- последние записи значений (если есть).

**Выход:**
- `onTapEditMetrics`: пользователь нажал кнопку `Редактировать метрики`, нужно открыть `TrackingSettings`.
- `onTapMetric(metricId)`: пользователь выбрал метрику на главном экране, нужно открыть `MetricDetails`.
- `onTapAddValue(metricId)`: пользователь нажал иконку `+` в списке и хочет быстро добавить новое значение для метрики без перехода в детали.
- `onToggleSection(tagId)`: пользователь свернул или развернул секцию с тегом `tagId`.

**Состояния UI:**
- `initial`: экран только создан, данные еще не запрошены, пользователь не видит итоговое содержимое.
- `loading`: идет загрузка профиля метрик, тегов и последних значений; на экране показывается индикатор загрузки или skeleton.
- `empty`: загрузка завершена, но у пользователя еще нет ни одной подключенной метрики; при этом кнопка `Редактировать метрики` остается доступной.
- `content(sections)`: данные успешно загружены, метрики показаны секциями по тегам, часть секций может быть свернута.
- `error(message)`: при загрузке или обновлении произошла ошибка; экран показывает текст ошибки и дает пользователю повторить действие.

**Сценарии:**
1. Открытие экрана после логина:
   - экран получает `userId`;
   - загружает профиль метрик и теги;
   - если метрик нет, показывает `empty`;
   - если метрики есть, показывает `content(sections)`.
2. Сворачивание/разворачивание раздела:
   - пользователь нажимает на заголовок раздела;
   - экран отправляет `onToggleSection(tagId)`;
   - состояние секции обновляется и сохраняется.
3. Редактирование метрик:
   - пользователь нажимает `Редактировать метрики`;
   - экран отправляет `onTapEditMetrics`;
   - coordinator открывает `TrackingSettings`.
4. Работа с конкретной метрикой:
   - пользователь нажимает иконку `+` рядом с метрикой для быстрого ввода (`onTapAddValue(metricId)`);
   - либо нажимает на строку метрики для открытия деталей (`onTapMetric(metricId)`);
   - после действий главный экран обновляет значение в списке.

### 3) TrackingSettings (редактирование метрик)
**Вход:**
- `userId`;
- текущий `TrackingProfile`;
- список предустановленных метрик;
- список доступных тегов.

**Выход:**
- `onAddExistingMetric(metricTemplateId)`: добавить в профиль готовую метрику из предустановленного списка.
- `onCreateMetric(title, unit, tagId)`: создать новую пользовательскую метрику с указанным тегом.
- `onChangeMetricTag(metricId, tagId)`: сменить тег у метрики и перенести ее в другой раздел.
- `onCreateTag(title)`: создать новый пользовательский тег (новый раздел на главном экране).
- `onSave(profile)`: сохранить все изменения профиля метрик и тегов.
- `onBack`: закрыть экран без сохранения новых изменений.

**Состояния UI:**
- `initial`: экран открыт, но список доступных метрик и тегов еще не получен.
- `loading`: идет загрузка текущего профиля, предустановленных метрик и доступных тегов.
- `content(profile, templates, tags)`: экран готов к работе; пользователь может добавлять метрики, создавать новые и менять теги.
- `saving`: пользователь нажал `Сохранить`, изменения отправляются в хранилище, интерактивность экрана временно ограничена.
- `error(message)`: произошла ошибка загрузки или сохранения; экран показывает причину и позволяет повторить действие.

**Сценарии:**
1. Добавление существующей метрики:
   - пользователь выбирает метрику из предустановленного списка;
   - назначает тег;
   - метрика появляется в профиле.
2. Создание новой метрики:
   - пользователь вводит название и единицу измерения;
   - выбирает существующий тег или создает новый;
   - подтверждает создание, метрика добавляется в профиль.
3. Перемещение метрики между разделами:
   - пользователь меняет тег у метрики;
   - экран отправляет `onChangeMetricTag`;
   - после сохранения метрика отображается в другом разделе главного экрана.
4. Сохранение изменений:
   - пользователь нажимает `Сохранить`;
   - экран переходит в `saving`;
   - при успехе отправляет `onSave(profile)` и закрывается.

### 4) MetricDetails (детальная информация по метрике)
**Вход:**
- `userId`;
- `metricId`;
- диапазон графика по умолчанию (`month`);
- текущее значение метрики (опционально).

**Выход:**
- `onSaveValue(metricId, value, recordedAt)`: сохранить новое значение метрики.
- `onChangeMetricTag(metricId, tagId)`: изменить тег метрики и тем самым переместить ее в другой раздел.
- `onChangeRange(range)`: пользователь сменил временной диапазон графика (`week/month/quarter/year/custom`).
- `onOpenEntry(entryId)`: открыть запись, соответствующую выбранной точке на графике.
- `onBack`: закрыть экран деталей метрики и вернуться назад.

**Состояния UI:**
- `initial`: экран открыт по `metricId`, но данные по метрике еще не загружены.
- `loading`: идет загрузка информации о метрике, последнего значения, тегов и точек для графика.
- `saving`: пользователь сохраняет новое значение или меняет тег; экран ждет подтверждения успешного обновления.
- `empty`: данные о метрике загружены, но у нее еще нет значений для отображения на графике.
- `content(metric, lastValue, points, range)`: экран показывает информацию о метрике, последнее значение, выбранный диапазон и график по имеющимся точкам.
- `error(message)`: произошла ошибка загрузки или сохранения; экран показывает сообщение и позволяет повторить запрос.

**Сценарии:**
1. Открытие деталей метрики:
   - экран получает `metricId`;
   - загружает данные метрики и последнее значение;
   - загружает точки за диапазон по умолчанию;
   - показывает `empty` или `content`.
2. Заполнение значения:
   - пользователь вводит новое значение;
   - нажимает `Сохранить`;
   - экран отправляет `onSaveValue(...)`, переходит в `saving`, затем обновляет данные.
3. Изменение тега:
   - пользователь выбирает новый тег;
   - экран отправляет `onChangeMetricTag(metricId, tagId)`;
   - после сохранения метрика отображается в другом разделе на `EntriesList`.
4. Работа с графиком:
   - пользователь меняет диапазон (`onChangeRange(range)`), график перерисовывается;
   - при нажатии на точку графика открывает связанную запись (`onOpenEntry(entryId)`).

## Модели данных
Ниже перечислены ключевые модели, которые используются в состояниях экранов и контрактах между слоями.

### Модели авторизации
- `LoginRequest`: данные для входа пользователя (`email`, `password`).
- `LoginResponse`: ответ после успешной авторизации (`token`, `userId`).
- `UserSession`: активная пользовательская сессия (`token`, `userId`, `expiresAt`).
- `AuthViewState`: состояние экрана авторизации.

### Модели списка и деталей
- `MetricSection`: секция главного экрана, которая объединяет метрики по одному тегу и хранит состояние свернутости.
- `MetricDetailsData`: агрегированная модель для экрана `MetricDetails`: сама метрика, последнее значение, график и доступные теги.
- `MetricPoint`: точка временного ряда для графика метрики.

### Доменные модели
- `TrackedMetric`: пользовательская метрика, уже добавленная в профиль.
- `MetricTag`: тег, который определяет раздел на главном экране.
- `TrackingProfile`: текущая конфигурация пользователя, включающая теги и подключенные метрики.
- `MetricValue`: конкретное значение метрики в определенную дату.

### ViewState-модели
- `AuthViewState`: состояние экрана авторизации.
- `EntriesListViewState`: состояние главного экрана.
- `TrackingSettingsViewState`: состояние экрана настройки метрик.
- `MetricDetailsViewState`: состояние детального экрана метрики.

### Ошибки
- `AuthError`: ошибки входа пользователя, например неверный пароль или отсутствие сети.
- `MetricsError`: ошибки при загрузке и сохранении метрик, тегов и значений.
- `ValidationError`: ошибки валидации пользовательского ввода, например пустое название метрики.

## Контракты (протоколы) между слоями
Контракты описаны под архитектуру `MVVM + Coordinator + Feature-first`.

Принципы:
- `UIKit` допустим только на уровне `View`;
- у каждого экрана свой набор `View` / `ViewModel`, а навигация вынесена в coordinator tree;
- общая логика доступа к данным вынесена в сервисы и репозитории из `Core`;
- проект организован по экранам, а не по глобальным слоям `Presentation / Domain / Data`.

### Общие типы
Здесь перечислены только действительно общие типы, которые могут использовать несколько фич одновременно. Экранные модели лежат внутри своих feature-папок.

```swift
import Foundation

typealias UserID = String
typealias MetricID = String
typealias TagID = String
typealias EntryID = String

enum MetricsError: Error, Equatable {
    case failedToLoad
    case failedToSave
    case metricNotFound
}

enum ValidationError: Error, Equatable {
    case emptyTitle
    case emptyTag
    case invalidValue
}
```

### View ↔ ViewModel
Здесь описано, как экран сообщает о действиях пользователя и как получает состояние для отрисовки.  
`View` ничего не решает сама: она передает события в `ViewModel`.  
`ViewModel` не знает про конкретные `UIView`-элементы и отдает только состояние.

```swift
protocol AuthView: AnyObject {
    func render(_ state: AuthViewState)
}

protocol AuthViewModelInput {
    func didLoad()
    func didChangeEmail(_ email: String)
    func didChangePassword(_ password: String)
    func didTapLogin(email: String, password: String)
}

protocol EntriesListView: AnyObject {
    func render(_ state: EntriesListViewState)
}

protocol EntriesListViewModelInput {
    func didLoad()
    func didTapEditMetrics()
    func didTapMetric(metricId: MetricID)
    func didTapAddValue(metricId: MetricID, value: Double, recordedAt: Date)
    func didToggleSection(tagId: TagID)
}

protocol TrackingSettingsView: AnyObject {
    func render(_ state: TrackingSettingsViewState)
}

protocol TrackingSettingsViewModelInput {
    func didLoad()
    func didTapAddExistingMetric(templateId: MetricID, tagId: TagID)
    func didTapCreateMetric(title: String, unit: String, tagId: TagID)
    func didTapCreateTag(title: String)
    func didChangeMetricTag(metricId: MetricID, tagId: TagID)
    func didTapSave()
    func didTapBack()
}

protocol MetricDetailsView: AnyObject {
    func render(_ state: MetricDetailsViewState)
}

protocol MetricDetailsViewModelInput {
    func didLoad()
    func didTapSaveValue(_ value: Double, recordedAt: Date)
    func didChangeMetricTag(tagId: TagID)
    func didChangeRange(_ range: ChartRange)
    func didTapPoint(entryId: EntryID)
    func didTapBack()
}
```

Что это значит в проекте:
- `View` сообщает только пользовательские события: открыть экран, нажать кнопку, сохранить значение, сменить диапазон.
- `ViewModel` преобразует бизнес-данные в `ViewState`, с которым экран уже умеет рисоваться.
- Такой контракт позволяет тестировать состояние экрана без запуска `UIKit`.

### ViewModel ↔ Services
Сервисы инкапсулируют прикладную логику фичи.  
`ViewModel` не должна сама знать, откуда берутся данные и как они сохраняются. Для нее есть понятный сервисный интерфейс.

```swift
protocol AuthService {
    func login(request: LoginRequest) async throws -> UserSession
    func restoreSession() async throws -> UserSession?
}

protocol EntriesListService {
    func loadSections(userId: UserID) async throws -> [MetricSection]
    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws
}

protocol TrackingSettingsService {
    func loadProfile(userId: UserID) async throws -> TrackingProfile
    func loadMetricTemplates() async throws -> [MetricTemplate]
    func saveProfile(userId: UserID, profile: TrackingProfile) async throws
}

protocol MetricDetailsService {
    func loadMetricDetails(userId: UserID, metricId: MetricID, range: ChartRange) async throws -> MetricDetailsData
    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws
    func updateMetricTag(userId: UserID, metricId: MetricID, tagId: TagID) async throws
}
```

Что это значит в проекте:
- `AuthService` отвечает за логин пользователя и восстановление сохраненной сессии.
- `EntriesListService` готовит секции для главного экрана и обрабатывает быстрый ввод значения.
- `TrackingSettingsService` загружает профиль, список шаблонов метрик и сохраняет изменения.
- `MetricDetailsService` собирает все данные для детального экрана: метрику, последнее значение, график и список тегов.

### Services ↔ Data
Здесь описаны абстракции доступа к данным.  
Сервис работает не с конкретной базой или API, а с репозиториями, которые можно подменить в тестах.

```swift
protocol AuthRepository {
    func login(request: LoginRequest) async throws -> LoginResponse
    func fetchSavedSession() async throws -> UserSession?
    func saveSession(_ session: UserSession) async throws
}

protocol MetricsRepository {
    func fetchTrackingProfile(userId: UserID) async throws -> TrackingProfile
    func fetchMetricTemplates() async throws -> [MetricTemplate]
    func saveTrackingProfile(userId: UserID, profile: TrackingProfile) async throws
    func updateMetricTag(userId: UserID, metricId: MetricID, tagId: TagID) async throws
}

protocol EntriesRepository {
    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws
    func fetchMetricSeries(userId: UserID, metricId: MetricID, range: ChartRange) async throws -> [MetricPoint]
}
```

Что это значит в проекте:
- `AuthRepository` отвечает за авторизацию и сохранение пользовательской сессии.
- `MetricsRepository` отвечает за метрики, теги, шаблоны и сохранение профиля пользователя.
- `EntriesRepository` отвечает за значения метрик и временные ряды для графиков.
- Реализация может быть любой: локальное хранилище, сеть, мок-данные.

### Coordinator (Navigation)
Навигация вынесена отдельно, чтобы переходы между экранами не жили в `ViewController` и `ViewModel`.

```swift
protocol Coordinator: AnyObject {
    func start()
}

final class AppCoordinator: Coordinator {
    private var childCoordinators: [Coordinator] = []
}

final class AuthCoordinator: Coordinator { }
final class EntriesListCoordinator: Coordinator { }
final class TrackingSettingsCoordinator: Coordinator { }
final class MetricDetailsCoordinator: Coordinator { }
```

Что это значит в проекте:
- `AppCoordinator` является единственной точкой входа и управляет верхнеуровневыми flow.
- `AuthCoordinator` отвечает только за flow авторизации.
- `EntriesListCoordinator` управляет главным экраном и запускает дочерние flow для настроек и деталей.
- `TrackingSettingsCoordinator` и `MetricDetailsCoordinator` живут как настоящие child coordinator'ы, а не как router-прокси.
- `ViewModel` не знают ни про `UIKit`, ни про coordinator'ы напрямую: они отдают события наружу через callbacks.

## Структура папок
```text
lab2/
  README.md
  FitTrack/
    Features/
      Auth/
        Models/
          AuthError.swift
          AuthViewState.swift
          LoginRequest.swift
          LoginResponse.swift
          UserSession.swift
        AuthViewController.swift
        AuthViewModel.swift
        AuthCoordinator.swift
      EntriesList/
        Models/
          EntriesListViewState.swift
        EntriesListViewController.swift
        EntriesListViewModel.swift
      TrackingSettings/
        Models/
          MetricTemplate.swift
          TrackingSettingsViewState.swift
        TrackingSettingsViewController.swift
        TrackingSettingsViewModel.swift
        TrackingSettingsCoordinator.swift
      MetricDetails/
        Models/
          MetricDetailsData.swift
          MetricDetailsViewState.swift
        MetricDetailsViewController.swift
        MetricDetailsViewModel.swift
        MetricDetailsCoordinator.swift
    Core/
      Models/
      Services/
      Repositories/
      Storage/
      Networking/
      UI/
    App/
      Coordinator.swift
      AppCoordinator.swift
      EntriesListCoordinator.swift
      DI/
```
