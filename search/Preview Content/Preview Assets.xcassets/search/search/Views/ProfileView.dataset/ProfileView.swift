//
//  ProfileView.swift
//  search
//
//  Created by Arielle Craigfeld on 1/24/25.
//


// ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("\u{1F3C3} Your Profile")
                .font(.largeTitle)
                .fontWeight(.bold)

            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)

            Text("Name: John Doe")
                .font(.title2)

            Text("Email: john.doe@example.com")
                .font(.subheadline)
                .foregroundColor(.gray)

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
