import SwiftUI
import Firebase

@main
struct YourApp: App {
    init() {
        FirebaseApp.configure() // Configure Firebase here
    }
    
    var body: some Scene {
        WindowGroup {
            SignUpView() // Your initial view
        }
    }
}
