//
//  ContentView.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import SwiftUI

@available(iOS 15.0, *)
struct ArticleListView: View {
  @StateObject var viewModel = ArticlesViewModel()
  
  @State private var isAddArticleViewPresented = false
  
  @ViewBuilder
  var progress: some View {
    if viewModel.isFetching {
      ProgressView()
    }
    else {
      EmptyView()
    }
  }

  var body: some View {
    NavigationView {
      List(viewModel.articles) { article in
        VStack {
          NavigationLink(destination: ArticleDetailsView(article: .constant(article))) {
            HStack {
              Text(article.title)
              Spacer()
              AsyncImage(url: article.imageUrl) { image in
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 75, height: 75, alignment: .center)
                  .cornerRadius(8.0)
              } placeholder: {
                Image(systemName: "scribble.variable")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .padding()
                  .background(Color("AccentColor"))
                  .frame(width: 75, height: 75, alignment: .center)
                  .cornerRadius(8.0)

              }
            }
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
        AddArticleView(viewModel: self.viewModel)
      }
    }
  }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleListView()
  }
}
