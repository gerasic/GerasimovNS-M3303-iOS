# Tracker

## Лабораторная 3: Экран авторизации

### Данные для входа

- Логин: `gerasic`
- Пароль: `1234`

## Лабораторная 4: Сеть и формирование ViewModel для списка

### Используемое API

- API: `DummyJSON`
- Endpoint: `GET https://dummyjson.com/products`
- Массив элементов находится в поле `products`

### Пример ответа

```json
{
  "products": [
    {
      "id": 1,
      "title": "Essence Mascara Lash Princess",
      "category": "beauty",
      "price": 9.99
    }
  ]
}
```

### Маппинг данных в модели приложения

- `category` -> `tag`
- `title` -> `metric title`
- `price` -> `today value text`
- `"$"` -> `unit`

### Что передается во view слой

- `EntriesListSectionViewModel`
  - `id`
  - `title`
  - `isCollapsed`
  - `items`
- `EntriesListMetricCellViewModel`
  - `id`
  - `title`
  - `todayValueText`
  - `unitText`
  - `isFilledToday`

### Состояния списка

- `initial` - начальное состояние до запуска загрузки
- `loading` - состояние активной загрузки данных
- `content` - данные успешно загружены и преобразованы в `EntriesListSectionViewModel`
- `empty` - загрузка завершилась успешно, но список пуст
- `error` - произошла ошибка загрузки или обработки данных

### Обработка ошибок

- низкий уровень: `NetworkError`
- фича-уровень: `EntriesListError`
- presentation уровень: `EntriesListErrorViewModel`
- ошибка сети -> `Connection Error` / `Please check your internet connection`
- ошибка HTTP-статуса -> `Service Unavailable` / `The service is temporarily unavailable`
- ошибка декодинга/некорректного ответа -> `Invalid Data` / `Failed to process server data`

### Как проверить

1. Открыть проект в Xcode.
2. Запустить unit tests для target `trackerTests`.
3. Проверяются сценарии:
   - успешная загрузка данных -> `content`
   - пустой профиль -> `empty`
   - ошибка сети -> `error`
   - сворачивание/разворачивание секции
   - fallback `Не заполнено` для метрики без значения
4. Основная логика списка запускается из `EntriesListViewModel.didLoad()`.
5. При загрузке выполняется `GET https://dummyjson.com/products`, ответ декодируется в `ProductsResponseDTO`, затем маппится в `TrackingProfile`, `EntriesListSectionViewModel` и `EntriesListMetricCellViewModel`.

![alt text](image.png)

## Лабораторная 5: Экран списка (UIKit) + переиспользуемые компоненты

### Подход к списку

- Использован `UICollectionView`.
- Причина выбора: усложнить себе жизнь, table тоже подходил.
- Работа со списком вынесена в `EntriesListCollectionManager`.

### Как открыть экран списка

1. Открыть проект в Xcode.
2. Запустить приложение.
4. После успешной авторизации открывается экран `Metrics` (`EntriesList`).

### Состояния экрана

- `loading` - появляется сразу после открытия экрана во время загрузки профиля.
- `content` - показывается список метрик, сгруппированных по секциям.
- `empty` - показывается текст `No metrics yet`, если метрик нет.
- `error` - показывается сообщение об ошибке и кнопка `Retry`.

### Что происходит по tap

- Тап по ячейке метрики открывает экран `Metric Details`.

## Лабораторная 6: Дизайн-система и применение в приложении

### Токены дизайн-системы

Дизайн-система вынесена в папку `DesignSystem`.

Реализованы токены:
- `DS.Colors`
  - `background`
  - `surface`
  - `primary`
  - `textPrimary`
  - `textSecondary`
  - `error`
  - `success`
  - `separator`
  - `disabled`
  - token API через `DS.ColorToken`
- `DS.Typography`
  - `screenTitle`
  - `sectionTitle`
  - `body`
  - `bodyMedium`
  - `bodySemibold`
  - `caption`
  - `footnote`
  - `button`
  - token API через `DS.TypographyToken`
- `DS.Spacing`
  - `none`
  - `xs`
  - `s`
  - `m`
  - `l`
  - `xl`
  - token API через `DS.SpacingToken`
- `DS.CornerRadius`
  - `none`
  - `small`
  - `medium`
  - `large`
  - token API через `DS.CornerRadiusToken`
- `DS.Size`
  - `textFieldHeight`
  - `buttonHeight`
  - `statusIndicator`
  - `chevron`
  - token API через `DS.SizeToken`
- layout tokens
  - `DS.TextAlignmentToken`
  - `DS.AxisToken`
  - `DS.StackAlignmentToken`
  - `DS.StackDistributionToken`
  - `DS.Insets`

### Компоненты дизайн-системы

Реализованы переиспользуемые UI-компоненты:
- `DSButton`
  - стили `primary` и `secondary`
  - состояния `enabled`, `disabled`, `loading`
  - настройка через полную `DSButton.Configuration`
- `DSLoadingView`
  - индикатор загрузки + текст
- `DSErrorView`
  - заголовок ошибки + сообщение + `Retry`
- `DSEmptyView`
  - отображение пустого состояния
- `DSLabel`
  - типографика, цвет, alignment, multiline через токены DS
- `DSStackView`
  - axis, spacing, alignment, distribution, insets через токены DS
- `DSContainerView`
  - background, corner radius, border через токены DS
- `DSScrollView`
  - базовый scroll-контейнер для form/BDUI экранов
- `DSSeparatorView`
  - разделитель с DS-цветом и толщиной
- `DSSpacerView`
  - layout spacer на основе spacing token

### Готовность для Лабораторной 7

DS расширена так, чтобы BDUI-слой можно было строить поверх неё, а не поверх произвольного UIKit API.

Для BDUI теперь есть:
- токены, которые можно декодировать из JSON без прямой зависимости от `UIColor`, `UIFont` и `UIStackView` enums;
- контейнеры `DSContainerView`, `DSScrollView`, `DSStackView`;
- текстовый компонент `DSLabel`;
- вспомогательные layout-компоненты `DSSeparatorView` и `DSSpacerView`;
- существующие state-компоненты `DSLoadingView`, `DSErrorView`, `DSEmptyView`;
- интерактивные элементы `DSButton` и `DSTextField`.

### Где применено

Дизайн-система применена на экранах:
- `AuthViewController`
- `EntriesListViewController`

Дополнительно токены применены в переиспользуемых элементах списка:
- `EntriesListMetricCell`
- `EntriesListSectionHeaderView`

### Где лежит дизайн-система

- `tracker/DesignSystem/DS.swift`
- `tracker/DesignSystem/Components/DSButton.swift`
- `tracker/DesignSystem/Components/DSLabel.swift`
- `tracker/DesignSystem/Components/DSStackView.swift`
- `tracker/DesignSystem/Components/DSContainerView.swift`
- `tracker/DesignSystem/Components/DSScrollView.swift`
- `tracker/DesignSystem/Components/DSSeparatorView.swift`
- `tracker/DesignSystem/Components/DSSpacerView.swift`
- `tracker/DesignSystem/Components/DSLoadingView.swift`
- `tracker/DesignSystem/Components/DSErrorView.swift`
- `tracker/DesignSystem/Components/DSEmptyView.swift`
