//
//  ArticleDetailsView.swift
//  ArticleAnalyser
//
//  Created by Peter Friese on 02.02.21.
//

import SwiftUI

struct ArticleDetailsView: View {
  @Binding var article: Article
  
  var body: some View {
    List(article.tags, id: \.title) { tag in
      Text(tag.title)
    }
    .navigationTitle(article.title)
  }
}

struct ArticleDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleDetailsView(article: .constant(Article.samples[0]))
  }
}
