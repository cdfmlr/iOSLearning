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

    /// 用来保持 AnyCancellable 的数组
    var disposeBag = [AnyCancellable]()

    init() {
        setupObservers()
    }

    func setupObservers() {
        appState.settings.account.isEmailValid
            .sink { isValid in
                self.dispatch(.emailValid(valid: isValid))
            }.store(in: &disposeBag)

        appState.settings.account.isPasswordValid
            .sink { isValid in
                #if DEBUG
                    print("isPasswordValid: \(isValid)")
                #endif
                self.dispatch(.passwordValid(valid: isValid))
            }.store(in: &disposeBag)
    }

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
        case let .register(email, password):
            guard !appState.settings.loginRequesting else {
                break
            }
            appState.settings.loginRequesting = true // 共用一下登陆的啦

            appCommand = RegisterAppCommand(email: email, password: password)
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
        case let .emailValid(valid):
            appState.settings.isEmailValid = valid
        case let .passwordValid(valid):
            appState.settings.isPasswordValid = valid
        case .loadPokemons:
            if appState.pokemonList.loadingPokemons {
                break
            }
            appState.pokemonList.loadingPokemons = true
            appState.pokemonList.loadPokemonsError = nil
            
            appCommand = LoadPokemonsCommand()
        case let .loadPokemonsDone(result):
            switch result {
            case let .success(viewModels):
                appState.pokemonList.pokemons = Dictionary(
                    uniqueKeysWithValues: viewModels.map { ($0.id, $0) }
                )
            case let .failure(error):
                print(error)
                appState.pokemonList.loadPokemonsError = error
            }
            appState.pokemonList.loadingPokemons = false
        case .cacheClean:
            if appState.settings.cacheCleaning {
                break
            }
            appState.settings.cacheCleaning = true
            appCommand = CacheCleanAppCommand()
        case .cleanCacheDone:
            appState.settings.cacheCleaning = false
            appState.settings.cacheCleanDone = true
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
