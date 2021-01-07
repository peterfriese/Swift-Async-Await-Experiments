//
//  URLSession+Concurrency.swift
//  SwiftAsyncAwaitExperiment-UIKit
//
//  Created by Peter Friese on 07/01/2021.
//

import Foundation

// The following code is courtesy of
// https://forums.swift.org/t/pitch-2-structured-concurrency/43452/32
extension URLSession {
  func asyncDataTask(with url: URL) async -> (Data?, URLResponse?, Error?) {
    await withUnsafeContinuation { continuation in
      let dataTask = self.dataTask(with: url) { data, response, error in
        continuation.resume(returning: (data, response, error))
      }
      _ = Task.runDetached {
        dataTask.resume()
        // Task.withCancellationHandler throws "is not implented yet"
//        return try await Task.withCancellationHandler(handler: {
//          dataTask.cancel()
//        }) {
//          dataTask.resume()
//        }
      }
    }
  }
}
