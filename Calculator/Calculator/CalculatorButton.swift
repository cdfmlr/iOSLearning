//
//  CalculatorButton.swift
//  Calculator
//
//  Created by c on 2021/1/12.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import SwiftUI

struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let foregroundColorName: String
    let backgroundColorName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(foregroundColorName != "" ?
                    Color(foregroundColorName) : .white)
                .frame(width: size.width, height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width / 2)

            // 下面用 ZStack 组合 Circle、Text 和上 面 cornerRadius 切出来是一个效果
//            ZStack {
//                Circle()
//                    .frame(width: size.width, height: size.height)
//                    .foregroundColor(Color(backgroundColorName))
//
//                Text(title)
//                    .font(.system(size: fontSize))
//                    .foregroundColor(foregroundColorName != "" ?
//                        Color(foregroundColorName) : .white)
//            }
        }
    }
}

struct CalculatorButton_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorButton(
            title: "+",
            size: CGSize(width: 88, height: 88),
            foregroundColorName: "",
            backgroundColorName: "operatorBackground") {
            print("Button +")
        }
    }
}
