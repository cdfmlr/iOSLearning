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
                Picker(selection: settingsBinding.accountBehavior, label: Text("")) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("电子邮箱", text: settingsBinding.email)
                SecureField("密码", text: settingsBinding.password)

                if settings.accountBehavior == .register {
                    SecureField("确认密码", text: settingsBinding.verifyPassword)
                }

                if settings.loginRequesting {
//                    Text("登录中...")
                    ActivityIndicator(
                        isAnimating: .constant(true),
                        style: .medium)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Button(settings.accountBehavior.text) {
                        self.store.dispatch(
                            .login(email: self.settings.email,
                                   password: self.settings.password
                            )
                        )
                    }.frame(maxWidth: .infinity, alignment: .center)
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
            Button("清除缓存") {
                print("清除缓存")
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: .center)
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
        store.appState.settings.loginRequesting = true

        return SettingView().environmentObject(store)
    }
}
