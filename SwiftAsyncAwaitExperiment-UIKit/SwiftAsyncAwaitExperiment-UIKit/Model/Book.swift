//
//  Book.swift
//  SwiftAsyncAwaitExperiment-UIKit
//
//  Created by Peter Friese on 06/01/2021.
//

import Foundation

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
  
  enum CodingKeys: String, CodingKey {
    case title
    case authors = "author_name"
    case isbns = "isbn"
  }
}
