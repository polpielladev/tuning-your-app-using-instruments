import Foundation

enum BookLoader {
    static let decoder = JSONDecoder()

    // Example to simulate a heavy loading operation
    static func loadBooks(from file: String) -> [Book] {
        var books = [Book]()
        for _ in 0..<100 {
            books = decoder.loadFile([Book].self, from: file)
        }
        return books
    }
}

final class BookRepository: Sendable {
    func loadRecommendations() -> [Book] {
        BookLoader.loadBooks(from: "books")
    }
    
    func loadReadingList() -> [Book] {
        BookLoader.loadBooks(from: "books_reading_list")

    }
    
    func loadTrendingBooks() -> [Book] {
        BookLoader.loadBooks(from: "books_recommendations")
    }
    
    func loadAllBooks() -> [Book] {
        let recommendations = loadRecommendations()
        let readingList = loadReadingList()
        let trending = loadTrendingBooks()
        
        return recommendations + readingList + trending
    }
}

@MainActor @Observable final class HomeViewModel {
    var showSearch = false
    var books = [Book]()
    var isLoadingBooks = true
    let bookRepository = BookRepository()
    
    func loadBooks() {
        isLoadingBooks = true
        self.books = bookRepository.loadAllBooks()
        isLoadingBooks = false
    }
}

fileprivate extension JSONDecoder {
    func loadFile<T: Decodable>(_ type: T.Type, from file: String) -> T {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: file, withExtension: "json")!)
        return try! decode(T.self, from: data)
    }
}
