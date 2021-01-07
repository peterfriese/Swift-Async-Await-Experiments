//
//  OpenLibraryService.swift
//  SwiftAsyncAwaitExperiment-UIKit
//
//  Created by Peter Friese on 06/01/2021.
//

import Foundation
import UIKit

enum CoverSize: String {
  case small = "S"
  case medium = "M"
  case large = "L"
}

class OpenLibraryService {
  func searchBooks(author: String, completion: @escaping ([Book]) -> Void) {
    let authorQueryString = author.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? author
    let searchUrl = URL(string: "http://openlibrary.org/search.json?author=\(authorQueryString)")
    
    if let url = searchUrl {
      URLSession.shared.dataTask(with: url) { data, urlResponse, error in
        do {
          if let booksData = data {
            let decodedBookSearchResult = try JSONDecoder().decode(BookSearchResult.self, from: booksData)
            let books = decodedBookSearchResult.books
            completion(books)
          }
          else {
            print("No data")
          }
        }
        catch {
          print("Error: \(error)")
        }
      }
      .resume()
    }
  }
  
  func fetchCover(isbn: String, size: CoverSize, completion: @escaping (UIImage?) -> Void) {
    let coverUrl = URL(string: "http://covers.openlibrary.org/b/isbn/\(isbn)-\(size.rawValue).jpg")
    
    if let url = coverUrl {
      URLSession.shared.dataTask(with: url) { data, urlResponse, error in
        if let responseData = data, let image = UIImage(data: responseData) {
          completion(image)
        }
      }
      .resume()
    }
  }
}

class OpenLibraryServiceAsync {
  func searchBooks(author: String) async -> [Book]? {
    let authorQueryString = author.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? author
    let searchUrl = URL(string: "http://openlibrary.org/search.json?author=\(authorQueryString)")
    
    if let url = searchUrl {
      let (data, _, _) = await URLSession.shared.asyncDataTask(with: url)
      if let booksData = data {
        do {
          let decodedBookSearchResult = try JSONDecoder().decode(BookSearchResult.self, from: booksData)
          let books = decodedBookSearchResult.books
          return books
        }
        catch {
          print("Error: \(error)")
        }
      }
    }
    return nil
  }
  
  func fetchCover(isbn: String, size: CoverSize) async -> UIImage? {
    let coverUrl = URL(string: "http://covers.openlibrary.org/b/isbn/\(isbn)-\(size.rawValue).jpg")
    
    if let url = coverUrl {
      let (data, _, _) = await URLSession.shared.asyncDataTask(with: url)
      if let responseData = data, let image = UIImage(data: responseData) {
        return image
      }
    }
    return nil
  }
}
