//  ProfileMediaView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/11/25

import SwiftUI
import PhotosUI
import AVKit
import UniformTypeIdentifiers
import SwiftUI
import PhotosUI
import AVKit
import UniformTypeIdentifiers

struct ProfileMediaView: View {
    @Binding var media: [MediaItem]
    @Binding var selectedMedia: MediaItem?
    @State private var selectedPickerItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(media) { item in
                    MediaItemView(item: item)
                        .onTapGesture { selectedMedia = item }
                }
                
                PhotosPicker(
                    selection: $selectedPickerItem,
                    matching: .any(of: [.images, .videos]),
                    photoLibrary: .shared()
                ) {
                    AddMediaButton()
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: selectedPickerItem) { handleMediaSelection($0) }
    }
    
    private func handleMediaSelection(_ item: PhotosPickerItem?) {
        Task {
            guard let item else { return }
            
            // Handle images
            if item.supportedContentTypes.contains(UTType.image),
               let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                media.append(MediaItem(image: image))
            }
            // Handle videos
            else if item.supportedContentTypes.contains(UTType.movie),
                    let url = try? await item.loadTransferable(type: URL.self) {
                media.append(MediaItem(videoURL: url))
            }
        }
    }
}
struct MediaItemView: View {
    let item: MediaItem
    
    var body: some View {
        Group {
            switch item.type {
            case .image(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            case .video(let url):
                VideoThumbnailView(videoURL: url)
            }
        }
        .frame(width: 200, height: 250)
        .cornerRadius(12)
    }
}

struct AddMediaButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 200, height: 250)
            Image(systemName: "plus")
                .font(.largeTitle)
        }
    }
}
