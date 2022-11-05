//
//  ContentView.swift
//  CombineVsAsync
//
//  Created by Peter Friese on 14.06.21.
//

import SwiftUI

@available(iOS 15.0, *)
@MainActor
fileprivate class ViewModel: ObservableObject {
  @Published private(set) var result: [Book] = []
  @Published var searchTerm: String = ""
  @Published var suggestions: [String] = ["Hitchhiker", "Swift", "Firebase"]
  @Published var isSearching = false
  
  func executeQuery() async {
    async {
      let currentSearchTerm = searchTerm
      let date = Date().formatted(.iso8601)
      print("Search: \(currentSearchTerm).")
      isSearching.toggle()
      result = await searchBooks(term: currentSearchTerm)
      isSearching.toggle()
      print("Search: \(currentSearchTerm) - returned \(result.count) books. Was sent at \(date)")
    }
  }

  private func searchBooks(term searchTerm: String) async -> [Book] {
    let escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    let url = URL(string: "https://openlibrary.org/search.json?q=\(escapedSearchTerm)")!

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let searchResult = try OpenLibrarySearchResult.init(data: data)
    
      guard let libraryBooks = searchResult.books else { return [] }
    
      return libraryBooks.compactMap { Book(from: $0) }
    }
    catch {
      return []
    }
  }
  
}

@available(iOS 15.0, *)
struct BookSearchAsyncOnSubmitView: View {
  //   @Environment(\.isSearching) // doesn't work in Xcode 13b1
  @StateObject fileprivate var viewModel = ViewModel()
  private var handle: Task?
  
  var body: some View {
    List(viewModel.result) { book in
      BookSearchRowView(book: book)
    }
    .overlay {
      if viewModel.isSearching {
        ProgressView()
      }
    }
    .navigationTitle("Search w/ async/await")
    .searchable(text: $viewModel.searchTerm) {
      ForEach(viewModel.suggestions, id: \.self) { suggestion in
        Text(suggestion).searchCompletion(suggestion)
      }
    }
    .onSubmit(of: .search) {
      async {
        await viewModel.executeQuery()
      }
    }
  }
}

@available(iOS 15.0, *)
struct BookSearchView_Previews: PreviewProvider {
  static var previews: some View {
    BookSearchAsyncOnSubmitView()
  }
}
