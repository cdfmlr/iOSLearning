//
//  RetryButton.swift
//  PokeMaster
//
//  Created by c on 2021/1/27.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

/// 网络加载失败的重试按钮
struct RetryButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke()
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
            }
            .frame(width: 90, height: 40)
            .foregroundColor(.gray)
        }
    }
}

struct RetryButton_Previews: PreviewProvider {
    static var previews: some View {
        RetryButton {}
    }
}
