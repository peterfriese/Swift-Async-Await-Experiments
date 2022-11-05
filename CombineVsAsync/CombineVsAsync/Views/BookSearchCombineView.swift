//
//  BookSearchCombineView.swift
//  CombineVsAsync
//
//  Created by Peter Friese on 14.06.21.
//

import SwiftUI
import Combine

@available(iOS 15.0, *)
@MainActor
fileprivate class ViewModel: ObservableObject {
  @Published private(set) var result: [Book] = []
  @Published var searchTerm: String = ""
  @Published var suggestions: [String] = ["Hitchhiker", "Swift", "Firebase"]
  @Published var isSearching = false
  
  init() {
    $searchTerm
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .removeDuplicates()
      .map { searchTerm -> AnyPublisher<[Book], Never> in
        self.searchBooks(searchTerm: searchTerm)
      }
      .print("Search w/ Combine", to: Timelogger())
      .switchToLatest()
      .print("Search w/ Combine", to: Timelogger())
      .receive(on: RunLoop.main)
      .assign(to: &$result)
  }
  
  func searchBooks(searchTerm: String) -> AnyPublisher<[Book], Never> {
    let escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    let url = URL(string: "https://openlibrary.org/search.json?q=\(escapedSearchTerm)")!
    self.isSearching = !searchTerm.isEmpty // don't show progress indicator when the searchterm is empty
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: OpenLibrarySearchResult.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveOutput: { response in
        self.isSearching = false
      })
      .compactMap { result in
        result.books?.compactMap { book in
          Book(from: book)
        }
      }
      .catch { _ in
        Just(self.result)
      }
      .eraseToAnyPublisher()
  }
}


@available(iOS 15.0, *)
struct BookSearchCombineView: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject fileprivate var viewModel = ViewModel()
  
  var body: some View {
    List(viewModel.result) { book in
      BookSearchRowView(book: book)
    }
    .overlay {
      if viewModel.isSearching {
        ProgressView()
      }
    }
    .searchable(text: $viewModel.searchTerm)
//    {
//      ForEach(viewModel.suggestions, id: \.self) { suggestion in
//        Text(suggestion).searchCompletion(suggestion)
//      }
//    }
    .navigationTitle("Search w/ async/await")
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("Done") {
          dimsiss()
        }
      }
    }
  }
  
  func dimsiss() {
    presentationMode.wrappedValue.dismiss()
  }

}

@available(iOS 15.0, *)
struct BookSearchCombineView_Previews: PreviewProvider {
    static var previews: some View {
        BookSearchCombineView()
    }
}
