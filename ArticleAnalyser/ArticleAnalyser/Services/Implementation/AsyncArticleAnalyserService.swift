//
//  AsyncArticleAnalyserImplementation.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 03.02.21.
//

import Foundation
import SwiftSoup
import NaturalLanguage
import OpenGraph

@available(iOS 15.0, *)
public class AsyncArticleAnalyserService: AsyncArticleAnalyser {
  func fetchArticle(from url: String) async throws -> String {
    guard let url =  URL(string: url) else {
      throw AnalyserError.badURL
    }
    
    let (localUrl, response) = try await URLSession.shared.download(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw AnalyserError.downloadFailed
    }
    
    let htmlText = try String(contentsOf: localUrl)
    return htmlText
  }
  
  func extractText(from html: String) throws -> String {
    do {
      let document = try SwiftSoup.parse(html)
      return try document.text()
    }
    catch {
      throw AnalyserError.textExtractionFailed(error)
    }
  }
  
  func extractTitle(from html: String) throws -> String {
    do {
      let document = try SwiftSoup.parse(html)
      return try document.title()
    }
    catch {
      throw AnalyserError.textExtractionFailed(error)
    }
  }
  
  func inferTags(from text: String) -> [Tag] {
    let entities = [
      "Swift": ["Swift", "SwiftUI"],
      "Google Developer Advocate" : ["Todd Kerpelman", "David East", "Sumit Chandel", "Patrick Martin", "Peter Friese"],
      "Programming Language": ["Swift", "JavaScript", "TypeScript", "Java", "C#"],
      "Functional Reactive Programming": ["Combine"],
      "concurrency": ["async", "await", "async/await"],
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
    
    return result.unique()
  }
  
  func extractImage(from url: String) async throws -> String {
    guard let url =  URL(string: url) else {
      throw AnalyserError.badURL
    }
    
    // This header makes sure we request the desktop website, which will prevent Medium from trying to display a "open this in the app" interstitial
    let headers = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36"]
    
    return try await withUnsafeThrowingContinuation { continuation in
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
            continuation.resume(returning: resultImage)
          }
          else {
            continuation.resume(returning: "")
          }
        case .failure(let error):
          continuation.resume(throwing: AnalyserError.metaDataExtractionError(error))
        }
      }
    }
  }
}
