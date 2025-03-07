import Foundation
import SwiftUI
import FirebaseStorage
import UIKit
import UniformTypeIdentifiers

struct MediaItem: Identifiable {
    enum MediaType {
        case image(UIImage)
        case video(URL)
        
        // Convert to UTType
        func toUTType() -> UTType? {
            switch self {
            case .image:
                return UTType.image
            case .video:
                return UTType.movie
            }
        }
    }
    
    let id = UUID().uuidString
    let type: MediaType
    let url: URL? // Add this property
    let fileExtension: String // Add this property
    
    // Image initializer
    init(image: UIImage, url: URL? = nil, fileExtension: String = "jpg") {
        self.type = .image(image)
        self.url = url
        self.fileExtension = fileExtension
    }
    
    // Video initializer
    init(videoURL: URL, fileExtension: String = "mp4") {
        self.type = .video(videoURL)
        self.url = videoURL
        self.fileExtension = fileExtension
    }
    
    static func sampleMedia() -> [MediaItem] {
        var mediaItems: [MediaItem] = []
        
        // Add sample images
        if let image1 = UIImage(named: "sample1") {
            mediaItems.append(MediaItem(image: image1, url: nil, fileExtension: "jpg"))
        } else {
            print("Error: Image 'sample1' not found in assets")
        }
        
        if let image2 = UIImage(named: "sample2") {
            mediaItems.append(MediaItem(image: image2, url: nil, fileExtension: "jpg"))
        } else {
            print("Error: Image 'sample2' not found in assets")
        }
        
        // Add sample video
        if let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") {
            mediaItems.append(MediaItem(videoURL: videoURL, fileExtension: "mp4"))
        } else {
            print("Error: Invalid video URL")
        }
        
        return mediaItems
    }
}
