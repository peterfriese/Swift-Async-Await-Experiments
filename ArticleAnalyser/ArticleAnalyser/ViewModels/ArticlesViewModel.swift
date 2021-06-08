//
//  ArticlesViewModel.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import Foundation

@available(iOS 15.0, *)
class ArticlesViewModel: ObservableObject {
  @Published var articles = [Article]()
  @Published var links = ArticleLink.samples
  @Published var isFetching = false
  
  private var analyserService = ArticleAnalyserService()
  private var asyncAnalyserService = AsyncArticleAnalyserService()
  
  func addNewArticle(from url: String) async {
    //    performAddNewArticle(from: url)
    await performAddNewArticleAsync(from: url)
  }
  
  @MainActor
  func performAddNewArticle(from url: String) {
    self.isFetching = true
    analyserService.process(url: url) { article in
      self.articles.append(article)
      self.isFetching = false
    }
  }
  
  @MainActor
  func performAddNewArticleAsync(from url: String) async {
    self.isFetching = true
    
    do {
      let article = try await asyncAnalyserService.process(url: url)
      self.articles.append(article)
    }
    catch {
      print(error.localizedDescription)
    }
    
    self.isFetching = false
  }
}
