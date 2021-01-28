//
//  AppCommand.swift
//  PokeMaster
//
//  Created by c on 2021/1/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine
import Foundation
import Kingfisher

protocol AppCommand {
    /// 执行副作用的入口
    /// - Parameter store: 提供一个执行后续操作的上下文，
    /// 在副作用执行完毕时，发送新的 Action 来更改 app 状态。
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String

    func execute(in store: Store) {
        let token = SubscriptionToken()

        LoginRequest(
            email: email,
            password: password
        ).publisher
//            .print("[LoginAppCommand]")
            .sink(
                receiveCompletion: { complete in
                    if case let .failure(error) = complete {
                        store.dispatch(
                            .accountBehaviorDone(result: .failure(error))
                        )
                    }
                    token.unseal()
                },
                receiveValue: { user in
                    store.dispatch(
                        .accountBehaviorDone(result: .success(user))
                    )
                })
            .seal(in: token)
    }
}

/// 暂存 AnyCancellable，保障其不被过早销毁
/// - Refer: https://forums.swift.org/t/combine-future-broken/28560
/// LoginAppCommand 里要用
class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    /// 保持 AnyCancellable 存在，不被过早销毁
    /// - Refer: https://forums.swift.org/t/combine-future-broken/28560
    /// LoginAppCommand 里要用
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}

/// 把登陆用户 loginUser 持久化，写到硬盘
///
/// ⚠️ DON'T USE THIS:
/// 这是个纯副作用，不需要改变状态。
/// 对于纯副作用，可以允许不严格定义 Command 走整个单向流程，
/// 可以用 `didSet`跳过严格的 Command 流程，来执行这个副作用。
struct WriteUserAppCommand: AppCommand {
    let user: User

    func execute(in store: Store) {
        try? FileHelper.writeJSON(
            user,
            to: .documentDirectory,
            fileName: "user.json"
        )
    }
}

struct LoadPokemonsCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadPokemonRequest.all
            .sink(
                receiveCompletion: { complete in
                    if case let .failure(error) = complete {
                        store.dispatch(
                            .loadPokemonsDone(result: .failure(error))
                        )
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(
                        .loadPokemonsDone(result: .success(value))
                    )
                }
            ).seal(in: token)
    }
}

struct RegisterAppCommand: AppCommand {
    let email: String
    let password: String

    func execute(in store: Store) {
        let token = SubscriptionToken()

        #if DEBUG
            print("[Register]: \(email) \(password)")
        #endif

        RegisterRequest(
            email: email,
            password: password
        ).publisher
            .sink(
                receiveCompletion: { complete in
                    if case let .failure(error) = complete {
                        store.dispatch(
                            .accountBehaviorDone(result: .failure(error))
                        )
                    }
                    token.unseal()
                },
                receiveValue: { user in
                    store.dispatch(
                        .accountBehaviorDone(result: .success(user))
                    )
                })
            .seal(in: token)
    }
}

struct CacheCleanAppCommand: AppCommand {
    func execute(in store: Store) {
        try? FileHelper.delete(from: .cachesDirectory, fileName: "pokemons.json")
        Kingfisher.ImageCache.default.clearDiskCache { // async
            #if DEBUG
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    store.dispatch(.cleanCacheDone)
                }
            #else
                store.dispatch(.cleanCacheDone)
            #endif
        }
    }
}

struct loadAbilitiesCommand: AppCommand {
    let pokemon: Pokemon

    func execute(in store: Store) {
        let token = SubscriptionToken()

        #if DEBUG
            print("[loadAbilitiesCommand]: \(pokemon)")
        #endif

        pokemon.abilities
            .filter { ability in
                if let abilities = store.appState.pokemonList.abilities {
                    return abilities[ability.ability.url.extractedID!] == nil
                }
                return true
            }
            .map {
                AbilityRequest(ability: $0).publisher
            }
            .zipAll
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { complete in
                    if case let .failure(error) = complete {
                        store.dispatch(
                            .loadAbilitiesDone(result: .failure(error))
                        )
                    }
                    token.unseal()
                },
                receiveValue: { viewModels in
                    if viewModels.isEmpty { // fast lane
                        return
                    }
                    store.dispatch(
                        .loadAbilitiesDone(result: .success(viewModels))
                    )
                })
            .seal(in: token)
    }
}
