//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by c on 2021/1/18.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonInfoPanel: View {
    @EnvironmentObject var store: Store
    
    let model: PokemonViewModel
    
    @State var darkBlur = false

    var abilities: [AbilityViewModel] {
        // AbilityViewModel.sample(pokemonID: model.id)
        store.appState.pokemonList.abilityViewModels(for: model.pokemon) ?? []
    }

    var body: some View {
        VStack(spacing: 20) {
            topIndicator

            Header(model: model)

            pokemonDescription

            Divider()

            AbilityList(model: model, abilityModels: abilities)
            
            Button(action: {
                self.darkBlur.toggle()
            }) {
                Image(systemName: self.darkBlur ? "sun.max.fill" : "moon")
            }
            
            Spacer().frame(width: 0, height: 16, alignment: .center)
            
        }.padding(EdgeInsets(
            top: 12, leading: 30, bottom: 30, trailing: 30
        ))
            // .background(Color.white)
            .blurBackground(style: darkBlur ? .systemMaterialDark : .systemMaterial)
            .cornerRadius(20)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// PokemonInfoPanel: topIndicator View: 顶部的指示条
extension PokemonInfoPanel {
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
}

// PokemonInfoPanel: Header View: 图片、名字啥的
extension PokemonInfoPanel {
    struct Header: View {
        let model: PokemonViewModel

        var body: some View {
            HStack(spacing: 18) {
                pokemonIcon

                nameSpecies

                verticalDivider

                VStack(spacing: 12) {
                    bodyStatus

                    typeInfo
                }
            }
        }

        var pokemonIcon: some View {
            Image("Pokemon-\(model.id)")
                .resizable()
                .frame(width: 68, height: 68)
        }

        var nameSpecies: some View {
            VStack {
                Text(model.name)
                    .font(.system(size: 22))
                    .bold()
                    .foregroundColor(model.color)

                Text(model.nameEN)
                    .font(.system(size: 13))
                    .bold()
                    .foregroundColor(model.color)

                Spacer().frame(height: 10)

                Text(model.genus)
                    .font(.system(size: 13))
                    .bold()
                    .foregroundColor(.gray)
            }
        }

        var verticalDivider: some View {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 1, height: 44)
                .opacity(0.1)
        }

        var bodyStatus: some View {
            VStack(alignment: .leading) {
                BodyStatusItem(key: "身高", value: model.height,
                               color: model.color)
                BodyStatusItem(key: "体重", value: model.weight,
                               color: model.color)
            }
        }

        var typeInfo: some View {
            HStack {
//                Text(model.types.map { $0.name }.joined())
                ForEach(model.types) { type in
                    TypeInfoItem(name: type.name, color: type.color)
                }
            }
        }

        struct BodyStatusItem: View {
            let key: String
            let value: String
            let color: Color

            var body: some View {
                HStack {
                    Text(key)
                        .foregroundColor(.gray)
                    Text(value)
                        .foregroundColor(color)
                }.font(.system(size: 11))
            }
        }

        struct TypeInfoItem: View {
            let name: String
            let color: Color

            var body: some View {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .frame(width: 36, height: 14)
                        .foregroundColor(color)
                    Text(name)
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

// PokemonInfoPanel: pokemonDescription View: 描述，一大段文本
extension PokemonInfoPanel {
    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true)
    }
}

// PokemonInfoPanel: AbilityList View: 技能列表
extension PokemonInfoPanel {
    struct AbilityList: View {
        let model: PokemonViewModel
        let abilityModels: [AbilityViewModel]?

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("技能")
                    .font(.headline)
                    .fontWeight(.bold)
                if abilityModels != nil {
                    ForEach(abilityModels!) { ability in
                        Text(ability.name)
                            .font(.subheadline)
                            .foregroundColor(self.model.color)
                        Text(ability.descriptionText)
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0xAAAAAA))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct PokemonInfoPanelOverlay: View {
    let model: PokemonViewModel
    
    var body: some View {
        VStack {
            Spacer()
            PokemonInfoPanel(model: model)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: .sample(id: 1))
            .environmentObject(Store())
    }
}
