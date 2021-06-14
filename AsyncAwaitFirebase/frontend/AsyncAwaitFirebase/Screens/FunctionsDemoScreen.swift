//
//  FunctionsDemoScreen.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 24.02.21.
//

import SwiftUI
import Firebase

@available(iOS 15.0, *)
@MainActor
class FunctionsDemoScreenViewModel: ObservableObject {
  @Published var message: String = ""
  @Published var name: String = "Peter"
  @Published var showResultSheet = false
  
  private lazy var functions = Functions.functions()
  
  init() {
    functions.useEmulator(withHost: "localhost", port: 5001)
  }
  
  func helloWorld() {
    let helloWorldCallable = functions.httpsCallable("helloWorld")
    async {
      do {
        let result = try await helloWorldCallable.call()
        if let data = result.data as? String {
          self.message = data
          self.showResultSheet = true
        }
      }
      catch {
        if let error = error as NSError? {
          if error.domain == FunctionsErrorDomain {
            let code = FunctionsErrorCode(rawValue: error.code)
            let message = error.localizedDescription
            let details = error.userInfo[FunctionsErrorDetailsKey]
            print("There was an error when trying to call the function. \n" +
                  "Code: \(String(describing: code)) \n" +
                  "Message: \(message) \n" +
                  "Details: \(String(describing: details))")
          }
        }
      }
    }
  }
  
  func helloWorldOld() {
    let helloWorldCallable = functions.httpsCallable("helloWorld")
    
    helloWorldCallable.call { result, error in
      if let error = error as NSError? {
        if error.domain == FunctionsErrorDomain {
          let code = FunctionsErrorCode(rawValue: error.code)
          let message = error.localizedDescription
          let details = error.userInfo[FunctionsErrorDetailsKey]
          print("There was an error when trying to call the function. \n" +
                "Code: \(String(describing: code)) \n" +
                "Message: \(message) \n" +
                "Details: \(String(describing: details))")
        }
      }
      
      if let data = result?.data as? String {
        self.message = data
        self.showResultSheet = true
      }
    }
  }
  
  
  func helloUser() {
    let helloUserCallable = functions.httpsCallable("helloUser")
    async {
      let result = try? await helloUserCallable.call(self.name)
      if let data = result?.data as? String {
        self.message = data
        self.showResultSheet = true
      }
    }
  }
  
  func helloUserOld() {
    let helloUserCallable = functions.httpsCallable("helloUser")
    
    helloUserCallable.call(name) { result, error in
      if let error = error as NSError? {
        if error.domain == FunctionsErrorDomain {
          let code = FunctionsErrorCode(rawValue: error.code)
          let message = error.localizedDescription
          let details = error.userInfo[FunctionsErrorDetailsKey]
          print("There was an error when trying to call the function. \n" +
                "Code: \(String(describing: code)) \n" +
                "Message: \(message) \n" +
                "Details: \(String(describing: details))")
        }
      }
      
      if let data = result?.data as? String {
        self.message = data
        self.showResultSheet = true
      }
    }
  }
  
  func multipleCalls() {
    async { [self] in
      let helloWorldCallable = self.functions.httpsCallable("helloWorld")
      let helloUserCallable = self.functions.httpsCallable("helloUser")
      
      async let helloWorldResult = try? helloWorldCallable.call()
      async let helloUserResult = try? helloUserCallable.call(name)
      
      if let helloWorldData = await helloWorldResult?.data as? String, let helloUserData = await helloUserResult?.data as? String {
        self.message = "\(helloWorldData) - \(helloUserData)"
        self.showResultSheet = true
      }
    }
  }
}

@available(iOS 15.0, *)
struct FunctionsDemoScreen: View {
  @StateObject var viewModel = FunctionsDemoScreenViewModel()
  
  var body: some View {
    Form {
      Section(header: Text("Hello World")) {
        Button("Call helloWorld()") {
          viewModel.helloWorld()
        }
      }
      
      Section(header: Text("Hello User (w/ parameter)")) {
        VStack(alignment: .leading) {
          Text("Name")
            .font(.caption)
            .foregroundColor(.accentColor)
          TextField("Enter your name", text: $viewModel.name)
        }
        Button("Call helloUser()") {
          viewModel.helloUser()
        }
      }
      
      Section(header: Text("Multiple calls in parallel")) {
        VStack(alignment: .leading) {
          Text("Name")
            .font(.caption)
            .foregroundColor(.accentColor)
          TextField("Enter your name", text: $viewModel.name)
        }
        Button("Call helloWorld() and helloUser()") {
          viewModel.multipleCalls()
        }
      }
      
    }
    .navigationTitle("Cloud Functions")
    .sheet(isPresented: $viewModel.showResultSheet) {
      Text("\(viewModel.message)")
    }
  }
}

@available(iOS 9999, *)
struct FunctionsDemoScreen_Previews: PreviewProvider {
  static var previews: some View {
    FunctionsDemoScreen()
  }
}
