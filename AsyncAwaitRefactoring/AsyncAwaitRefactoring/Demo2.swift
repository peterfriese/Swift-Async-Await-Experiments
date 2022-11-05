//
//  Demo.swift
//  AsyncAwaitRefactoring
//
//  Created by Peter Friese on 08.06.21.
//

import Foundation

enum TodosError: Error {
  case invalidServerResponse
}

struct Todo: Identifiable, Codable {
  var userId: Int
  var id: Int
  var title: String
  var completed: Bool
}

@available(iOS 15.0, *)
struct Demo2 {
  @available(*, renamed: "sayHello(name:)")
  func sayHello(name: String, completion: @escaping (String) -> Void) {
    completion("Hello, \(name)")
  }
  
  func sayHello(name: String) async -> String {
    return await withCheckedContinuation { continuation in
      sayHello(name: name) { result in
        continuation.resume(returning: result)
      }
    }
  }
  
  
  @available(*, deprecated, message: "Prefer async alternative instead")
func fetchTodo(id: Int, completion: @escaping (Todo) -> Void) {
  async {
    let result = await fetchTodo(id: id)
    completion(result)
  }
}
  
  
func fetchTodo(id: Int) async -> Todo {
  let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(id)")!
  
  URLSession.shared.dataTask(with: url) { data, response, error in
    if let data = data {
      let decoder = JSONDecoder()
      do {
        let todo = try decoder.decode(Todo.self, from: data)
        <#completion#>(todo)
      }
      catch {
      }
    }
  }.resume()
}
  
}
