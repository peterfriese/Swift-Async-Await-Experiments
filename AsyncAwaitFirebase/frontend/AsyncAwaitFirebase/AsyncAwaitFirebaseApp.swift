//
//  AsyncAwaitFirebaseApp.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 16.02.21.
//

import SwiftUI
import Firebase

@main
struct AsyncAwaitFirebaseApp: App {
  init() {
    FirebaseApp.configure()
  }
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
