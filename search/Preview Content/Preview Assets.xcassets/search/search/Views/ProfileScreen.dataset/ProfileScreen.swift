//
//  ProfileScreen.swift
//  search
//
//  Created by Arielle Craigfeld on 1/24/25.
//

import SwiftUI
import UIKit

struct ProfileScreen: View {
    @State private var name: String = "John Doe"
    @State private var bio: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    @State private var isEditing: Bool = false
    @State private var profileImage: Image = Image(systemName: "person.circle.fill")
    
    @State private var isImagePickerPresented = false
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        VStack {
            // Profile Picture with Tap to Select Image
            profileImage
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 50)
                .background(Circle().fill(Color.gray.opacity(0.3)))
                .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                .onTapGesture {
                    isImagePickerPresented.toggle()  // Show ImagePicker when tapped
                }
            
            // Name
            if isEditing {
                TextField("Enter your name", text: $name)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(name)
                    .font(.title)
                    .padding(.top, 20)
            }
            
            // Bio
            if isEditing {
                TextField("Enter your bio", text: $bio)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 100)
            } else {
                Text(bio)
                    .padding(.top, 10)
                    .frame(height: 100)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
            }
            
            // Edit/Save Button
            Button(action: {
                if isEditing {
                    saveProfile()
                } else {
                    isEditing = true
                }
            }) {
                Text(isEditing ? "Save" : "Edit Profile")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isEditing ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 20)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImageData: $selectedImageData)
        }
        .onChange(of: selectedImageData) { newData in
            if let data = newData, let uiImage = UIImage(data: data) {
                profileImage = Image(uiImage: uiImage)
            }
        }
    }
    
    // Save Profile Changes
    private func saveProfile() {
        // Implement saving logic here (e.g., store data in a database)
        isEditing = false
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}

struct ImagePicker: View {
    @Binding var selectedImageData: Data?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ImagePickerController(selectedImageData: $selectedImageData)
            .onDisappear {
                dismiss()
            }
    }
}

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImageData: $selectedImageData)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImageData: Data?
        
        init(selectedImageData: Binding<Data?>) {
            _selectedImageData = selectedImageData
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage,
               let imageData = image.jpegData(compressionQuality: 0.8) {
                selectedImageData = imageData
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
