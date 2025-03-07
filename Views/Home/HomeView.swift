//
//  HomeView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/5/25.
import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var userEmail: String = ""
    @State private var navigationState: NavigationState = .home

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to the Home Screen!")
                    .font(.largeTitle)
                    .padding()

                if !userEmail.isEmpty {
                    Text("Logged in as: \(userEmail)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Grid Layout
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    // Box 1: Profile
                    NavigationLink(destination: ProfileView()) {
                        BoxView(title: "Profile", icon: "person.circle.fill", color: .blue)
                    }

                    // Box 2: Direct Messages (DMs)
                    NavigationLink(destination: DMsView()) {
                        BoxView(title: "DMs", icon: "message.fill", color: .green)
                    }

                    // Box 3: Random Videos/Pictures
                    NavigationLink(destination: MediaView()) {
                        BoxView(title: "Media", icon: "photo.fill", color: .orange)
                    }

                    // Box 4: AI Learning
                    NavigationLink(destination: AILearningView()) {
                        BoxView(title: "AI Learning", icon: "brain.head.profile", color: .purple)
                    }
                }
                .padding()

                Button(action: {
                    logoutUser()
                }) {
                    Text("Log Out")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .onAppear {
                fetchUserEmail()
            }
        }
    }

    func fetchUserEmail() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email ?? "Unknown User"
        }
    }

    func logoutUser() {
        do {
            try Auth.auth().signOut()
            // Navigate back to the login screen
            navigationState = .login
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// Box View Component
struct BoxView: View {
    var title: String
    var icon: String
    var color: Color

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 150, height: 150)
        .background(color)
        .cornerRadius(15)
    }
}
