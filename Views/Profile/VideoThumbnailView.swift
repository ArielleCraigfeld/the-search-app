//
//  VideoThumbnailView.swift
//  search
//
//  Created by Arielle Craigfeld on 2/26/25.
//


import SwiftUI
import AVKit

struct VideoThumbnailView: View {
    let videoURL: URL?
    @State private var thumbnail: UIImage?
    
    var body: some View {
        ZStack {
            if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
            }
        }
        .task {
            guard let url = videoURL else { return }
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            do {
                let (cgImage, _) = try await generator.image(at: CMTime(seconds: 1, preferredTimescale: 60))
                thumbnail = UIImage(cgImage: cgImage)
            } catch {
                print("Error generating thumbnail: \(error)")
            }
        }
    }
}