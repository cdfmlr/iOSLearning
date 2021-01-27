//
//  SettingView.swift
//  PokeMaster
//
//  Created by c on 2021/1/19.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingView: View {
//    @ObservedObject var settings = Settings()

    @EnvironmentObject var store: Store

    var settingsBinding: Binding<AppState.Settings> {
        $store.appState.settings
    }

    var settings: AppState.Settings {
        store.appState.settings
    }

    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
        .alert(item: settingsBinding.loginError) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }

    var accountSection: some View {
        Section(header: Text("账户")) {
            if settings.loginUser == nil { // 没登录
                Picker(selection: settingsBinding.account.accountBehavior,
                       label: Text("")) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("电子邮箱", text: settingsBinding.account.email)
                    .foregroundColor(settings.isEmailValid ? .green : .red)

                SecureField("密码", text: settingsBinding.account.password)

                if settings.account.accountBehavior == .register {
                    SecureField("确认密码", text: settingsBinding.account.verifyPassword)
                }

                if settings.loginRequesting {
//                    Text("登录中...")
                    ActivityIndicator(
                        isAnimating: .constant(true),
                        style: .medium)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Button(settings.account.accountBehavior.text) {
                        switch self.settings.account.accountBehavior {
                        case .login:
                            self.store.dispatch(
                                .login(email: self.settings.account.email,
                                       password: self.settings.account.password
                                )
                            )
                        case .register:
                            self.store.dispatch(
                                .register(email: self.settings.account.email,
                                          password: self.settings.account.password
                                )
                            )
                        }
                    }
                    .disabled(!settings.isPasswordValid)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            } else { // 已登陆
                HStack {
                    Text("已登陆: ").font(.headline)
                    Text(settings.loginUser!.email)
                }

                Button("注销") {
                    self.store.dispatch(.logout)
                }.frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: settingsBinding.showEnglishName) {
                Text("显示英文名")
            }

            Toggle(isOn: settingsBinding.showFavoriteOnly) {
                Text("只显示收藏")
            }

            Picker(selection: settingsBinding.sorting, label: Text("排序方式")) {
                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
        }
    }

    var actionSection: some View {
        Section(header: Text("")) {
            if settings.cacheCleaning {
                ActivityIndicator(
                    isAnimating: .constant(true),
                    style: .medium)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Button("清除缓存") {
                    #if DEBUG
                        print("清除缓存")
                    #endif
                    self.store.dispatch(.cacheClean)
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
                .alert(isPresented: settingsBinding.cacheCleanDone) {
                    Alert(title: Text("缓存已清理"))
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.settings.sorting = .color
//        store.appState.settings.loginUser = User(
//            email: "foo@bar.com",
//            favoritePokemonIDs: [1, 2, 3]
//        )
//        store.appState.settings.loginRequesting = true

        return SettingView().environmentObject(store)
    }
}
