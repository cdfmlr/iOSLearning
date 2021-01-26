//
//  Store.swift
//  PokeMaster
//
//  Created by c on 2021/1/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine
import Foundation

class Store: ObservableObject {
    @Published var appState = AppState()

    /// 处理某个 `AppAction`，并返回新的 `AppState`
    static func reduce(state: AppState, action: AppAction) -> (state: AppState, command: AppCommand?) {
        var appState = state
        var appCommand: AppCommand?

        switch action {
        case let .login(email, password):
            guard !appState.settings.loginRequesting else {
                break
            }
            appState.settings.loginRequesting = true

            appCommand = LoginAppCommand(email: email, password: password)
        case let .accountBehaviorDone(result):
            appState.settings.loginRequesting = false

            switch result {
            case let .success(user):
                appState.settings.loginUser = user
            case let .failure(error):
                print("error: \(error)")
                appState.settings.loginError = error
            }
        case .logout:
            appState.settings.loginUser = nil
        }

        return (appState, appCommand)
    }

    /// 给 View 调用的用于表示发送了某个 Action 的方法:
    /// 将当前 AppState 和收到的 Action 交给 reduce，然后把返回的 state 设置为新的状态。
    func dispatch(_ action: AppAction) {
        #if DEBUG
            print("[dispatch] action: \(action)")
        #endif

        let result = Store.reduce(state: appState, action: action)

        appState = result.state

        if let command = result.command {
            #if DEBUG
                print("[dispatch] command: \(command)")
            #endif

            command.execute(in: self)
        }
    }
}
