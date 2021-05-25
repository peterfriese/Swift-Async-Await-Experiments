//
//  AsyncAwaitFirebaseApp.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 16.02.21.
//

import SwiftUI
import Firebase

@available(iOS 9999, *)
@main
struct AsyncAwaitFirebaseApp: App {
  init() {
    FirebaseApp.configure()
  }
  var body: some Scene {
    WindowGroup {
      MenuScreen()
    }
  }
}
