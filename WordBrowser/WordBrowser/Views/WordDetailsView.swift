//
//  WordDetailsView.swift
//  WordBrowser
//
//  Created by Peter Friese on 18.06.21.
//

import SwiftUI

@MainActor
class WordDetailsViewModel: ObservableObject {
  // input
  @Published var searchTerm = ""
  
  // output
  @Published private var result = Word.empty
  @Published var isSearching = false
  @Published var definitions = [Definition]()
  
  init() {
    $result
      .compactMap { $0.definitions }
      .assign(to: &$definitions)
  }
  
  func executeQuery() async {
    async {
      isSearching = true
      // pause 1 second to make the effect more abvious
      await Task.sleep(1_000_000_000)
      result = await search(for: searchTerm)
      isSearching = false
    }
  }
  
  private func buildURLRequest(for term: String) -> URLRequest {
    let escapedSearchTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/\(escapedSearchTerm)/definitions")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(wordsAPIKey, forHTTPHeaderField: apiKeyHeader)
    request.setValue(wordsAPIHost, forHTTPHeaderField: apiHostHeader)
    return request
  }
  
  private func search(for term: String) async -> Word {
    // build the request
    let request = buildURLRequest(for: term)
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      return try Word(data: data)
    }
    catch {
      return Word.empty
    }
  }
}


struct WordDetailsView: View {
  @State var word: String
  @StateObject var viewModel = WordDetailsViewModel()
  
  var body: some View {
    ZStack {
      if viewModel.isSearching {
        ProgressView("Fetching...")
      }
      else {
        List {
          Section("Definitions") {
            ForEach(viewModel.definitions) { definition in
              DefinitionView(definition: definition)
            }
          }
          .lineLimit(2)
        }
      }
    }
    .navigationTitle(word)
    .task {
      viewModel.searchTerm = word
      await viewModel.executeQuery()
    }
  }
}

struct WordDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      WordDetailsView(word: "Swift")
    }
  }
}
