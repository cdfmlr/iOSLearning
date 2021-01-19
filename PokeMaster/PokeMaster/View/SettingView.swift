//
//  SettingView.swift
//  PokeMaster
//
//  Created by c on 2021/1/19.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var settings = Settings()

    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
    }

    var accountSection: some View {
        Section(header: Text("账户")) {
            Picker(selection: $settings.accountBehavior, label: Text("")) {
                ForEach(Settings.AccountBehavior.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            TextField("电子邮箱", text: $settings.email)
            SecureField("密码", text: $settings.password)

            if settings.accountBehavior == .register {
                SecureField("确认密码", text: $settings.verifyPassword)
            }

            Button(settings.accountBehavior.text) {
                print("登陆/注册")
            }.frame(maxWidth: .infinity, alignment: .center)
        }
    }

    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: $settings.showEnglishName) {
                Text("显示英文名")
            }

            Toggle(isOn: $settings.showFavoriteOnly) {
                Text("只显示收藏")
            }

            Picker(selection: $settings.sorting, label: Text("排序方式")) {
                ForEach(Settings.Sorting.allCases, id: \.self) {
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
        SettingView()
    }
}
