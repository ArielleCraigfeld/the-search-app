import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email: String = "test@example.com"
    @State private var password: String = "test1234!"
    @State private var confirmPassword: String = "test1234!"
    @State private var errorMessage: String = ""
    @State private var isNavigatingToHome = false
    @State private var isNavigatingToLogin = false
    
    @State private var runnerEmoji: String = "🏃‍♀️"
    @State private var currentRunnerColor: Color = .blue
    
    let runnerColors: [Color] = [.blue, .red, .green, .purple, .orange]
    let runnerEmojis: [String] = ["🏃‍♀️", "🏃‍♂️", "🤖", "👽", "🏃🏿‍♀️", "🏃🏾‍♂️", "🏃🏻‍♀️", "🏃🏽‍♂️"]

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

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: confirmPassword) { _ in errorMessage = "" }

                if !errorMessage.isEmpty {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                        
                        if errorMessage.contains("already registered") {
                            Button(action: { isNavigatingToLogin = true }) {
                                Text("Log In")
                                    .foregroundColor(.blue)
                                    .padding()
                            }
                        }
                    }
                }

                Button(action: signUpUser) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Text(runnerEmoji)
                    .font(.system(size: 100))
                    .foregroundColor(currentRunnerColor)
                    .padding()

                Button(action: { isNavigatingToLogin = true }) {
                    Text("Already have an account? Log In Instead")
                        .foregroundColor(.blue)
                        .padding()
                }

                // Navigate to Home
                .navigationDestination(isPresented: $isNavigatingToHome) {
                    HomeView()
                }
                
                // Navigate to Login
                .navigationDestination(isPresented: $isNavigatingToLogin) {
                    LoginView()
                }
            }
            .padding()
            .onAppear {
                startRunningEmojiCycle()
            }
        }
    }

    func signUpUser() {
        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            return
        }

        if !isPasswordValid(password) {
            errorMessage = "Password must be at least 8 characters long and contain a number and a special character."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                if let errorCode = AuthErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        errorMessage = "This email is already registered. Log in instead."
                    case .weakPassword:
                        errorMessage = "Password is too weak."
                    default:
                        errorMessage = "Error: \(error.localizedDescription)"
                    }
                }
                return
            }
            isNavigatingToHome = true
        }
    }

    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    func startRunningEmojiCycle() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            runnerEmoji = runnerEmojis.randomElement() ?? "🏃‍♀️"
            currentRunnerColor = runnerColors.randomElement() ?? .blue
        }
    }
}

