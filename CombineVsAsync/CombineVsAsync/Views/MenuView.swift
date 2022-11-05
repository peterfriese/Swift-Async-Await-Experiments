//
//  MenuView.swift
//  CombineVsAsync
//
//  Created by Peter Friese on 14.06.21.
//

import SwiftUI

@available(iOS 15.0, *)
struct MenuView: View {
  @State var presentSearchBooksView = false
  @State var presentBookSearchAsyncOnReceive = false
  @State var presentBookSearchCombine = false
  
  var body: some View {
    List {
      Button("Search w/ async/await") {
        presentSearchBooksView.toggle()
      }
      Button("Search w/ async/await (live)") {
        presentBookSearchAsyncOnReceive.toggle()
      }
      Button("Search w/ Combine (live)") {
        presentBookSearchCombine.toggle()
      }
    }
    .sheet(isPresented: $presentSearchBooksView) {
      NavigationView {
        BookSearchAsyncOnSubmitView()
      }
    }
    .sheet(isPresented: $presentBookSearchAsyncOnReceive) {
      NavigationView {
        BookSearchAsyncOnReceiveView()
      }
    }
    .sheet(isPresented: $presentBookSearchCombine) {
      NavigationView {
        BookSearchCombineView()
      }
    }

  }
}

@available(iOS 15.0, *)
struct MenuView_Previews: PreviewProvider {
  static var previews: some View {
    MenuView()
  }
}
