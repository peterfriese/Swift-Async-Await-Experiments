//
//  FunctionsDemoScreen.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 24.02.21.
//

import SwiftUI
import Firebase

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
  
  @asyncHandler func multipleCalls() {
    let helloWorldCallable = functions.httpsCallable("helloWorld")
    let helloUserCallable = functions.httpsCallable("helloUser")
    
    async let helloWorldResult = try? helloWorldCallable.call()
    async let helloUserResult = try? helloUserCallable.call(name)
    
    if let helloWorldData = await helloWorldResult?.data as? String, let helloUserData = await helloUserResult?.data as? String {
      DispatchQueue.main.async {
        self.message = "\(helloWorldData) - \(helloUserData)"
        self.showResultSheet = true
      }
    }
  }
}

struct FunctionsDemoScreen: View {
  @StateObject var viewModel = FunctionsDemoScreenViewModel()
  
  var body: some View {
    Form {
      Section(header: Text("Hello World")) {
        Button(action: viewModel.helloWorld) {
          Text("Call helloWorld()")
        }
      }
      
      Section(header: Text("Hello User (w/ parameter)")) {
        VStack(alignment: .leading) {
          Text("Name")
            .font(.caption)
            .foregroundColor(.accentColor)
          TextField("Enter your name", text: $viewModel.name)
        }
        Button(action: viewModel.helloUser) {
          Text("Call helloUser()")
        }
      }
      
      Section(header: Text("Multiple calls in parallel")) {
        VStack(alignment: .leading) {
          Text("Name")
            .font(.caption)
            .foregroundColor(.accentColor)
          TextField("Enter your name", text: $viewModel.name)
        }
        Button(action: viewModel.multipleCalls) {
          Text("Call helloWorld and helloUser()")
        }
      }

    }
    .navigationTitle("Cloud Functions")
    .sheet(isPresented: $viewModel.showResultSheet) {
      Text("\(viewModel.message)")
    }
  }
}

struct FunctionsDemoScreen_Previews: PreviewProvider {
  static var previews: some View {
    FunctionsDemoScreen()
  }
}
