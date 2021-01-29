//
//  AppAction.swift
//  PokeMaster
//
//  Created by c on 2021/1/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

enum AppAction {
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
    case logout
    case emailValid(valid: Bool)
    case loadPokemons
    case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
    case passwordValid(valid: Bool)
    case register(email: String, password: String)
    case cacheClean
    case cleanCacheDone
    /// 切换 cell 展开状态
    case toggleListSelection(index: Int?)
    /// 加载技能
    case loadAbilities(pokemon: Pokemon)
    /// 技能加载结束
    case loadAbilitiesDone(result: Result<[AbilityViewModel], AppError>)
    
    case togglePanelPresenting(presenting: Bool)
    case closeSafariView
    /// 显示对话框，请求登陆
    case requireLogin
    /// 转去设置页面登陆
    case toLogin
}
