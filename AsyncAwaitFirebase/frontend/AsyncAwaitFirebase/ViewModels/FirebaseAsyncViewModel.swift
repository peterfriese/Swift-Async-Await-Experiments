//
//  FirebaseAsyncViewModel.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 16.02.21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Book: Codable, Identifiable {
  @DocumentID var id: String?
  var title: String
  var author: String
}

class FirebaseAsyncViewModel: ObservableObject {
  @Published var name: String = ""
  @Published var greeting: String = ""
  
  lazy var functions = Functions.functions()
  
  init() {
    Auth.auth().useEmulator(withHost:"localhost", port:9099)
    functions.useEmulator(withHost: "localhost", port: 5001)
  }
  
  // MARK: - Auth
  
  @Published var user: User?
  
  @asyncHandler
  func signIn() {
    do {
      let result = try await Auth.auth()
//        .signInAnonymously()
        .signIn(withEmail: "test@test.com", password: "test1234")
      let user = result.user
      print("User signed in \(user.isAnonymous ? "anonymously" : "non-anonymously") with user ID \(user.uid)")
      
      DispatchQueue.main.async {
        self.user = user
      }
    }
    catch {
      print(error)
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      self.user = nil
    }
    catch {
      print(error)
    }
  }
  
  // MARK: - Functions
  
  @asyncHandler func callMultipleMethods() {
    let helloWorld = functions.httpsCallable("helloWorld")
    let helloUser = functions.httpsCallable("helloUser")
    
    async let worldGreeting = try? helloWorld.call()
    async let userGreeting = try? helloUser.call(self.name)
    
    if let w = await worldGreeting?.data, let u = await userGreeting?.data {
      print("The result is: \(w), \(u)")
      DispatchQueue.main.async {
        self.greeting = "The result is: \(w), \(u)"
      }
    }
  }
  
  @asyncHandler func callHelloWorld() {
    let helloWorld = functions.httpsCallable("helloWorld")
    let result = try? await helloWorld.call()
    
    if let message = (result?.data as? [String: Any])?["message"] as? String {
      print("The function returned: \(message)")
    }
  }
  
  @asyncHandler func callHelloUser() {
    let helloUser = functions.httpsCallable("helloUser")
    let result = try? await helloUser.call(self.name)
    
    guard let message = (result?.data as? [String: Any])?["message"] as? String else {
      DispatchQueue.main.async {
        self.greeting = ""
      }
      return
    }
    DispatchQueue.main.async {
      self.greeting = message
    }
  }

  
  // MARK: - Firestore
  
  @asyncHandler func fetchSingleBook() {
    do {
      let document = try await Firestore.firestore().document("books/book-42").getDocument()
      if let book = try document.data(as: Book.self) {
        print(book.title)
      }
    }
    catch {
      print(error)
    }
  }
  
  @asyncHandler func fetchBooks() {
    let result = await Firestore.firestore().collection("books").addSnapshotListener { snapshot, error in
    }
  }
  
}
