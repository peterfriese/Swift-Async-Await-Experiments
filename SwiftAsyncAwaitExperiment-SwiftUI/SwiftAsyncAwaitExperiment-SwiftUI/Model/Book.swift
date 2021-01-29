//
//  Book.swift
//  SwiftAsyncAwaitExperiment-SwiftUI
//
//  Created by Peter Friese on 06/01/2021.
//

import Foundation
import UIKit

struct BookSearchResult: Codable {
  var books: [Book]
  
  enum CodingKeys: String, CodingKey {
    case books = "docs"
  }
}

struct Book: Codable, Identifiable {
  var id = UUID().uuidString
  var title: String
  var authors: [String]
  var isbns: [String]?
  var image: UIImage?
  
  enum CodingKeys: String, CodingKey {
    case title
    case authors = "author_name"
    case isbns = "isbn"
  }
}

extension Book {
  var mainAuthor: String {
    return authors[0]
  }
}
