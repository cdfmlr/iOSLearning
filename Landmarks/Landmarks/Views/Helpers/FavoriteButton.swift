//
//  FavoriteButton.swift
//  Landmarks
//
//  Created by c on 2021/1/2.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button(action: {
            self.isSet.toggle()
        }) {
            Image(systemName: isSet ? "star.fill" : "star")
                .foregroundColor(isSet ? Color.yellow : Color.gray)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([true, false], id: \.self) { isSetVar in
            FavoriteButton(isSet: .constant(isSetVar))
                .previewDisplayName("isSet=\(isSetVar)")
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
