//
//  Settings.swift
//  PokeMaster
//
//  Created by c on 2021/1/19.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

/// app 的偏好设置
class Settings: ObservableObject {
    enum AccountBehavior: CaseIterable {
        case register, login
    }

    enum Sorting: CaseIterable {
        case id, name, color, favorite
    }

    @Published var accountBehavior = AccountBehavior.login
    @Published var email = ""
    @Published var password = ""
    @Published var verifyPassword = ""

    @Published var showEnglishName = true
    @Published var sorting = Sorting.id
    @Published var showFavoriteOnly = false
}

// 拓展 Settings.Sorting: text: 显示在 UI 中的文本
extension Settings.Sorting {
    /// 显示在 UI 中的文本
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}

// 拓展 Settings.AccountBehavior: text: 显示在 UI 中的文本
extension Settings.AccountBehavior {
    /// 显示在 UI 中的文本
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}
