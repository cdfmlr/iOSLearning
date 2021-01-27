//
//  AppError.swift
//  PokeMaster
//
//  Created by c on 2021/1/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription } // TODO: 为每个错误定义自定义 error code, 作为 id

    case passwordWrong
    case networkingFailed(Error)
    case emailOccupied
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .passwordWrong: return "密码错误"
        case let .networkingFailed(error): return error.localizedDescription
        case .emailOccupied: return "邮箱已被注册"
        }
    }
}
