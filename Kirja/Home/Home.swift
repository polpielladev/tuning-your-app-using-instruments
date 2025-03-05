import SwiftUI
import Lottie

struct Home: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.books) { book in
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
            .sheet(isPresented: $viewModel.showSearch, content: {
                Search(books: viewModel.books)
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: { viewModel.showSearch = true }) {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                }
            }
            .navigationTitle("Books")
            .blur(radius: viewModel.isLoadingBooks ? 3 : 0)
            .task { await viewModel.loadBooks() }
            .overlay {
                if viewModel.isLoadingBooks {
                    LottieView(animation: .named("bookAnimation"))
                        .playing(loopMode: .autoReverse)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
