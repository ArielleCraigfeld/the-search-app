//
//  GameResult.swift
//  search
//
//  Created by Arielle Craigfeld on 3/6/25.
//

import Foundation

struct GameResult: Codable {
    enum ResultType: Codable {
        case harmSmoochMarry
        case vsGame(topic: String)
        
        // Manual Codable implementation for enum with associated value
        private enum CodingKeys: String, CodingKey {
            case type, topic
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            
            switch type {
            case "harmSmoochMarry":
                self = .harmSmoochMarry
            case "vsGame":
                let topic = try container.decode(String.self, forKey: .topic)
                self = .vsGame(topic: topic)
            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .type,
                    in: container,
                    debugDescription: "Invalid GameResultType"
                )
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .harmSmoochMarry:
                try container.encode("harmSmoochMarry", forKey: .type)
            case .vsGame(let topic):
                try container.encode("vsGame", forKey: .type)
                try container.encode(topic, forKey: .topic)
            }
        }
    }
    
    let type: ResultType
    let data: String
}
