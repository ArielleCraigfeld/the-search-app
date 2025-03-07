//
//  AILearningView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/5/25.
//


import SwiftUI

struct AILearningView: View {
    @State private var cards: [SwipeCard] = SwipeCard.sampleData()
    @State private var likedCards: [SwipeCard] = []
    
    var body: some View {
        ZStack {
            ForEach(cards) { card in
                SwipeableCardView(card: card, onRemove: { removedCard, liked in
                    cards.removeAll { $0.id == removedCard.id }
                    if liked {
                        likedCards.append(removedCard)
                    }
                })
            }
        }
        .padding()
        .navigationBarTitle("AI Learning", displayMode: .inline)
    }
}

// MARK: - Swipe Card Model
struct SwipeCard: Identifiable {
    let id = UUID()
    let imageName: String
    
    static func sampleData() -> [SwipeCard] {
        return [
            SwipeCard(imageName: "celebrity1"),
            SwipeCard(imageName: "puppy"),
            SwipeCard(imageName: "nature"),
            SwipeCard(imageName: "meme1"),
            SwipeCard(imageName: "profile1")
        ]
    }
}

// MARK: - Swipeable Card View
struct SwipeableCardView: View {
    let card: SwipeCard
    var onRemove: (SwipeCard, Bool) -> Void
    
    @State private var offset: CGSize = .zero
    @State private var isLiked: Bool = false
    
    var body: some View {
        ZStack {
            Image(card.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 400)
                .clipped()
                .cornerRadius(20)
                .shadow(radius: 5)
                .overlay(
                    Text(isLiked ? "❤️" : "❌")
                        .font(.largeTitle)
                        .opacity(abs(offset.width) > 100 ? 1 : 0),
                    alignment: .top
                )
        }
        .offset(x: offset.width, y: offset.height)
        .rotationEffect(.degrees(Double(offset.width / 10)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    isLiked = offset.width > 0
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        onRemove(card, isLiked)
                    }
                    offset = .zero
                }
        )
    }
}
