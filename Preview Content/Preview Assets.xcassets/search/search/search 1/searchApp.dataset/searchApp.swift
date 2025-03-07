//
//  searchApp.swift
//  search
//
//  Created by Arielle Craigfeld on 1/24/25.
//
import SwiftUI
import Firebase

@main
struct YourApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SignUpView()
        }
    }
}
