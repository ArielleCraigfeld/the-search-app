//
//  SignUpView.swift
//  search
//
//  Created by Arielle Craigfeld on 1/24/25.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        VStack {
            Text("Welcome to The Search!")
                .font(.largeTitle)
                .padding()
            
            // Add the RunningManView here
            RunningManView()
                .padding()
            
            // Rest of your SignUpView content (e.g., TextFields, Buttons, etc.)
            TextField("Email", text: .constant(""))
                .padding()
            SecureField("Password", text: .constant(""))
                .padding()
            Button(action: {
                // Handle sign up action
            }) {
                Text("Sign Up")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
