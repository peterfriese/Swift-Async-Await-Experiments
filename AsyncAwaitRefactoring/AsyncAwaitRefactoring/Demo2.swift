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
  @available(*, deprecated, message: "Prefer async alternative instead")
func sayHello(name: String, completion: @escaping (String) -> Void) {
  async {
    let result = await sayHello(name: name)
    completion(result)
  }
}
  
  
func sayHello(name: String) async -> String {
  return "Hello, \(name)"
}
  
  func fetchTodo(id: Int, completion: @escaping (Todo) -> Void) {
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(id)")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        do {
          let todo = try decoder.decode(Todo.self, from: data)
            completion(todo)
        }
        catch {
        }
      }
    }.resume()
  }
  
}
