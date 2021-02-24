//
//  ContentView.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 16.02.21.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = FirebaseAsyncViewModel()
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Firebase Auth")) {
          Text("User ID: \(viewModel.user?.uid ?? "")")
          Button(action: viewModel.signIn) {
            Text("Sign in")
          }
          Button(action: viewModel.signOut) {
            Text("Sign out")
          }
        }
        Section(header: Text("Firebase Functions")) {
          Button(action: viewModel.callHelloWorld) {
            Text("Call helloWorld")
          }
          
          TextField("What's your name", text: $viewModel.name)
          Button(action: viewModel.callMultipleMethods) {
            Text("Call helloUser")
          }
          Text("Greeting: \(viewModel.greeting)")
        }
      }
      .navigationTitle("Firebase & async/await")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
