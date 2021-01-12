//
//  LandmarkRow.swift
//  Landmarks
//
//  Created by c on 2021/1/1.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import SwiftUI

struct LandmarkRow: View {
    var  landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            
            Text(landmark.name)
            
            Spacer()
            
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                    .imageScale(.medium)
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    // The code you write in a preview provider only changes what Xcode displays in the canvas.
    
    static var landmarks = ModelData().landmarks
    
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarks[0])
            LandmarkRow(landmark: landmarks[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
        
        // A view’s children inherit the view’s contextualb settings, such as preview configurations.

    }
}
