//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by c on 2021/1/13.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import Foundation

/// CalculatorBrain: 计算核心
enum CalculatorBrain {
    /// 输入 1
    case left(String)
    /// u输入 1 +
    case leftOp(left: String, op: CalculatorButtonItem.Op)
    /// 输入 1 + 2
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String)
    /// 输入错误，无法运算
    case error
    /// 按等号之后的结果
    case ans(String)
}

// output: 要显示的输出
extension CalculatorBrain {
    var formatter: NumberFormatter {
        let f = NumberFormatter()

        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 8
        f.numberStyle = .decimal

        return f
    }

    /// 对外提供一个用于显示结果字符串
    var output: String {
        let result: String

        switch self {
        case let .left(val):
            result = val
        case let .leftOp(left, _):
            result = left
        case let .leftOpRight(_, _, right):
            result = right
        case .error:
            return "Error"
        case let .ans(value):
            result = value
        }

        guard let value = Double(result) else {
            return "Error"
        }
        return formatter.string(from: value as NSNumber)!
    }
}

// apply: 接收输入
extension CalculatorBrain {
    /// apply: 接收并处理 CalculatorButtonItem（按键）输入
    func apply(_ item: CalculatorButtonItem) -> CalculatorBrain {
        switch item {
        case let .digit(digit):
            return apply(digit: digit)
        case .dot:
            return applyDot()
        case let .op(op):
            return apply(op: op)
        case let .command(command):
            return apply(command: command)
        }
    }

    /// apply(digit): 输入数字
    private func apply(digit: Int) -> CalculatorBrain {
        switch self {
        case let .left(left):
            return .left(left.apply(digit: digit))
        case let .leftOp(left, op):
            return .leftOpRight(left: left, op: op,
                                right: "0".apply(digit: digit))
        case let .leftOpRight(left, op, right):
            return .leftOpRight(left: left, op: op,
                                right: right.apply(digit: digit))
        case .error, .ans:
            return .left("0".apply(digit: digit))
        }
    }

    // applyDot: 输入小数点
    private func applyDot() -> CalculatorBrain {
        switch self {
        case let .left(left):
            return .left(left.applyDot())
        case let .leftOp(left, op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case let .leftOpRight(left, op, right):
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .error, .ans:
            return .left("0".applyDot())
        }
    }

    /// apply(op): 输入运算符
    private func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain {
        switch self {
        case let .left(left), let .ans(left):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return self
            }
        case let .leftOp(left, op):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return .error
            }
        case let .leftOpRight(left, prevOp, right):
            switch op {
            case .plus, .minus, .multiply, .divide:
                if let result = prevOp.calculate(left, right) {
                    return .leftOp(left: result, op: op)
                } else {
                    return .error
                }
            case .equal:
                if let result = prevOp.calculate(left, right) {
                    return .ans(result)
                } else {
                    return .error
                }
            }
        case .error:
            return self
        }
    }

    /// apple(command)： 输入命令
    private func apply(command: CalculatorButtonItem.Command) ->
        CalculatorBrain {
        switch command {
        case .clear:
            return .left("0")
        case .flip:
            switch self {
            case let .left(left):
                return .left(left.flipped())
            case let .leftOp(left, op):
                return .leftOpRight(left: left, op: op,
                                    right: "-0")
            case let .leftOpRight(left, op, right):
                return .leftOpRight(left: left, op: op,
                                    right: right.flipped())
            case .error, .ans:
                return .left("-0")
            }
        case .percent:
            switch self {
            case let .left(left):
                return .left(left.percented())
            case .leftOp:
                return self
            case let .leftOpRight(left, op, right):
                return .leftOpRight(left: left, op: op,
                                    right: right.percented())
            case .error, .ans:
                return .left("-0")
            }
        }
    }
}

// 拓展 String，添加各种 apply 方法
extension String {
    /// containsDot 包含小树点嘛
    var containsDot: Bool {
        return contains(".")
    }

    /// startWithNegative 是负数吗
    var startWithNegative: Bool {
        return starts(with: "-")
    }

    /// apply(digit) 添加数字
    func apply(digit: Int) -> String {
        return self == "0" ? "\(digit)" : "\(self)\(digit)"
    }

    /// applyDot 添加小数点
    func applyDot() -> String {
        return containsDot ? self : "\(self)."
    }

    /// flipped 添加 or 删除最前面的负号
    func flipped() -> String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
        }
        return "-\(self)"
    }

    /// percented 百分数化：除100
    func percented() -> String {
        return String(Double(self)! / 100)
    }
}

// 拓展 CalculatorButtonItem.Op，添加具体的运算操作
extension CalculatorButtonItem.Op {
    func calculate(_ left: String, _ right: String) -> String? {
        guard let l = Double(left),
              let r = Double(right)
        else {
            return nil
        }

//        let calc: [CalculatorButtonItem.Op: (Double, Double) -> Double?] = [
//            .plus: { $0 + $1 },
//            .minus: { $0 - $1 },
//            .multiply: { $0 * $1 },
//            .divide: { $1 == 0 ? nil : $0 / $1 },
//        ]
//
        let result: Double?
//        result = calc[self]!(l, r)
        switch self {
        case .plus: result = l + r
        case .minus: result = l - r
        case .multiply: result = l * r
        case .divide: result = r == 0 ? nil : l / r
        case .equal: fatalError()
        }

        return result.map { String($0) }
    }
}

// // Redux 架构: Store, Action, Reducer
// // 这个程序小，没必要
// typealias CalculatorState = CalculatorBrain
// typealias CalculatorStateAction = CalculatorButtonItem
//
// struct Reducer {
//    static func reduce(state: CalculatorState, action: CalculatorStateAction)
//        -> CalculatorState {
//        return state.apply(action)
//    }
// }
