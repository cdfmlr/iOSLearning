//
//  MainTab.swift
//  PokeMaster
//
//  Created by c on 2021/1/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    @EnvironmentObject var store: Store
    
    var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    
    var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }
    
    var body: some View {
        TabView(selection: $store.appState.mainTab.selection) {
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("列表")
            }
            .tag(AppState.MainTab.Index.list)
            
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
            .tag(AppState.MainTab.Index.settings)
        }.edgesIgnoringSafeArea(.top)
        // .overlay(panel)
            .overlaySheet(isPresented: pokemonListBinding.dynamic.panelPresented) {
                if self.pokemonList.pokemons != nil &&
                    self.pokemonList.dynamic.panelIndex != nil {
                    PokemonInfoPanelOverlay(
                        model: self.pokemonList.pokemons![self.pokemonList.dynamic.panelIndex!]!
                    )
                }
        }
    }
}

// panel
//extension MainTab {
//    var panel: some View {
//        Group {
//            if pokemonList.dynamic.panelPresented {
//                if pokemonList.pokemons != nil &&
//                    pokemonList.dynamic.panelIndex != nil {
//                    PokemonInfoPanelOverlay(
//                        model: pokemonList.pokemons![pokemonList.dynamic.panelIndex!]!
//                    )
//                } else {
//                    EmptyView()
//                }
//            } else {
//                EmptyView()
//            }
//        }
//    }
//}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab().environmentObject(Store())
    }
}
