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
      HStack {
        Text(tag.title)
        Spacer()
        Text(tag.type.rawValue)
          .padding([.horizontal], 8)
          .padding([.vertical], 4)
          .foregroundColor(Color(UIColor.secondaryLabel))
          .background(Color(UIColor.secondarySystemBackground))
          .cornerRadius(8)
      }
    }
    .navigationTitle(article.title)
  }
}

struct ArticleDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    ArticleDetailsView(article: .constant(Article.samples[0]))
  }
}
