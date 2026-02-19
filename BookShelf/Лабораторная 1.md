# **Лабораторная №1 — BookShelf**

### **1) Задача**

  

Сделать программу для учета книг (**BookShelf**). Программа должна уметь:

- добавить книгу
    
- удалить книгу по id
    
- вывести список книг
    
- искать книги по критерию
    

  

Формат ввода/вывода на выбор (консоль / UI и т.д.). Должна быть возможность выполнить несколько действий за один запуск и завершить программу командой “выход”.

  

### **2) Минимальная модель**

  

Должна быть сущность книги с минимум такими полями:

- id: String (рекомендуется UUID)
    
- title: String
    
- author: String
    
- publicationYear: Int?
    
- genre: enum
    
- tags: [String] (можно пустой массив)
    

  

Пример:

```swift
enum Genre: String, CaseIterable, Codable {
    case fiction, nonFiction, mystery, sciFi, biography, fantasy
}

struct Book: Identifiable, Codable, Equatable {
    let id: String
    var title: String
    var author: String
    var publicationYear: Int?
    var genre: Genre
    var tags: [String]
}
```

### **3) Требования к архитектуре (обязательные)**

- Публичные интерфейсы закрыть **протоколами** и в коде зависеть от протоколов.
    
- Логику библиотеки вынести в отдельную сущность (например, BookShelf / LibraryService). UI/CLI не должен содержать бизнес-логику.
    
- Ошибки должны обрабатываться **без падений**: некорректный ввод, удаление несуществующего id, пустые поля и т.п.
    

  

Пример протокола:

```swift
protocol BookShelfProtocol {
    func add(_ book: Book) throws
    func delete(id: String) throws
    func list() -> [Book]
    func search(_ query: SearchQuery) -> [Book]
}

enum SearchQuery {
    case title(String)
    case author(String)
    case genre(Genre)
    case tag(String)
    case year(Int)
}
```

### **4) Минимальная функциональность (обязательная)**

- **Add**: добавление книги
    
- **Delete**: удаление книги по id
    
- **List**: вывод списка (в читаемом виде)
    
- **Search**: поиск минимум по 2 критериям (например, title и author)
    


### **5) Что сдаём**

- Playground файл (вживую)
	
- репозиторий с кодом
    
- README.md:
    
    - как запустить
        
    - какие команды/сценарии поддерживаются (пример 3–5 действий)
        
    - какие дополнительные задания сделаны
        
    

---

## **Дополнительные задания (по выбору)**

  

Можно делать любые — чем больше и качественнее, тем лучше.

  

### **D1. Валидация ввода**

- title / author не пустые
    
- publicationYear в разумном диапазоне (например 1400…текущий год)
    
- нормализация тегов (убрать лишние пробелы, привести регистр)
    

  

### **D2. Ошибки как enum + понятные сообщения**

  

Сделать LibraryError: Error с кейсами: некорректный ввод, дубль id, книга не найдена и т.д.

```swift
enum LibraryError: Error, LocalizedError {
    case emptyTitle
    case emptyAuthor
    case invalidYear(Int)
    case notFound(id: String)
    case duplicateId(String)

    var errorDescription: String? {
        switch self {
        case .emptyTitle: return "Название не может быть пустым"
        case .emptyAuthor: return "Автор не может быть пустым"
        case .invalidYear(let y): return "Некорректный год: \(y)"
        case .notFound(let id): return "Книга с id \(id) не найдена"
        case .duplicateId(let id): return "Книга с id \(id) уже существует"
        }
    }
}
```


### **D3. Редактирование книги**

  

Команда “изменить по id”: менять title / author / publicationYear / genre / tags.

  

### **D4. Сортировка и фильтры**

- сортировка по title / author / publicationYear
    
- фильтр по genre
    
- фильтр по tag
    
- вывод “только книги без года”
    

  

### **D5. Сохранение данных между запусками**

- JSON-файл в Documents/текущей директории
    
- загрузка при старте, сохранение при изменениях/выходе
    

  

### **D6. Расширенная модель предметов хранения**

  

Поддержать разные типы “элементов”:

- **Комиксы**: добавить issueNumber
    
- **Учебники**: добавить courseNumber и фильтрацию по нему
    

  

Реализация на выбор:

- протокол + структуры
    
- enum с associated values
    
- composition/обёртки
    

  

### **D7. История операций**

  

Хранить историю действий: добавил/удалил/изменил (минимум последние N операций).

  

### **D8. Тесты (опционально)**

  

Unit-тесты на: add / delete / search / validation.

---
