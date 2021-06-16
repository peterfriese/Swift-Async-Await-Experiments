//
//  ContentView.swift
//  WordBrowser
//
//  Created by Peter Friese on 16.06.21.
//

import SwiftUI

@MainActor
class WordsAPIViewModel: ObservableObject {
  @Published var searchTerm: String = ""
  @Published var isSearching = false
  
  @Published var result = Word.sample
  
  func executeQuery() async {
    async {
      let currentSearchTerm = searchTerm
      let date = Date().formatted(.iso8601)
      print("Search: \(currentSearchTerm).")
      isSearching.toggle()
      result = await search(for: currentSearchTerm)
      isSearching.toggle()
      print("Search: \(currentSearchTerm) - returned \(result.word) Was sent at \(date)")
    }
  }
  
  private func search(for term: String) async -> Word {
    // build the request
    let escapedSearchTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/\(escapedSearchTerm)/definitions")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(wordsAPIKey, forHTTPHeaderField: apiKeyHeader)
    request.setValue(wordsAPIHost, forHTTPHeaderField: apiHostHeader)
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      return try Word(data: data)
    }
    catch {
      return Word.empty
    }
  }
}

struct WordSearchView: View {
  @StateObject var viewModel = WordsAPIViewModel()
  var body: some View {
    List {
      Text(viewModel.result.word)
      Section("Definitions") {
        ForEach(viewModel.result.definitions) { definition in
          DefinitionView(definition: definition)
        }
      }
    }
    .searchable(text: $viewModel.searchTerm)
    .overlay {
      if viewModel.isSearching {
        ProgressView()
      }
    }
    .onSubmit(of: .search) {
      async {
        await viewModel.executeQuery()
      }
    }
    .navigationTitle("Definitions")
  }
}

struct DefinitionView: View {
  var definition: Definition
  var body: some View {
    VStack(alignment: .leading) {
      Text("(\(definition.partOfSpeech))")
        .font(.caption)
      Text(definition.definition)
    }
  }
}

struct WordSearchView_Previews: PreviewProvider {
  static var previews: some View {
    WordSearchView()
  }
}
