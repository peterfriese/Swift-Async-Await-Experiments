//
//  ViewController.swift
//  SwiftAsyncAwaitExperiment-UIKit
//
//  Created by Peter Friese on 06/01/2021.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var coverImage: UIImageView!
  
  let openLibraryService = OpenLibraryService()
  let asyncOpenLibraryService = OpenLibraryServiceAsync()
  
  @IBAction func buttonTapped(_ sender: Any) {
    fetchBooksAndCoversWithClosures()
  }
  
  @IBAction func buttonFetchUsingAsyncAwaitTapped(_ sender: Any) {
    fetchBooksAndCoversUsingAsyncAwait()
  }
  
  func fetchBooksAndCoversWithClosures() {
    print("Fetching")
    openLibraryService.searchBooks(author: "Matthew Walker") { books in
      print("Done. Fetched \(books.count) books.")
      
      print("Now fetching covers")
      books.forEach { book in
        if let isbn = book.isbns?[0] {
          print("Fetching cover for [\(isbn), \(book.title)]")
          self.openLibraryService.fetchCover(isbn: isbn, size: .large) { image in
            print("Received cover for [\(isbn), \(book.title)]")
            DispatchQueue.main.async {
              self.coverImage.image = image
            }
          }
        }
      }
      print("Fetching - done")
    }
  }
  
  @asyncHandler func fetchBooksAndCoversUsingAsyncAwait() {
    print("Fetching")
    guard let books = await asyncOpenLibraryService.searchBooks(author: "Matthew Walker") else { return }
    print("Done. Fetched \(books.count) books.")
    
    print("Now fetching covers")
    for book in books {
      guard let isbn = book.isbns?[0] else { continue }
      print("Fetching cover for [\(isbn), \(book.title)]")
      let image = await asyncOpenLibraryService.fetchCover(isbn: isbn, size: .large)
      print("Received cover for [\(isbn), \(book.title)]")
      DispatchQueue.main.async {
        self.coverImage.image = image
      }
    }
    print("Fetching - done")
  }
  
}

