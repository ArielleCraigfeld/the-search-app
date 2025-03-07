//
//  UserProfile.swift
//  search
//
//  Created by Arielle Craigfeld on 3/6/25.
//


//
//  UserProfile.swift
//  search
//
import Foundation

struct UserProfile: Identifiable, Codable {
    let id: String
    var answers: [String: String]
    var isTikTokConnected: Bool = false
    // Add other properties as needed
}
