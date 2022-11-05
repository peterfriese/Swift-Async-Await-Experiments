// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let word = try? newJSONDecoder().decode(Word.self, from: jsonData)

import Foundation

// MARK: - Word
struct Word {
  let word: String
  let definitions: [Definition]?
}

extension Word {
  static let empty = Word(word: "(no result)",
                          definitions: [
                            Definition(definition: "(no result))", partOfSpeech: "no result"),
                          ])
  
  static let sample = Word(word: "Swift",
                           definitions: [
                            Definition(definition: "moving very fast", partOfSpeech: "adjective"),
                            Definition(definition: "a small bird that resembles a swallow and is noted for its rapid flight", partOfSpeech: "noun"),
                           ])
}

extension Word: Codable {
  init(data: Data) throws {
    self = try JSONDecoder().decode(Word.self, from: data)
  }
}

// MARK: - Definition
struct Definition: Codable {
  let definition: String
  let partOfSpeech: String
}

extension Definition: Identifiable {
  var id: String { self.definition }
}
