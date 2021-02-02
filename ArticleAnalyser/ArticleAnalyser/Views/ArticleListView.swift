//
//  ContentView.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import SwiftUI

struct ArticleListView: View {
  @EnvironmentObject var appState: AppState
  
  @State private var isAddArticleViewPresented = false
  
  @ViewBuilder
  var progress: some View {
    if appState.isFetching {
      ProgressView()
    }
    else {
      EmptyView()
    }
  }
  
  var body: some View {
    NavigationView {
      List(appState.articles) { article in
        VStack {
          NavigationLink(destination: ArticleDetailsView(article: .constant(article))) {
            Text(article.title)
          }
        }
      }
      .navigationTitle("Articles")
      .navigationBarItems(trailing:
                            Button(action: { isAddArticleViewPresented.toggle() }) {
                              Image(systemName: "plus")
                            })
      .overlay(progress)
      .sheet(isPresented: $isAddArticleViewPresented) {
        AddArticleView()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleListView()
  }
}
