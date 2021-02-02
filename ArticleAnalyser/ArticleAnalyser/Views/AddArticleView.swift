//
//  AddArticleView.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import SwiftUI

struct AddArticleView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var appState: AppState
  
  @State var newUrl: String = ""
  
  func addUrl(url: String) {
    appState.addNewArticle(from: url)
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
          ForEach(appState.links) { link in
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

struct AddArticleView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AddArticleView()
    }
  }
}
