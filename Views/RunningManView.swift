//
//  RunningManView.swift
//  search
//
//  Created by Arielle Craigfeld on 1/24/25.
//

import SwiftUI

struct RunningManView: View {
    @State private var currentEmoji: String = "🏃🏿‍♂️"  // Default to a black running man
    private let emojis: [String] = [
        "🏃‍♂️", "🏃‍♀️","🏃🏿‍♂️", "🏃🏽‍♂️", "🏃🏻‍♂️", "🏃‍♀️", // Black, brown, white running man
        "🤖🏃🏿‍♂️", "🤖🏃🏽‍♂️", "🤖🏃🏻‍♂️", "🤖🏃‍♀️", // Robot runner variations
        "👽🏃🏿‍♂️", "👽🏃🏽‍♂️", "👽🏃🏻‍♂️", "👽🏃‍♀️" // Alien runner variations
    ]
    
    var body: some View {
        Text(currentEmoji)
            .font(.system(size: 100))  // Adjust size of the emoji
            .onAppear {
                startEmojiCycle()
            }
    }
    
    private func startEmojiCycle() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            let randomIndex = Int.random(in: 0..<emojis.count)
            currentEmoji = emojis[randomIndex]
        }
    }
}

struct RunningManView_Previews: PreviewProvider {
    static var previews: some View {
        RunningManView()
    }
}
