//
//  ArticleAnalyserServiceImplementation.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import Foundation
import SwiftUI
import SwiftSoup
import NaturalLanguage
import OpenGraph

public class ArticleAnalyserService: ArticleAnalyser {
  func fetchArticle(from url: String, completion: @escaping (Result<String, AnalyserError>) -> Void) {
    guard let url =  URL(string: url) else {
      completion(.failure(.badURL))
      return
    }
    
    URLSession.shared.downloadTask(with: url) { (localUrl, urlResponse, error) in
      guard let localUrl = localUrl else {
        completion(.failure(.downloadFailed))
        return
      }
      if let htmlText = try? String(contentsOf: localUrl) {
        completion(.success(htmlText))
      }
    }.resume()
  }
  
  func extractTitle(from html: String, completion: @escaping (Result<String, AnalyserError>) -> Void) {
    do {
      let document = try SwiftSoup.parse(html)
      let title = try document.title()
      completion(.success(title))
    }
    catch {
      completion(.failure(.textExtractionFailed(error)))
    }
  }
  
  func extractText(from html: String, completion: @escaping (Result<String, AnalyserError>) -> Void) {
    do {
      let document = try SwiftSoup.parse(html)
      let text = try document.text()
      completion(.success(text))
    }
    catch {
      completion(.failure(.textExtractionFailed(error)))
    }
  }
  
  func extractImage(from url: String, completion: @escaping (Result<String, AnalyserError>) -> Void) {
    guard let url =  URL(string: url) else {
      completion(.failure(.badURL))
      return
    }
    
    // This header makes sure we request the desktop website, which will prevent Medium from trying to display a "open this in the app" interstitial
    let headers = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36"]

    OpenGraph.fetch(url: url, headers: headers ) { result in
      var resultImage: String?
      switch result {
      case .success(let og):
        if let image = og[.image] {
          resultImage = image
        }
        if let image = og[.imageUrl] {
          resultImage = image
        }
        if let resultImage = resultImage {
          completion(.success(resultImage))
        }
        else {
          completion(.failure(AnalyserError.imageExtractionFailed))
        }
      case .failure(let error):
        print(error)
      }
    }
  }

  
  func fetchImage(for tags: [Tag], completion: (Image) -> Void) {
  }
  
  func inferTags(from text: String, completion: ([Tag]) -> Void) {
    let entities = [
      "Swift": ["Swift", "SwiftUI"],
      "Google Developer Advocate" : ["David East", "Peter Friese", "Todd Kerpelmann"],
      "Programming Language": ["Swift", "JavaScript", "TypeScript"],
      "Functional Reactive Programming": ["Combine"],
      "Sign in with Apple": ["Sign in with Apple"],
      "Firebase Authentication": ["Firebase Authentication"],
    ]
    let gazetteer = try! NLGazetteer(dictionary: entities, language: .english)
    
    let tagger = NLTagger(tagSchemes: [.nameType])
    let options : NLTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
    tagger.string = text
    tagger.setGazetteers([gazetteer], for: .nameType)
    
    let result = tagger.tags(in: text.startIndex ..< text.endIndex, unit: .word, scheme: .nameType, options: options)
      .filter { (tag, tokenRange) in
        ![NLTag.other, NLTag.otherWord].contains(tag)
      }
      .compactMap { tag, tokenRange -> Tag? in
        tag != nil
          ? Tag(title: "\(text[tokenRange])", type: tag!)
          : nil
      }
    
    completion(result.unique())
  }
}
