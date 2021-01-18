//
//  CalculatorButtonRow.swift
//  Calculator
//
//  Created by c on 2021/1/12.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import SwiftUI

struct CalculatorButtonRow: View {
    let row: [CalculatorButtonItem]
//    @Binding var brain: CalculatorBrain
//    var model: CalculatorModel
    @EnvironmentObject var model: CalculatorModel
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(
                    title: item.title,
                    size: item.size,
                    foregroundColorName: item.foregroundColorName,
                    backgroundColorName: item.backgroundColorName
                ) {
                    print("Button: \(item.title)")
                    self.model.brain = self.model.apply(item)
                }
            }
        }
    }
}

struct CalculatorButtonRow_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorButtonRow(row: [
            .digit(1), .digit(2), .digit(3), .op(.plus),
        ])
        .environmentObject(CalculatorModel())
    }
}
