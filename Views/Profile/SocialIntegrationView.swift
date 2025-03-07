//
//  SocialIntegrationView.swift
//  search
//
//  Created by Arielle Craigfeld on 3/3/25.
//

// SocialIntegrationView.swift
import SwiftUI

struct SocialIntegrationView: View {
    @ObservedObject var userProfileService = UserProfileService.shared
    
    var body: some View {
        VStack {
            Button("Connect TikTok") {
                TikTokService.shared.authenticate { success in
                    if success {
                        // Proper async call with explicit self
                        Task { [weak userProfileService] in
                            await userProfileService?.refreshProfile()
                        }
                    }
                }
            }
        }
    }
}
