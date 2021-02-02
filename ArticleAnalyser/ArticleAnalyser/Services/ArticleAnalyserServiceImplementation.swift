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
  
  func fetchImage(for tags: [Tag], completion: (Image) -> Void) {
  }
  
  func inferTags(from text: String, completion: ([Tag]) -> Void) {
    //    var result = [Tag]()
    
    let entities = [
      "Swift": ["Swift", "SwiftUI"],
      "Google Developer Advocate" : ["David East", "Peter Friese", "Todd Kerpelmann"],
      "Programming Language": ["Swift", "JavaScript", "TypeScript"],
      "Functional Reactive Programming": ["Combine"]
    ]
    let gazetteer = try! NLGazetteer(dictionary: entities, language: .english)
    
    let tagger = NLTagger(tagSchemes: [.nameType])
    let options : NLTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
    tagger.string = text
    tagger.setGazetteers([gazetteer], for: .nameType)
    
    let result = tagger.tags(in: text.startIndex ..< text.endIndex, unit: .word, scheme: .nameType, options: options)
      .compactMap { tag, tokenRange -> Tag? in
        tag != nil
          ? Tag(title: "\(text[tokenRange])", type: tag!)
          : nil
      }
    completion(result)
  }
}
