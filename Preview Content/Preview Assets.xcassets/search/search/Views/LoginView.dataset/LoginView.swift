//
//  LoginView.swift
//  search
//
//  Created by Arielle Craigfeld on 1/24/25.
//

// LoginView.swift
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showSignUp: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("\u{1F3C3} Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    isLoggedIn = true // Simulated login
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                NavigationLink(destination: SignUpView(), isActive: $showSignUp) {
                    Button("Sign Up") {
                        showSignUp = true
                    }
                    .font(.subheadline)
                }
            }
            .padding()
            .navigationTitle("Login")
            .fullScreenCover(isPresented: $isLoggedIn) {
                ProfileView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
