//
//  UserPreferences.swift
//  search
//
//  Created by Arielle Craigfeld on 3/3/25.
//

import Foundation

struct UserPreferences: Codable {
    var tikTokHashtags: [String]       // Fixes "has no member 'tikTokHashtags'"
    var gameResults: [GameResult]      // Fixes "has no member 'gameResults'"
    var interests: [String]
    var dealbreakers: [String]
    
    init(
        tikTokHashtags: [String] = [],
        gameResults: [GameResult] = [],
        interests: [String] = [],
        dealbreakers: [String] = []
    ) {
        self.tikTokHashtags = tikTokHashtags
        self.gameResults = gameResults
        self.interests = interests
        self.dealbreakers = dealbreakers
    }
}
