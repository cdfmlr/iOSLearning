//
//  UserDefault.swift
//  PokeMaster
//
//  Created by c on 2021/1/26.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

@propertyWrapper struct UserDefault<T: UserDefaultStoragable> {
    var value: T

    let key: String
    // let defaultValue: T

    init(forKey key: String, defaultValue: T) {
        value = defaultValue
        if let obj = UserDefaults.standard.object(forKey: key) {
            value.store = obj
        }
        
        self.key = key
    }

    var wrappedValue: T {
        set {
            value = newValue
            UserDefaults.standard.set(value.store, forKey: key)
            
            #if DEBUG
            print("[UserDefaults]", Array(UserDefaults.standard.dictionaryRepresentation()))
            #endif
        }
        get { value }
    }
}

/// 实现这个协议才能用 `UserDefault` 去储存
///
/// 主要是为了储存各种 enum 什么的
///
/// - Write:
/// ```
/// UserDefaults.standard.set(value.store, forKey: "key")
/// ```
///
/// - Read:
/// ```
/// if let obj = UserDefaults.standard.object(forKey: "key") {
///     value.store = obj
/// }
/// ```
///
protocol UserDefaultStoragable {
    var store: Any { get set }
}

extension Bool: UserDefaultStoragable {
    var store: Any {
        get { self }
        set { self = newValue as! Bool }
    }
}

extension AppState.Settings.Sorting: UserDefaultStoragable {
    var store: Any {
        get { rawValue }
        set {
            self = AppState.Settings.Sorting(
                rawValue: newValue as! Int
            ) ?? .id
        }
    }
}
