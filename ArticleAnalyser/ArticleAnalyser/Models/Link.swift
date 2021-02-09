//
//  Link.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import Foundation

struct ArticleLink: Identifiable {
  let id = UUID().uuidString
  var url: String
}

extension ArticleLink {
  static var samples = [
    ArticleLink(url: "https://www.apple.com/macbook-air/"),
    ArticleLink(url: "https://developer.apple.com/documentation/combine"),
    ArticleLink(url: "https://medium.com/firebase-developers/the-comprehensive-guide-to-github-actions-and-firebase-hosting-818502d86c31"),
    ArticleLink(url: "https://medium.com/firebase-developers/sign-in-with-apple-migrating-user-data-50c8799703c7"),
    ArticleLink(url: "https://peterfriese.dev/ultimate-guide-to-swiftui2-application-lifecycle/"),
    ArticleLink(url: "https://peterfriese.dev/replicating-reminder-swiftui-firebase-part4"),
    ArticleLink(url: "https://medium.com/firebase-developers/updating-data-in-firestore-from-a-swiftui-app-4fc84fce70e8"),
    ArticleLink(url: "http://localhost:9000/async-await-in-swiftui/")
    ]
}
