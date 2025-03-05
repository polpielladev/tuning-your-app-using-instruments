import SwiftUI
import AsyncAlgorithms

final class NetworkingClient {
    weak var monitoring: Monitoring?
}

final class Monitoring {
    let client: NetworkingClient
    
    init(client: NetworkingClient) {
        self.client = client
    }
}

@Observable @MainActor final class SearchViewModel {
    var query = "" {
        willSet {
            continuation.yield(newValue)
        }
    }
    let monitoring: Monitoring
    let networkingClient: NetworkingClient
    let allBooks: [Book]
    
    var filteredBooks = [Book]()
        
    
    private let (textStream, continuation) = AsyncStream.makeStream(of: String.self)

    init(books: [Book]) {
        self.allBooks = books
        self.filteredBooks = allBooks
        let networkingClient = NetworkingClient()
        self.monitoring = Monitoring(client: networkingClient)
        networkingClient.monitoring = monitoring
        self.networkingClient = networkingClient
        
        Task {
            for await text in textStream.removeDuplicates().debounce(for: .milliseconds(300)) {
                if text.isEmpty {
                    filteredBooks = allBooks
                } else {
                    filteredBooks = allBooks.filter { book in
                        book.title.lowercased().contains(text.lowercased())
                    }
                }
            }
        }
    }
    
}

struct Search: View {
    @State private var viewModel: SearchViewModel
    
    init(books: [Book]) {
        self.viewModel = SearchViewModel(books: books)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Search for books", text: $viewModel.query)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: .infinity)
                .padding()
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filteredBooks) { book in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text(book.author)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
        }
    }
}
