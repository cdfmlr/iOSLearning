//
//  AppState.swift
//  PokeMaster
//
//  Created by c on 2021/1/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine
import Foundation

/// AppState 包含 app 的设置
struct AppState {
    var settings = Settings()
    var pokemonList = PokemonList()
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

        class Account {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""

            var isEmailValid: AnyPublisher<Bool, Never> {
                /// behavior 切换至“注册”时要在线检查 email
                let emailToRegister: AnyPublisher<String, Never> = $accountBehavior
                    .compactMap { behavior in
                        if case .register = behavior {
                            return self.email
                        }
                        return nil
                    }.debounce(
                        for: .milliseconds(500),
                        scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .eraseToAnyPublisher()

                let emailLocalValid = $email
                    .merge(with: emailToRegister)
                    .map { $0.isValidEmailAddress }

                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }

                let remoteVerify = $email
                    .debounce(
                        for: .milliseconds(500),
                        scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .merge(with: emailToRegister)
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login

                        switch (validEmail, canSkip) {
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher.eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }.print("[remoteVerify]")

                return Publishers.CombineLatest3(
                    emailLocalValid, canSkipRemoteVerify, remoteVerify
                )
//                .print("[CombineLatest3]") // DEBUG
                .map { $0 && ($1 || $2) }
                .removeDuplicates()
                .eraseToAnyPublisher()
            }

            var isPasswordValid: AnyPublisher<Bool, Never> {
                // 切换 login/register 的时候检查一次 verifyPassword
                let verifyPasswordToRegister: AnyPublisher<String, Never> = $accountBehavior
                    .map { _ in self.verifyPassword }
                    .debounce(
                        for: .milliseconds(500),
                        scheduler: DispatchQueue.main)
//                    .removeDuplicates()
                    .eraseToAnyPublisher()

                let passwordValid = $password
                    .removeDuplicates()
                    .map { $0.isValidPassword }

                let verifyPassword = $verifyPassword
//                    .filter { _ in self.accountBehavior == .register }
                    .merge(with: verifyPasswordToRegister)
//                    .removeDuplicates()
                    .map { self.accountBehavior != .register || $0.isValidPassword && $0 == self.password }

                return passwordValid.combineLatest(verifyPassword)
                    .map { $0 && $1 }
                    .removeDuplicates()
                    .eraseToAnyPublisher()
            }
        }

        var account = Account()

        var isEmailValid: Bool = false

        var isPasswordValid: Bool = false

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
        
        var cacheCleaning: Bool = false
        // 清理完缓存，通知用户
        var cacheCleanDone: Bool = false
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

// 在这个拓展里定义一个叫做 PokemonList 的值东西，覆盖掉全局的同名对象（View/List/PokemonList.swift）
extension AppState {
    /// 持有 `PokemonViewModel`
    struct PokemonList {
        // pokemons 磁盘缓存，避免重复请求
        @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
        var pokemons: [Int: PokemonViewModel]?

        var loadingPokemons = false
        var loadPokemonsError: AppError? = nil

        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return []
            }
            return pokemons.sorted { $0.id < $1.id }
        }
    }
}
