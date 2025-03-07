//
//  GameService.swift
//  search
//
//  Created by Arielle Craigfeld on 3/3/25.
//
//
//
//  GameService.swift
//  search
//
//  Created by Arielle Craigfeld on 3/3/25.
//

import Foundation

class GameService {
    let firebaseService: FirebaseService
    let matchAlgorithm: MatchAlgorithm

    init(firebaseService: FirebaseService = FirebaseService(),
         matchAlgorithm: MatchAlgorithm = MatchAlgorithm()) {
        self.firebaseService = firebaseService
        self.matchAlgorithm = matchAlgorithm
    }
    
    func playVsGame() {
        let topic: String = "Food" // Ensure a valid topic is passed
        let gameResult = vsGame(topic: topic)
        
        Task {
            do {
                // Save game result to Firebase
                try await firebaseService.saveGameResult(gameData: ["result": gameResult])
                
                // Update preferences based on game result
                matchAlgorithm.updatePreferences(with: gameResult)
            } catch {
                print("Error saving game result or updating preferences: \(error)")
            }
        }
    }
    
    func vsGame(topic: String) -> String {
        // Example logic for the game
        return topic == "Food" ? "Win" : "Lose"
    }
}
