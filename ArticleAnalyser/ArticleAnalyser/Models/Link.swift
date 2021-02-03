//
//  Link.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import Foundation

struct ArticleLink: Identifiable {
  var id = UUID().uuidString
  var url: String
}

extension ArticleLink {
  static var samples = [
    ArticleLink(url: "https://www.apple.com/macbook-air/"),
    ArticleLink(url: "https://developer.apple.com/documentation/combine"),
    ArticleLink(url: "https://medium.com/firebase-developers/the-comprehensive-guide-to-github-actions-and-firebase-hosting-818502d86c31"),
    ArticleLink(url: "https://medium.com/firebase-developers/sign-in-with-apple-migrating-user-data-50c8799703c7"),
    ArticleLink(url: "https://peterfriese.dev/ultimate-guide-to-swiftui2-application-lifecycle/")
    ]
}
