//
//  SignInDemoScreen.swift
//  AsyncAwaitFirebase
//
//  Created by Peter Friese on 24.02.21.
//

import SwiftUI
import Firebase
import Combine

@available(iOS 9999, *)
class SignInDemoScreenViewModel: ObservableObject {
  @Published var email: String = "test@test.com"
  @Published var password: String = "test1234"
  
  @Published var user: User?
  @Published var isSignedIn = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    Auth.auth().useEmulator(withHost:"localhost", port:9099)
    $user
      .map { $0 != nil }
      .assign(to: \.isSignedIn, on: self)
      .store(in: &cancellables)
  }
  
  func signIn() {
    Task.detached {
      do {
        let result = try await Auth.auth().signIn(withEmail: self.email, password: self.password)
        DispatchQueue.main.async {
          self.user = result.user
        }
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

@available(iOS 9999, *)
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
        Button(action: viewModel.signIn) {
          Text("Sign in")
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
        Button(action: viewModel.signOut) {
          Text("Sign out")
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
