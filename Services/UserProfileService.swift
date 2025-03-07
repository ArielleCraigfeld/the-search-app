//
//  UserProfileService.swift
//  search
//
//  Created by Arielle Craigfeld on 2/11/25.
//
import FirebaseFirestore

class UserProfileService: ObservableObject {
    static let shared = UserProfileService()
    private let db = Firestore.firestore()
    private let pageSize = 15
    
    @Published var profile: UserProfile?
    
    // MARK: - Match Finding
    func findMatches(for userId: String, matchThreshold: Double = 0.7, lastDocument: DocumentSnapshot? = nil) async throws -> ([String], DocumentSnapshot?) {
        let query = db.collection("users")
            .limit(to: pageSize)
        
        let snapshot = try await query.getDocuments()
        guard let currentUserAnswers = try await fetchUserAnswers(userId: userId) else {
            throw MatchError.noUserData
        }
        
        var matches: [String] = []
        
        for document in snapshot.documents {
            guard document.documentID != userId,
                  let answers = document.data()["answers"] as? [String: String] else { continue }
            
            let score = calculateMatchScore(answers1: currentUserAnswers, answers2: answers)
            if score >= matchThreshold {
                matches.append(document.documentID)
            }
        }
        
        return (matches, snapshot.documents.last)
    }
    
    // MARK: - Profile Refresh
    func refreshProfile() async {
        guard let userId = profile?.id else { return }
        do {
            let answers = try await fetchUserAnswers(userId: userId)
            profile?.answers = answers ?? [:] // ✅ Fixed empty dictionary fallback
        } catch {
            print("Refresh failed: \(error)")
        }
    }
    
    // MARK: - Match Calculation
    private func calculateMatchScore(answers1: [String: String], answers2: [String: String]) -> Double {
        let sharedQuestions = Set(answers1.keys).intersection(answers2.keys)
        guard !sharedQuestions.isEmpty else { return 0.0 }
        
        let matchingAnswers = sharedQuestions.filter { answers1[$0] == answers2[$0] }
        return Double(matchingAnswers.count) / Double(sharedQuestions.count)
    }
    
    // MARK: - Data Fetching
    func fetchUserAnswers(userId: String) async throws -> [String: String]? {
        let document = try await db.collection("users").document(userId).getDocument()
        return document.data()?["answers"] as? [String: String]
    }
}

enum MatchError: Error {
    case noUserData
    case invalidThreshold
}
