//
//  CalculatorButtonItem.swift
//  Calculator
//
//  Created by c on 2021/1/12.
//  Copyright © 2021 CDFMLR. All rights reserved.
//
import CoreGraphics

/// CalculatorButtonItem: 就是计算器的各种按钮
enum CalculatorButtonItem: Hashable {
    /// 运算符：加减乘除等
    enum Op: String {
        case plus = "+"
        case minus = "-"
        case divide = "÷"
        case multiply = "×"
        case equal = "="
    }

    /// 指令：清除、正负反转、百分数
    enum Command: String {
        case clear = "AC"
        case flip = "+/-"
        case percent = "%"
    }

    /// 0~9 的数字
    case digit(Int)
    /// 小数点
    case dot
    /// 运算符
    case op(Op)
    /// 指令
    case command(Command)
}

/// CalculatorButtonItem 在这个 extension 中追加外观定义
/// TODO(MVVM): 在 MView Model 里搞这个
extension CalculatorButtonItem {
    var title: String {
        switch self {
        case let .digit(value): return String(value)
        case .dot: return "."
        case let .op(op): return op.rawValue
        case let .command(command): return command.rawValue
        }
    }

    var size: CGSize {
        if case let .digit(value) = self, value == 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
        return CGSize(width: 88, height: 88)
    }

    var foregroundColorName: String {
        switch self {
        case .command: return "commandForeground"
        default: return ""
        }
    }

    var backgroundColorName: String {
        switch self {
        case .digit, .dot: return "digitBackground"
        case .op: return "operatorBackground"
        case .command: return "commandBackground"
        }
    }
}

extension CalculatorButtonItem: CustomStringConvertible {
    var description: String {
        switch self {
        case let .digit(num): return String(num)
        case .dot: return "."
        case let .op(op): return op.rawValue
        case let .command(command): return command.rawValue
        }
    }
}

// 🀄︎🀀🀁🀂🀃🀅🀆🀇🀈🀉🀊🀋🀌🀍🀎🀏🀐🀑🀒🀓🀔🀕🀖🀗🀘🀙🀚🀛🀜🀝🀞🀟🀠🀡🀢🀣🀤🀥🀦🀧🀨🀩🀪🀫
//
