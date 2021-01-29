//
//  BooksViewModel.swift
//  SwiftAsyncAwaitExperiment-SwiftUI
//
//  Created by Peter Friese on 14.01.21.
//

import Foundation

class BooksViewModel: ObservableObject {
  @Published var books = [Book]()
  
  let bookService = OpenLibraryService()
  let asyncOpenLibraryService = OpenLibraryServiceAsync()
  
  func fetchBooksAndCoversUsingClosures(author: String) {
    bookService.searchBooks(author: author) { books in
      var booksAndCovers = [Book]()
      DispatchQueue.global().async {
        print("Starting the loop")
        books.forEach { book in
          guard let isbn = book.isbns?[0] else { return }
          self.bookService.fetchCover(isbn: isbn, size: .large) { image in
            print("Received cover for \(book.title)")
            var bookAndCover = book
            bookAndCover.image = image
            booksAndCovers.append(bookAndCover)
          }
        }
        print("Finished the loop")
      }
    }
  }
  
  @asyncHandler func fetchBooksAndCoversUsingAsyncAwait() {
    print("Fetching")
    self.books = [Book(title: "TEST", authors: ["PETER"])]
    
    guard let books = await asyncOpenLibraryService.searchBooks(author: "Matthew Walker") else { return }
    print("Done. Fetched \(books.count) books.")
    
    print("Now fetching covers")
    for book in books {
      guard let isbn = book.isbns?[0] else { continue }
      print("Fetching cover for [\(isbn), \(book.title)]")
      let image = await asyncOpenLibraryService.fetchCover(isbn: isbn, size: .large)
      print("Received cover for [\(isbn), \(book.title)]")
    }
    
    print("Fetching - done")
    DispatchQueue.main.async {
      self.books = books
    }
  }

}
