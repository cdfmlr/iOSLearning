//
//  PokemonList.swift
//  PokeMaster
//
//  Created by c on 2021/1/18.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
//    @State var expandingIndex: Int?
//    @State var searchText: String = ""
    
    @EnvironmentObject var store: Store
    
    var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    
    var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }

    var body: some View {
//        List(PokemonViewModel.all) { pokemon in
//            PokemonInfoRow(model: pokemon)
//        }
        ScrollView {
            SearchView(searchText: self.pokemonListBinding.dynamic.searchText)

            ForEach(pokemonList.allPokemonsByID) { pokemon in
                PokemonInfoRow(
                    model: pokemon,
                    expanded: self.pokemonList.dynamic.expandingIndex == pokemon.id
                )
                .onTapGesture {
                    self.store.dispatch(
                        .toggleListSelection(index: pokemon.id)
                    )
                    self.store.dispatch(
                        .loadAbilities(pokemon: pokemon.pokemon)
                    )
                }
            }
            .padding(.horizontal)
        }
        /* .overlay(VStack {
                     Spacer()
                     PokemonInfoPanel(model: .sample(id: 1))
                 })
                .edgesIgnoringSafeArea(.bottom)
         */
        .resignKeyboardOnDragGesture() // 滑动关闭搜索键盘
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList().environmentObject(Store())
    }
}
