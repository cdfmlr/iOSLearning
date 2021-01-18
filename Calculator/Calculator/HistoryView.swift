//
//  HistoryView.swift
//  Calculator
//
//  Created by c on 2021/1/14.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var model: CalculatorModel

    var body: some View {
        VStack {
            if self.model.totalHistoryCount == 0 {
                Text("没有历史记录")
            } else {
                HStack {
                    Text("记录:").font(.headline)
                    Text("\(model.historyDetial)").lineLimit(nil)
                }
                HStack {
                    Text("显示:").font(.headline)
                    Text("\(model.brain.output)")
                }
                HStack {
                    Text("回溯:").font(.headline)
                    Slider(
                        value: $model.slidingIndex,
                        in: 0 ... Float(model.totalHistoryCount),
                        step: 1
                    )
                }
            }
        }
        .padding()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(model: CalculatorModel())
    }
}
