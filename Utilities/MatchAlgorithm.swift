//
//  MatchAlgorithm.swift
//  search
//
//  Created by Arielle Craigfeld on 3/3/25.
//

//
//  MatchAlgorithm.swift
//  search
//
//  Created by Arielle Craigfeld on 3/3/25.
////
//  MatchAlgorithm.swift
//  search
//
//  Created by Arielle Craigfeld on 3/3/25.
//

import Foundation

class MatchAlgorithm {
    static let shared = MatchAlgorithm()

    // Add a method to update preferences
    func updatePreferences(with gameResult: String) {
        // Logic to update user preferences based on game result
        // You could store this in a user object or save it to Firestore
        
        // For now, assuming you modify some internal data structure:
        print("Updating preferences with result: \(gameResult)")
        
        // Example: Adjusting some preference value (customize as needed)
        // userPreferences.gameResults.append(gameResult)
    }

    func calculateCompatibility(user1: UserPreferences, user2: UserPreferences) -> Double {
        var score = 0.0
        
        // TikTok hashtag overlap
        let hashtagOverlap = Set(user1.tikTokHashtags).intersection(user2.tikTokHashtags)
        score += Double(hashtagOverlap.count) * 0.2
        
        // Game data alignment
        let gameOverlap = user1.gameResults.filter { result in
            user2.gameResults.contains(where: { $0.data == result.data })
        }
        score += Double(gameOverlap.count) * 0.3
        
        return min(score, 1.0)
    }
}
