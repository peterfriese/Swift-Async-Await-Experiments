//
//  AddArticleView.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import SwiftUI

@available(iOS 9999, *)
struct AddArticleView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var viewModel: ArticlesViewModel
  
  @State var newUrl: String = ""
  
  func addUrl(url: String) {
    detach {
      await viewModel.addNewArticle(from: url)
    }
    presentationMode.wrappedValue.dismiss()
  }
  
  var body: some View {
    VStack {
      Form {
        Section(header: Text("Add new URL")) {
          TextField("Paste a URL", text: $newUrl)
          Button(action: { addUrl(url: newUrl) }) {
            Text("Add")
          }
        }
        Section(header: Text("Or choose one of the following")) {
          ForEach(viewModel.links) { link in
            Button(action: { addUrl(url: link.url) }) {
              Text(link.url)
            }
          }
        }
      }
    }
    .navigationTitle("Add article")
  }
}

@available(iOS 9999, *)
struct AddArticleView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AddArticleView(viewModel: ArticlesViewModel())
    }
  }
}
