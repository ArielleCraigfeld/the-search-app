//
//  ProfileView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/11/25
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import PhotosUI
import AVKit

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var media: [MediaItem] = MediaItem.sampleMedia()
    @State private var bioText: String = "This is a sample bio."
    @State private var profileImage: UIImage?
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedMedia: MediaItem?

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                // Header with aligned back button and title
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text("Profile")
                        .font(.title.bold())
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Profile Image Picker (Tappable)
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImagePicker = true
                        }
                } else {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                profileImage = uiImage
                            }
                        }
                    }
                }

                ProfileMediaView(media: $media, selectedMedia: $selectedMedia)
                    
                EditableBioView(bioText: $bioText)
                    .padding(.horizontal)
                
                Button("Save Profile") {
                    // Save logic
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            .fullScreenCover(item: $selectedMedia) { item in
                MediaDetailView(mediaItem: item, media: $media, selectedMedia: $selectedMedia)
            }
        }
    }
}
