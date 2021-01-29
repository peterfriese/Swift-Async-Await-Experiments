//
//  ContentView.swift
//  SwiftAsyncAwaitExperiment-SwiftUI
//
//  Created by Peter Friese on 14.01.21.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = BooksViewModel()
  
  var body: some View {
    Text("Hallo. \(viewModel.books.count)")
    List(viewModel.books) { book in
      HStack {
        if let image = book.image {
          Image(uiImage: image)
        }
        VStack {
          Text(book.title)
          Text(book.mainAuthor)
        }
      }
    }
    .onAppear() {
//      viewModel.fetchBooksAndCoversUsingClosures(author: "Matthew Walker")
      viewModel.fetchBooksAndCoversUsingAsyncAwait()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
