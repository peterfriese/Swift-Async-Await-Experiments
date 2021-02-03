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
  private var asyncAnalyserService = AsyncArticleAnalyserService()
  
  func addNewArticle(from url: String) {
    //    performAddNewArticle(from: url)
    performAddNewArticleAsync(from: url)
  }
  
  func performAddNewArticle(from url: String) {
    self.isFetching = true
    analyserService.process(url: url) { article in
      DispatchQueue.main.async {
        self.articles.append(article)
        self.isFetching = false
      }
    }
  }
  
  
  @asyncHandler func performAddNewArticleAsync(from url: String) {
    DispatchQueue.main.async {
      self.isFetching = true
    }
    do {
      let article = try await asyncAnalyserService.process(url: url)
      DispatchQueue.main.async {
        self.articles.append(article)
        self.isFetching = false
      }
    }
    catch {
      print(error.localizedDescription)
    }
  }
}
