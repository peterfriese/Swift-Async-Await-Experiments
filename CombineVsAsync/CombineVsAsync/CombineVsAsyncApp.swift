//
//  CombineVsAsyncApp.swift
//  CombineVsAsync
//
//  Created by Peter Friese on 14.06.21.
//

import SwiftUI

@available(iOS 15.0, *)
@main
struct CombineVsAsyncApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        MenuView()
          .navigationBarTitle("Combine vs async")
      }
    }
  }
}
