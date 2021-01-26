//
//  AppState.swift
//  PokeMaster
//
//  Created by c on 2021/1/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

/// AppState 包含 app 的设置
struct AppState {
    var settings = Settings()
}

extension AppState {
    /// app 的偏好设置
    struct Settings {
        enum Sorting: Int, CaseIterable { // 用 Int 方便序列化（以储存）
            case id, name, color, favorite
        }

        @UserDefault(forKey: "showEnglishName", defaultValue: true)
        var showEnglishName: Bool /* = true */

        @UserDefault(forKey: "sorting", defaultValue: Sorting.id)
        var sorting: Sorting /* = Sorting.id */

        @UserDefault(forKey: "showFavoriteOnly", defaultValue: false)
        var showFavoriteOnly: Bool /* = false */

        enum AccountBehavior: CaseIterable {
            case register, login
        }

        var accountBehavior = AccountBehavior.login
        var email = ""
        var password = ""
        var verifyPassword = ""

        // 在这里读取、保存、删除 loginUser 的持久化。
        // 这是个纯副作用，所以不用 AppCommand 写了。
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User? /* 这些事情给 @FileStorage 做了 =
             try? FileHelper.loadJSON(
                 from: .documentDirectory,
                 fileName: "user.json") {
             didSet {
                 if let user = loginUser {
                     try? FileHelper.writeJSON(
                         user,
                         to: .documentDirectory,
                         fileName: "user.json")
                 } else {  // loginUser = nil
                     try? FileHelper.delete(
                         from: .documentDirectory,
                         fileName: "user.json")
                 }
             }
         } */

        var loginRequesting: Bool = false
        var loginError: AppError?
    }
}

// 拓展 AppState.Settings.Sorting: text: 显示在 UI 中的文本
extension AppState.Settings.Sorting {
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

// 拓展 AppState.Settings.AccountBehavior: text: 显示在 UI 中的文本
extension AppState.Settings.AccountBehavior {
    /// 显示在 UI 中的文本
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}
