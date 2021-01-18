//
//  CalculatorModel.swift
//  Calculator
//
//  Created by c on 2021/1/14.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import Combine
import Foundation

class CalculatorModel: ObservableObject {
    /// 当前状态的 brain
    @Published var brain: CalculatorBrain = .left("0")
//    // 👇下面是手动完成 @Published 做的工作
//    let objectWillChange = PassthroughSubject<Void, Never>()
//
//    var brain: CalculatorBrain = .left("0") {
//        willSet { objectWillChange.send() }
//    }

    /// 历史操作
    @Published var history: [CalculatorButtonItem] = []

    /// historyDetail 将 history 数组中所记录的操作步骤的描述连接起来，作为操作历史的输出字符串。
    var historyDetial: String {
        history.map { $0.description }.joined()
    }

    /// 用 temporaryKept 来保留 “被回溯” 的操作，这样我们可以还能使用滑块恢复这些操作。
    var temporaryKept: [CalculatorButtonItem] = []

    /// 操作历史滑块的最大值: history + temporaryKept
    var totalHistoryCount: Int {
        history.count + temporaryKept.count
    }

    /// slidingIndex 表示当前滑块表示的 index 值：0 到 totalCount 之间的一个数字
    var slidingIndex: Float = 0 {
        didSet {
            // 在滑块值变动时被调用:
            // 根据当前滑块的位置决定 history 和 temporaryKept 的内容
            keepHistory(upTo: Int(slidingIndex))
        }
    }

    /// 维护 `history` 和 `temporaryKept`: 根据 index 把 history 和 temporaryKept 的元素重新分配
    func keepHistory(upTo index: Int) {
        precondition(index <= totalHistoryCount, "Out of index.")

        let total = history + temporaryKept

        history = Array(total[..<index])
        temporaryKept = Array(total[index...])

        brain = history.reduce(CalculatorBrain.left("0")) {
            result, item in
            result.apply(item)
        }
    }

    /// apply(_:) 添加一个按键操作时使用：
    /// 调用 `self.brain.apply(item)`，
    /// 并将回溯时暂时使用的 temporaryKept 清空，把 slidingIndex 设置到最后一步
    func apply(_ item: CalculatorButtonItem) -> CalculatorBrain {
        // 上一次按了等号
        // 现在按其他数字键||小数点，就把之前的记录清理掉
        // 现在按运算符||命令，就用 ans 继续运算
        if case .ans = brain {
            history.removeAll()
            switch item {
            case .op(_), .command:
                history.appendAns(brain.output)
            default: break
            }
        }

        brain = brain.apply(item)

        history.append(item)
        temporaryKept.removeAll()
        slidingIndex = Float(totalHistoryCount)

        // 按 AC，清除记录
        if case .command(.clear) = item {
            history.removeAll()
        }

        return brain
    }
}

extension Array where Element == CalculatorButtonItem {
    mutating func appendAns(_ ans: String) {
        // 删掉逗号
        let ansStr = ans.filter { c in
            return c != ","
        }

        // 逐字符添加 item
        append(contentsOf: ansStr.map { c in
            switch c {
            case ".":
                return .dot
            case "-":
                return .command(.flip)
            default:
                return .digit(c.wholeNumberValue ?? 0)
            }
        })
    }
}
