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
  
  @asyncHandler func helloWorld() {
    let helloWorldCallable = functions.httpsCallable("helloWorld")
    let result = try? await helloWorldCallable.call()
    
    if let data = result?.data as? String {
      DispatchQueue.main.async {
        self.message = data
        self.showResultSheet = true
      }
    }
  }
  
  @asyncHandler func helloUser() {
    let helloUserCallable = functions.httpsCallable("helloUser")
    let result = try? await helloUserCallable.call(name)
    
    if let data = result?.data as? String {
      DispatchQueue.main.async {
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
    SignInDemoScreen()
  }
}
