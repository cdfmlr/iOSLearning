//
//  BlurView.swift
//  PokeMaster
//
//  Created by c on 2021/1/19.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import UIKit

/// 半透明的模糊效果底板
struct BlurView: UIViewRepresentable {
    
    /// 模糊效果
    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        
//        let view = UIView(frame: .zero)
//        view.backgroundColor = .clear
//
//        let blurEffect = UIBlurEffect(style: style)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(blurView)
//
//        NSLayoutConstraint.activate([
//            blurView.heightAnchor
//                .constraint(equalTo: view.heightAnchor),
//            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
//        ])
//        return view
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

// 拓展 View，把 BlurView 的使用包装起来，方便使用
// 调用 (some View).blurBackground(style: .systemMaterial) 就可以啦
extension View {
    /// 半透明的模糊效果底板
    /// - Parameter style: 具体的模糊效果
    /// - Returns: 给 self 添加了半透明的模糊效果底板（背景）的新 View
    func blurBackground(style: UIBlurEffect.Style) -> some View {
//        ZStack {
//            BlurView(style: style)
//            self
//        }
        self.background(BlurView(style: style))
    }
}
