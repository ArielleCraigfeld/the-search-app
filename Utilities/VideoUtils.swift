//
//  VideoUtils.swift
//  search
//
//  Created by Arielle Craigfeld on 2/19/25.
//

import Foundation
import AVFoundation
import UIKit

func generateThumbnail(from videoURL: URL) -> UIImage? {
    let asset = AVAsset(url: videoURL)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    
    do {
        let thumbnail = try generator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
        return UIImage(cgImage: thumbnail)
    } catch {
        print("Error generating thumbnail: \(error.localizedDescription)")
        return nil
    }
}
