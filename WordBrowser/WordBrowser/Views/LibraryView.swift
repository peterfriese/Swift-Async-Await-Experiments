


//
//  LibraryView.swift
//  WordBrowser
//
//  Created by Peter Friese on 18.06.21.
//

import SwiftUI
import Combine

@MainActor
class LibraryViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var randomWord = "partially"
  @Published var tips: [String] = ["Swift", "authentication", "authorization"]
  @Published var favourites: [String] = ["stunning", "brilliant", "marvelous"]
  
  @Published var filteredTips = [String]()
  @Published var filteredFavourites = [String]()
  
  init() {
    Publishers.CombineLatest($searchText, $tips)
      .map { filter, items in
        items.filter { item in
          filter.isEmpty ? true : item.contains(filter)
        }
      }
      .assign(to: &$filteredTips)
    
    Publishers.CombineLatest($searchText, $favourites)
      .map { filter, items in
        items.filter { item in
          filter.isEmpty ? true : item.contains(filter)
        }
      }
      .assign(to: &$filteredFavourites)
  }
  
  private func buildURLRequest() -> URLRequest {
    let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/?random=true")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(wordsAPIKey, forHTTPHeaderField: apiKeyHeader)
    request.setValue(wordsAPIHost, forHTTPHeaderField: apiHostHeader)
    return request
  }
  
  private func fetchRandomWord() async -> Word {
    // build the request
    let request = buildURLRequest()
    
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw WordsAPI.invalidServerResponse
      }
      let word = try JSONDecoder().decode(Word.self, from: data)
      return word
    }
    catch {
      return Word.empty
    }
  }

  
  func addFavourite(_ word: String) {
    favourites.append(word)
  }
  
  func refresh() async {
    let result = await fetchRandomWord()
    randomWord = result.word
  }
}

struct LibraryView: View {
  @StateObject var viewModel = LibraryViewModel()
  @State var isAddNewWordDialogPresented = false
  
  var body: some View {
    List {
      SectionView("Random word", word: viewModel.randomWord)
      SectionView("Peter's Tips", words: viewModel.filteredTips)
      SectionView("My favourites", words: viewModel.filteredFavourites)
    }
    .searchable(text: $viewModel.searchText)
    .refreshable {
      await viewModel.refresh()
    }
    .listStyle(.insetGrouped)
    .navigationTitle("Library")
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(action: { isAddNewWordDialogPresented.toggle() }) {
          Image(systemName: "plus")
        }
      }
    }
    .sheet(isPresented: $isAddNewWordDialogPresented) {
      NavigationView {
        AddWordView { newWord in
          viewModel.addFavourite(newWord)
        }
      }
    }
    .task {
      await viewModel.refresh()
    }
  }
}

struct SectionView: View {
  var title: String
  var words: [String]
  
  init(_ title: String, word: String) {
    self.title = title
    self.words = [word]
  }
  
  init(_ title: String, words: [String]) {
    self.title = title
    self.words = words
  }
  
  var body: some View {
    Section(title) {
      if words.count == 0 {
        Text("(No items match your filter criteria)")
      }
      else {
        ForEach(words, id: \.self) { word in
          LibraryRowView(word: word)
        }
      }
    }
  }
}

struct LibraryRowView: View {
  var word: String
  var body: some View {
    NavigationLink(destination: WordDetailsView(word: word)) {
      Text(word)
    }
  }
}

struct LibraryView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LibraryView()
    }
  }
}

