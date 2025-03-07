//
//  FirebaseService.swift
//  search
//
//  Created by Arielle Craigfeld on 1/24/25.
//


import Firebase
import UIKit
import SwiftUI

class FirebaseService {
    static let shared = FirebaseService()

    private init() {}

    // Save Profile to Firebase
    func saveProfileToFirebase(name: String, bio: String, imageData: Data?) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? "defaultUserID"
        
        var profileData: [String: Any] = [
            "name": name,
            "bio": bio
        ]
        
        if let imageData = imageData {
            let storageRef = Storage.storage().reference().child("profile_images/\(userID).jpg")
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                    return
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error fetching download URL: \(error)")
                        return
                    }
                    if let url = url {
                        profileData["profileImageURL"] = url.absoluteString
                        db.collection("users").document(userID).setData(profileData) { error in
                            if let error = error {
                                print("Error saving profile data: \(error)")
                            } else {
                                print("Profile saved successfully")
                            }
                        }
                    }
                }
            }
        } else {
            db.collection("users").document(userID).setData(profileData) { error in
                if let error = error {
                    print("Error saving profile data: \(error)")
                } else {
                    print("Profile saved successfully")
                }
            }
        }
    }

    // Load Profile from Firebase
    func loadProfileFromFirebase(completion: @escaping (String, String, Image?) -> Void) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? "defaultUserID"
        
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? "No Name"
                let bio = data?["bio"] as? String ?? "No Bio"
                
                var profileImage: Image? = nil
                if let imageURLString = data?["profileImageURL"] as? String,
                   let imageURL = URL(string: imageURLString) {
                    self.downloadImage(from: imageURL) { uiImage in
                        profileImage = uiImage != nil ? Image(uiImage: uiImage!) : nil
                        completion(name, bio, profileImage)
                    }
                } else {
                    completion(name, bio, profileImage)
                }
            } else {
                print("Document does not exist")
                completion("No Name", "No Bio", nil)
            }
        }
    }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(uiImage)
                }
            } else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
