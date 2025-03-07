//
//  AISuggestedQuestionsView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/6/25.
//
import SwiftUI

struct AISuggestedQuestionsView: View {
    @State private var answers: [String: String] = [:]
    let questions = [
        "What's your idea of a perfect date?",
        "If you could travel anywhere, where would you go?"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("AI Suggested Questions")
                .font(.headline)

            ForEach(questions, id: \.self) { question in
                VStack(alignment: .leading, spacing: 10) {
                    Text(question)
                        .font(.subheadline)
                    TextField("Your answer", text: Binding(
                        get: { answers[question] ?? "" },
                        set: { answers[question] = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
    }
}  
