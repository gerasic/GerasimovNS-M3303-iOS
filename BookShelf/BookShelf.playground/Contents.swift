import Foundation
import SwiftUI
import PlaygroundSupport

enum Genre: String, CaseIterable, Codable, Identifiable {
    case fiction
    case nonFiction
    case mystery
    case sciFi
    case biography
    case fantasy

    var id: String { rawValue }
}

struct Book: Identifiable, Codable, Equatable {
    let id: String
    var title: String
    var author: String
    var publicationYear: Int?
    var genre: Genre
    var tags: [String]
}

enum SearchQuery {
    case title(String)
    case author(String)
    case genre(Genre)
    case tag(String)
    case year(Int)
}

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
        case .invalidYear(let year): return "Некорректный год: \(year)"
        case .notFound(let id): return "Книга с id \(id) не найдена"
        case .duplicateId(let id): return "Книга с id \(id) уже существует"
        }
    }
}

protocol BookShelfProtocol {
    func add(_ book: Book) throws
    func delete(id: String) throws
    func list() -> [Book]
    func search(_ query: SearchQuery) -> [Book]
}

final class BookShelf: BookShelfProtocol {
    private var books: [Book] = []
    private let minYear = 1400

    func add(_ book: Book) throws {
        try validate(book)
        guard !books.contains(where: { $0.id == book.id }) else {
            throw LibraryError.duplicateId(book.id)
        }
        books.append(normalized(book))
    }

    func delete(id: String) throws {
        guard let index = books.firstIndex(where: { $0.id == id }) else {
            throw LibraryError.notFound(id: id)
        }
        books.remove(at: index)
    }

    func list() -> [Book] {
        books
    }

    func search(_ query: SearchQuery) -> [Book] {
        switch query {
        case .title(let title):
            return books.filter { $0.title.localizedCaseInsensitiveContains(title) }
        case .author(let author):
            return books.filter { $0.author.localizedCaseInsensitiveContains(author) }
        case .genre(let genre):
            return books.filter { $0.genre == genre }
        case .tag(let tag):
            let normalizedTag = tag.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            return books.filter { $0.tags.contains(normalizedTag) }
        case .year(let year):
            return books.filter { $0.publicationYear == year }
        }
    }

    private func validate(_ book: Book) throws {
        if book.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw LibraryError.emptyTitle
        }
        if book.author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw LibraryError.emptyAuthor
        }
        if let year = book.publicationYear {
            let currentYear = Calendar.current.component(.year, from: Date())
            if year < minYear || year > currentYear {
                throw LibraryError.invalidYear(year)
            }
        }
    }

    private func normalized(_ book: Book) -> Book {
        let normalizedTags = book.tags
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }

        return Book(
            id: book.id,
            title: book.title.trimmingCharacters(in: .whitespacesAndNewlines),
            author: book.author.trimmingCharacters(in: .whitespacesAndNewlines),
            publicationYear: book.publicationYear,
            genre: book.genre,
            tags: normalizedTags
        )
    }
}

enum SearchMode: String, CaseIterable, Identifiable {
    case title
    case author
    case genre
    case tag
    case year

    var id: String { rawValue }
}

final class BookShelfViewModel: ObservableObject {
    private let shelf: BookShelfProtocol

    @Published var books: [Book] = []
    @Published var errorMessage: String?

    @Published var title = ""
    @Published var author = ""
    @Published var yearText = ""
    @Published var genre: Genre = .fiction
    @Published var tagsText = ""

    @Published var searchMode: SearchMode = .title
    @Published var searchText = ""
    @Published var searchGenre: Genre = .fiction
    @Published private var filteredBooks: [Book]? = nil
    @Published var searchStatusMessage: String?

    init(shelf: BookShelfProtocol) {
        self.shelf = shelf
        reload()
    }

    func reload() {
        books = shelf.list()
        if filteredBooks != nil {
            performSearch()
        }
    }

