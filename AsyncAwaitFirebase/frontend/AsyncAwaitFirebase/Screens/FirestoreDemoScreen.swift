//
//  FirestoreDemoScreen.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 24.02.21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Favourites: Codable {
  @DocumentID var id: String?
  var fruit: String
  var number: Int
}

class FirestoreDemoScreenViewModel: ObservableObject {
  @Published var favourites = Favourites(fruit: "", number: 0)
  
  private lazy var firestore = Firestore.firestore()
  
  init() {
    let settings = firestore.settings
    settings.isPersistenceEnabled = false
    settings.isSSLEnabled = false
    firestore.settings = settings
    firestore.useEmulator(withHost: "localhost", port: 8080)
  }
  
  func saveFavourites() {
    do {
      try firestore.collection("favourites").document("sample").setData(from: favourites) { error in
        if let error = error {
          print("Error writing document: \(error)")
        }
        else {
          print("Document saved successfully")
        }
      }
    }
    catch {
      print("Error writing document: \(error)")
    }
  }
  
  func fetchFavourites() {
    firestore.collection("favourites").document("sample").getDocument { documentSnapshot, error in
      do {
        if let favourites = try documentSnapshot?.data(as: Favourites.self) {
          self.favourites = favourites
        }
      }
      catch {
        print(error)
      }
    }
  }
  
  func clearForm() {
    favourites.fruit = ""
    favourites.number = 0
  }
  
}

struct FirestoreDemoScreen: View {
  @StateObject var viewModel = FirestoreDemoScreenViewModel()
  
  var body: some View {
    Form {
      Section(header: Text("Favourites")) {
        VStack(alignment: .leading) {
          Text("Fruit")
            .font(.caption)
            .foregroundColor(.accentColor)
          TextField("What's your favourite fruit?", text: $viewModel.favourites.fruit)
        }
        VStack(alignment: .leading) {
          Text("Number")
            .font(.caption)
            .foregroundColor(.accentColor)
          TextField("What's your favourite number?", value: $viewModel.favourites.number, formatter: NumberFormatter())
        }
      }
      Section{
        Button(action: viewModel.clearForm) {
          Text("Clear form")
        }
        Button(action: viewModel.fetchFavourites) {
          Text("Fetch favourites")
        }
        Button(action: viewModel.saveFavourites) {
          Text("Save favourites")
        }
      }
      
    }
    .navigationTitle("Cloud Firestore")
  }
}

struct FirestoreDemoScreen_Previews: PreviewProvider {
  static var previews: some View {
    FirestoreDemoScreen()
  }
}
