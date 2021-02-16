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
        Button(action: viewModel.callHelloFunctions) {
          Text("Call helloWorld")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
