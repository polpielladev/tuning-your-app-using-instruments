import SwiftUI
import AsyncAlgorithms

final class NetworkingClient {
    var monitoring: Monitoring?
}

final class Monitoring {
    let client: NetworkingClient
    
    init(client: NetworkingClient) {
        self.client = client
    }
}

@Observable @MainActor final class SearchViewModel {
    var query = ""
    let monitoring: Monitoring
    let networkingClient: NetworkingClient
    let allBooks: [Book]
    
    var filteredBooks: [Book] {
        guard !query.isEmpty else { return allBooks }
        
        return allBooks.filter { book in
            book.title.lowercased().contains(query.lowercased())
        }
    }

    init(books: [Book]) {
        self.allBooks = books
        let networkingClient = NetworkingClient()
        self.monitoring = Monitoring(client: networkingClient)
        networkingClient.monitoring = monitoring
        self.networkingClient = networkingClient
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
