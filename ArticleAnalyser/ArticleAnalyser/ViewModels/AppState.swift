//
//  AppState.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import Foundation

class AppState: ObservableObject {
  @Published var articles = [Article]()
  @Published var links = ArticleLink.samples
  @Published var isFetching = false
  
  private var analyserService = ArticleAnalyserService()
  
  func addNewArticle(from url: String) {
    self.isFetching = true
    analyserService.process(url: url) { article in
      DispatchQueue.main.async {
        self.articles.append(article)
        self.isFetching = false
      }
    }
  }
}
