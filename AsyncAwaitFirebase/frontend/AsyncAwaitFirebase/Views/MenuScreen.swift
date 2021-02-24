//
//  MenuScreen.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 24.02.21.
//

import SwiftUI

struct MenuScreen: View {
  
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Firebase Authentication")) {
          NavigationLink(destination: SignInDemoScreen()) {
            Label("Sign in", systemImage: "key")
          }
        }
        Section(header: Text("Cloud Functions for Firebase")) {
          NavigationLink(destination: FunctionsDemoScreen()) {
            Label("Call a function", systemImage: "key")
          }
        }
        Section(header: Text("Cloud Firestore")) {
          NavigationLink(destination: Text("Cloud Firestore")) {
            Label("Fetch a document", systemImage: "key")
          }
        }

      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("Firebase & async/await")
    }
  }
}

struct MenuScreen_Previews: PreviewProvider {
  static var previews: some View {
    MenuScreen()
  }
}
