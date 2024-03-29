//
//  SignInDemoScreen.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 24.02.21.
//

import SwiftUI
import Firebase
import Combine

@available(iOS 15.0, *)
@MainActor
class SignInDemoScreenViewModel: ObservableObject {
  @Published var email: String = "test@test.com"
  @Published var password: String = "test1234"
  
  @Published private(set) var user: User?
  @Published private(set) var isSignedIn = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    Auth.auth().useEmulator(withHost:"localhost", port:9099)
    $user
      .map { $0 != nil }
      .assign(to: \.isSignedIn, on: self)
      .store(in: &cancellables)
  }
  
  func signIn() {
    Task {
      do {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.user = result.user
      }
      catch {
        print(error)
      }
    }
  }
  
  func signInOld() {
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      if let error = error {
        print(error)
        return
      }
      self.user = result?.user
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      self.user = nil
    }
    catch {
      print(error)
    }
  }
}

@available(iOS 15.0, *)
struct SignInDemoScreen: View {
  @StateObject var viewModel = SignInDemoScreenViewModel()
  
  var body: some View {
    Form {
      Section(header: Text("Sign in using Email/Password")) {
        VStack(alignment: .leading) {
          Text("Email")
            .font(.caption)
            .foregroundColor(.accentColor)
          TextField("Enter your email address", text: $viewModel.email)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
        }
        VStack(alignment: .leading) {
          Text("Password")
            .font(.caption)
            .foregroundColor(.accentColor)
          SecureField("Enter your password:", text: $viewModel.password)
        }
        Button("Sign in") {
          viewModel.signIn()
        }
        .disabled(viewModel.password.isEmpty || viewModel.isSignedIn)
      }
      if viewModel.isSignedIn {
        Section(header: Text("User Info")) {
          VStack(alignment: .leading) {
            Text("User ID")
              .font(.caption)
              .foregroundColor(.accentColor)
            Text("\(viewModel.user?.uid ?? "")")
          }
          VStack(alignment: .leading) {
            Text("Display name")
              .font(.caption)
              .foregroundColor(.accentColor)
            Text("\(viewModel.user?.displayName ?? "")")
          }
          VStack(alignment: .leading) {
            Text("Email")
              .font(.caption)
              .foregroundColor(.accentColor)
            Text("\(viewModel.user?.email ?? "")")
          }
        }
        Button("Sign out") {
          viewModel.signOut()
        }
      }
    }
    .navigationTitle("Firebase Auth")
  }
}

@available(iOS 9999, *)
struct SignInDemoScreen_Previews: PreviewProvider {
  static var previews: some View {
    SignInDemoScreen()
  }
}
