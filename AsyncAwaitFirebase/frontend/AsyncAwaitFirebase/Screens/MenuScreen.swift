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
        Section(header: Text("Demos")) {
          NavigationLink(destination: SignInDemoScreen()) {
            Label("Firebase Authentication", systemImage: "key")
          }
          NavigationLink(destination: FunctionsDemoScreen()) {
            Label("Cloud Functions", systemImage: "gearshape.2")
          }
          NavigationLink(destination: FirestoreDemoScreen()) {
            Label("Cloud Firestore", systemImage: "externaldrive.badge.icloud")
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
