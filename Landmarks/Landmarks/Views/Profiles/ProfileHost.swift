//
//  ProfileHost.swift
//  Landmarks
//
//  Created by c on 2021/1/7.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import SwiftUI

struct ProfileHost: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    @State private var draftProfile = Profile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.editMode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftProfile = self.modelData.profile
                        self.editMode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                
                EditButton()
            }
            
            if self.editMode?.wrappedValue == .inactive {
                ProfileSummary(profile: modelData.profile)
            } else {
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        self.draftProfile = self.modelData.profile
                    }
                    .onDisappear {
                        self.modelData.profile = self.draftProfile
                    }
            }
        }
        .padding()
    }
}

// Helper for Preview about editMode
// See https://developer.apple.com/forums/thread/117421
struct EditModeInPreview<Content: View> : View {
    var content: Content
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        content.environment(\.editMode, $editMode)
    }
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        EditModeInPreview {
            ProfileHost()
        }
        .environmentObject(ModelData())
    }
}
