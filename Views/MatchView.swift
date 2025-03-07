//
//  MatchView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/11/25.
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

struct MatchView: View {
    @State private var matches: [User] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Finding matches...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if matches.isEmpty {
                Text("No matches found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(matches) { match in
                    HStack {
                        // Profile Picture
                        AsyncImage(url: URL(string: match.profilePicture)) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        // Name and Bio
                        VStack(alignment: .leading, spacing: 5) {
                            Text(match.name)
                                .font(.headline)
                            Text(match.bio)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .navigationTitle("Matches")
        .onAppear {
            loadMatches()
        }
    }
    
    // MARK: - Functions
    func loadMatches() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not authenticated."
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let (matchIds, _) = try await UserProfileService.shared.findMatches(for: currentUserId)
                await MainActor.run {
                    isLoading = false
                    fetchMatchDetails(matchIds: matchIds)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    
    func fetchMatchDetails(matchIds: [String]) {
        isLoading = true
        errorMessage = nil
        
        let db = Firestore.firestore()
        db.collection("users")
            .whereField(FieldPath.documentID(), in: matchIds) // Fixed: Proper use of `in`
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else if let documents = snapshot?.documents {
                    matches = documents.compactMap { document in
                        let data = document.data()
                        return User(
                            id: document.documentID,
                            name: data["name"] as? String ?? "Unknown",
                            bio: data["bio"] as? String ?? "",
                            profilePicture: data["profilePicture"] as? String ?? ""
                        )
                    }
                }
            }
    }
}

// MARK: - User Model
struct User: Identifiable {
    let id: String
    let name: String
    let bio: String
    let profilePicture: String
}
