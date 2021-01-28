//
//  OverlaySheet.swift
//  PokeMaster
//
//  Created by c on 2021/1/28.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import SwiftUI

/// 底部弹出面板容器
///
/// 可以从屏幕下方弹出（类似于 Action Sheet），以及使用手势来取消面板显示
struct OverlaySheet<Content: View>: View {
    private let isPresented: Binding<Bool>
    private let makeContent: () -> Content

    @GestureState private var translation = CGPoint.zero

    init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isPresented = isPresented
        makeContent = content
    }

    var body: some View {
        VStack {
            Spacer()
            makeContent()
        }
        .offset(y: (isPresented.wrappedValue ? 0 : UIScreen.main.bounds.height)
            + max(-10, translation.y)) // isPresented 为 false 时移出屏幕
//            .animation(.interpolatingSpring(stiffness: 75, damping: 15))
        .animation(.easeInOut)
        .edgesIgnoringSafeArea(.bottom)
        .gesture(panelDraggingGesture)
    }

    var panelDraggingGesture: some Gesture {
        DragGesture()
            .updating($translation) { current, state, _ in
                state.y = current.translation.height
            }
            .onEnded { state in
                if state.translation.height > 250 {
                    self.isPresented.wrappedValue = false
                }
            }
    }
}

extension View {
    /// 把 `content` 放到底部弹出面板中
    ///
    /// 可以从屏幕下方弹出（类似于 Action Sheet），以及使用手势来取消面板显示
    func overlaySheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        overlay(
            OverlaySheet(isPresented: isPresented, content: content)
        )
    }
}
