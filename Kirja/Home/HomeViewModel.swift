import Foundation

enum BookLoader {
    static let decoder = JSONDecoder()
    
    static func loadBooks(from file: String) async -> [Book] {
        let task = Task.detached {
            var books = [Book]()
            for _ in 0..<100 {
                books = decoder.loadFile([Book].self, from: file)
            }
            return books
        }
        return await task.value
    }
}

final class BookRepository: Sendable {
    func loadRecommendations() async -> [Book] {
        await BookLoader.loadBooks(from: "books")
    }
    
    func loadReadingList() async -> [Book] {
        await BookLoader.loadBooks(from: "books_reading_list")

    }
    
    func loadTrendingBooks() async -> [Book] {
        await BookLoader.loadBooks(from: "books_recommendations")
    }
    
    func loadAllBooks() async -> [Book] {
        async let recommendations = loadRecommendations()
        async let readingList = loadReadingList()
        async let trending = loadTrendingBooks()
        
        return await recommendations + readingList + trending
    }
}

@MainActor @Observable final class HomeViewModel {
    var showSearch = false
    var books = [Book]()
    var isLoadingBooks = true
    let bookRepository = BookRepository()
    
    func loadBooks() async {
        let signposter = SignPoster(logger: .repository)
        isLoadingBooks = true
        self.books = await signposter.measure(await bookRepository.loadAllBooks(), name: "Book Loading")
        isLoadingBooks = false
    }
}

fileprivate extension JSONDecoder {
    func loadFile<T: Decodable>(_ type: T.Type, from file: String) -> T {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: file, withExtension: "json")!)
        return try! decode(T.self, from: data)
    }
}
