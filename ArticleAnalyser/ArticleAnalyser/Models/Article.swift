//
//  Artifact.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import Foundation
import SwiftUI
import NaturalLanguage

struct Tag {
  var title: String
  var type: NLTag
}

extension Tag: Equatable, Hashable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.title == rhs.title
  }
}

extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    return filter { seen.insert($0).inserted }
  }
}

struct Article: Identifiable {
  let id = UUID().uuidString
  var url: String
  var title: String
  var tags: [Tag]
  var imageUrlString: String?
  var imageUrl: URL? {
    guard let imageUrlString = imageUrlString else { return nil }
    return URL(string: imageUrlString)
  }
}

extension Article {
  static let samples = [
    Article(url: "https://www.apple.com/macbook-air/", title: "MacBook Air - Apple", tags: [Tag(title: "Swift", type: NLTag("Swift"))]),
    Article(url: "https://developer.apple.com/documentation/combine", title: "Combine - Apple Documentation", tags: [Tag(title: "Swift", type: NLTag("Swift"))]),
    Article(url: "https://medium.com/firebase-developers/the-comprehensive-guide-to-github-actions-and-firebase-hosting-818502d86c31", title: "The comprehensive guide to GitHub Actions and Firebase Hosting", tags: [Tag(title: "Swift", type: NLTag("Swift"))]),
  ]
}