    func addBook() {
        let year = yearText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : Int(yearText)
        let tags = tagsText.split(separator: ",").map(String.init)

        let book = Book(
            id: UUID().uuidString,
            title: title,
            author: author,
            publicationYear: year,
            genre: genre,
            tags: tags
        )

        do {
            try shelf.add(book)
            clearForm()
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteBook(id: String) {
        do {
            try shelf.delete(id: id)
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func performSearch() {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        errorMessage = nil
        searchStatusMessage = nil

        switch searchMode {
        case .title:
            guard !text.isEmpty else {
                filteredBooks = []
                searchStatusMessage = "Введите название для поиска"
                return
            }
            filteredBooks = shelf.search(.title(text))
        case .author:
            guard !text.isEmpty else {
                filteredBooks = []
                searchStatusMessage = "Введите автора для поиска"
                return
            }
            filteredBooks = shelf.search(.author(text))
        case .tag:
            guard !text.isEmpty else {
                filteredBooks = []
                searchStatusMessage = "Введите тег для поиска"
                return
            }
            filteredBooks = shelf.search(.tag(text))
        case .year:
            guard let year = Int(text) else {
                filteredBooks = []
                searchStatusMessage = text.isEmpty ? "Введите год для поиска" : "Год должен быть числом"
                return
            }
            filteredBooks = shelf.search(.year(year))
        case .genre:
            filteredBooks = shelf.search(.genre(searchGenre))
        }

        let count = filteredBooks?.count ?? 0
        searchStatusMessage = count == 0 ? "Ничего не найдено" : "Найдено книг: \(count)"
    }

    func resetSearch() {
        searchText = ""
        searchGenre = .fiction
        filteredBooks = nil
        searchStatusMessage = nil
        errorMessage = nil
    }

    var visibleBooks: [Book] {
        filteredBooks ?? books
    }

    private func clearForm() {
        title = ""
        author = ""
        yearText = ""
        genre = .fiction
        tagsText = ""
        errorMessage = nil
    }
}

struct ContentView: View {
    @StateObject private var vm = BookShelfViewModel(shelf: BookShelf())

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    addSection
                    searchSection
                    booksSection

                    if let error = vm.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
                .padding()
            }
            .navigationTitle("BookShelf")
        }
        .frame(width: 430, height: 680)
    }

    private var addSection: some View {
        GroupBox("Добавить книгу") {
            VStack(spacing: 8) {
                TextField("Название", text: $vm.title)
                    .textFieldStyle(.roundedBorder)
                TextField("Автор", text: $vm.author)
                    .textFieldStyle(.roundedBorder)
                TextField("Год (опционально)", text: $vm.yearText)
                    .textFieldStyle(.roundedBorder)
                Picker("Жанр", selection: $vm.genre) {
                    ForEach(Genre.allCases) { genre in
                        Text(genre.rawValue).tag(genre)
                    }
                }
                .pickerStyle(.menu)
                TextField("Теги через запятую", text: $vm.tagsText)
                    .textFieldStyle(.roundedBorder)
                Button("Добавить") {
                    vm.addBook()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var searchSection: some View {
        GroupBox("Поиск") {
            VStack(spacing: 8) {
                Picker("Критерий", selection: $vm.searchMode) {
                    ForEach(SearchMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                if vm.searchMode == .genre {
                    Picker("Жанр", selection: $vm.searchGenre) {
                        ForEach(Genre.allCases) { genre in
                            Text(genre.rawValue).tag(genre)
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    TextField("Введите значение", text: $vm.searchText)
                        .textFieldStyle(.roundedBorder)
                }

                HStack {
                    Button("Найти") {
                        vm.performSearch()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Сброс") {
                        vm.resetSearch()
                    }
                    .buttonStyle(.bordered)
                }

                if let searchMessage = vm.searchStatusMessage {
                    Text(searchMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var booksSection: some View {
        GroupBox("Книги") {
            VStack(alignment: .leading, spacing: 8) {
                if vm.visibleBooks.isEmpty {
                    Text("Список пуст")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                ForEach(vm.visibleBooks) { book in
                    BookCardView(book: book) {
                        vm.deleteBook(id: book.id)
                    }
                }
            }
        }
    }
}

private struct BookCardView: View {
    let book: Book
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title).font(.headline)
                Text(book.author).font(.subheadline)
                Text("id: \(book.id)").font(.caption)
                Text("genre: \(book.genre.rawValue), year: \(book.publicationYear.map(String.init) ?? "нет")")
                    .font(.caption)
                Text("tags: \(book.tags.isEmpty ? "-" : book.tags.joined(separator: ", "))")
                    .font(.caption)
            }
            Spacer()
            Button("Удалить") {
                onDelete()
            }
            .buttonStyle(.bordered)
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

PlaygroundPage.current.setLiveView(ContentView())
