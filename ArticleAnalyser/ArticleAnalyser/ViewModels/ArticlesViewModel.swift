//
//  ArticlesViewModel.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import Foundation

@available(iOS 9999, *)
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
  
  func performAddNewArticle(from url: String) {
    self.isFetching = true
    analyserService.process(url: url) { article in
      DispatchQueue.main.async {
        self.articles.append(article)
        self.isFetching = false
      }
    }
  }
  
  func performAddNewArticleAsync(from url: String) async {
    DispatchQueue.main.async {
      self.isFetching = true
    }

    do {
      let article = try await asyncAnalyserService.process(url: url)
      DispatchQueue.main.async {
        self.articles.append(article)
      }
    }
    catch {
      print(error.localizedDescription)
    }
    
    DispatchQueue.main.async {
      self.isFetching = false
    }
  }
}
