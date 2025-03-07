import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = "test@example.com"
    @State private var password: String = "test1234!"
    @State private var errorMessage: String = ""
    @State private var isNavigatingToHome = false
    @State private var isNavigatingToSignUp = false

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .onChange(of: email) { _ in errorMessage = "" }

                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: password) { _ in errorMessage = "" }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: loginUser) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Button(action: { isNavigatingToSignUp = true }) {
                    Text("Don't have an account? Sign Up Instead")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                // Navigate to Home
                .navigationDestination(isPresented: $isNavigatingToHome) {
                    HomeView()
                }
                
                // Navigate to Sign Up
                .navigationDestination(isPresented: $isNavigatingToSignUp) {
                    SignUpView()
                }
            }
            .padding()
        }
    }

    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            isNavigatingToHome = true // Navigate to home after successful login
        }
    }
}

