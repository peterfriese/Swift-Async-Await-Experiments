//
//  FirebaseAsyncViewModel.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 16.02.21.
//

import Foundation
import Firebase

class FirebaseAsyncViewModel: ObservableObject {
  
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
      let result = try await Auth.auth().signInAnonymously()
      //        .signIn(withEmail: "test@test.com", password: "test1234")
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
  
  @asyncHandler func callHelloFunctions() {
    let helloWorld = functions.httpsCallable("helloWorld")
    let result = try? await helloWorld.call()
    
    if let message = (result?.data as? [String: Any])?["message"] as? String {
      print("The function returned: \(message)")
    }
  }
  
}
