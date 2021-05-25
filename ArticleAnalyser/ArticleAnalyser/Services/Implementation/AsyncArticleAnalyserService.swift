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

@available(iOS 9999, *)
public class AsyncArticleAnalyserService: AsyncArticleAnalyser {
  func fetchArticle(from url: String) async throws -> String {
    guard let url =  URL(string: url) else {
      throw AnalyserError.badURL
    }
    
    return try await withUnsafeThrowingContinuation { continuation in
      URLSession.shared.downloadTask(with: url) { (localUrl, urlResponse, error) in
        guard let localUrl = localUrl else {
          continuation.resume(throwing: AnalyserError.badURL)
          return
        }
        if let htmlText = try? String(contentsOf: localUrl) {
          continuation.resume(returning: htmlText)
        }
      }
      .resume()
    }
  }
  
  func extractText(from html: String) async throws -> String {
    return try await withUnsafeThrowingContinuation { continuation in
      do {
        let document = try SwiftSoup.parse(html)
        let text = try document.text()
        continuation.resume(returning: text)
      }
      catch {
        continuation.resume(throwing: error)
      }
    }
  }
  
  func extractTitle(from html: String) async throws -> String {
    return try await withUnsafeThrowingContinuation { continuation in
      do {
        let document = try SwiftSoup.parse(html)
        let title = try document.title()
        continuation.resume(returning: title)
      }
      catch {
        continuation.resume(throwing: AnalyserError.textExtractionFailed(error))
      }
    }
  }
  
  func inferTags(from text: String) async -> [Tag] {
    return await withUnsafeContinuation { continuation in
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
      
      continuation.resume(returning: result.unique())
    }
  }
  
  func extractImage(from url: String) async throws -> String {
    return try await withUnsafeThrowingContinuation { continuation in
      guard let url =  URL(string: url) else {
        continuation.resume(throwing: AnalyserError.badURL)
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
