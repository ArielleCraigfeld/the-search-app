//
//  FirebaseService.swift
//  search
//
//  Created by Arielle Craigfeld on 1/24/25.
//
//
//  FirebaseService.swift
//  search
//
//  Created by Arielle Craigfeld on 1/24/25.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class FirebaseService {
    static let shared = FirebaseService()
    private let imageCache = NSCache<NSString, UIImage>()

    // MARK: - Profile Operations
    func saveProfileToFirebase(bio: String, media: [MediaItem], profileImage: UIImage?) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw FirebaseError.notAuthenticated
        }

        var profileData: [String: Any] = [
            "bio": bio,
            "media": media.map { ["url": $0.url ?? "", "type": $0.fileExtension] }
        ]

        if let imageData = profileImage?.jpegData(compressionQuality: 0.7) {
            let imageUrl = try await uploadImageData(imageData, path: "profile_images/\(userId).jpg")
            profileData["profileImageURL"] = imageUrl
        }

        try await Firestore.firestore().collection("users").document(userId).setData(profileData, merge: true)
    }

    func loadProfileFromFirebase() async throws -> (name: String, bio: String, image: UIImage?) {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw FirebaseError.notAuthenticated
        }

        let document = try await Firestore.firestore().collection("users").document(userId).getDocument()
        guard document.exists,
              let data = document.data() else {
            throw FirebaseError.noData
        }

        let name = data["name"] as? String ?? "No Name"
        let bio = data["bio"] as? String ?? "No Bio"
        var image: UIImage?

        if let urlString = data["profileImageURL"] as? String,
           let url = URL(string: urlString) {
            image = try await downloadImage(from: url)
        }

        return (name, bio, image)
    }

    // MARK: - Media Operations
    private func uploadImageData(_ data: Data, path: String) async throws -> String {
        let storageRef = Storage.storage().reference().child(path)
        _ = try await storageRef.putDataAsync(data)
        return try await storageRef.downloadURL().absoluteString
    }

    private func downloadImage(from url: URL) async throws -> UIImage {
        if let cached = imageCache.object(forKey: url.absoluteString as NSString) {
            return cached
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw FirebaseError.imageDecodingFailed
        }

        imageCache.setObject(image, forKey: url.absoluteString as NSString)
        return image
    }

    // MARK: - Game Operations
    // Add a method to save the game result
    func saveGameResult(gameData: [String: Any]) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw FirebaseError.notAuthenticated
        }

        // Assuming you want to save the game result to a 'games' collection in Firestore
        try await Firestore.firestore().collection("games").document(userId).setData(gameData, merge: true)
    }
}

enum FirebaseError: Error {
    case notAuthenticated
    case noData
    case imageDecodingFailed
}
