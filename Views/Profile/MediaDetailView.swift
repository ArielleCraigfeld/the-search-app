//
//  MediaDetailView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/26/25.
import SwiftUI
import AVKit
import UniformTypeIdentifiers

struct MediaDetailView: View {
    var mediaItem: MediaItem
    @Binding var media: [MediaItem]
    @Binding var selectedMedia: MediaItem?
    
    var body: some View {
        VStack {
            // Back Button
            HStack {
                Button(action: {
                    selectedMedia = nil
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
            }
            .padding()
            
            Spacer()
            
            // Display the image or video based on media type
            switch mediaItem.type {
            case .image(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .video(let videoURL):
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 300)
            }
            
            Spacer()
            
            // Carousel - Add code here to manage media carousel
            // For example, you can use a `ScrollView` or a custom carousel view
            ScrollView(.horizontal) {
                HStack {
                    ForEach(media, id: \.id) { item in
                        switch item.type {
                        case .image(let uiImage):
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        case .video(let videoURL):
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .frame(width: 100, height: 100)
                        }
                    }
                }
            }
            
        }
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
    }
}
