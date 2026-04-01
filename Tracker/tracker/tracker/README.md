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
