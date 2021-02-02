//
//  ArticleAnalyserApp.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import SwiftUI

@main
struct ArticleAnalyserApp: App {
  @StateObject var appState = AppState()
  
  var body: some Scene {
    WindowGroup {
      ArticleListView().environmentObject(appState)
    }
  }
}
