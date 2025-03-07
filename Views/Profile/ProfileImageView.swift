//
//  ProfileImageView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/26/25.
//


import SwiftUI

struct ProfileImageView: View {
    @Binding var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
    }
}
