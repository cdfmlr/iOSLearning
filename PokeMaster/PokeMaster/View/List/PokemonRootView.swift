//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by c on 2021/1/19.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationView {
            if store.appState.pokemonList.loadPokemonsError != nil {
                VStack {
                    Text("加载失败").font(.headline)
                    Text(store.appState.pokemonList.loadPokemonsError!.localizedDescription)
                    RetryButton {
                        self.store.dispatch(
                            .loadPokemons
                        )
                    }
                }.foregroundColor(.gray)
            } else if store.appState.pokemonList.pokemons == nil {
                VStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    Text("Loading...").onAppear {
                        self.store.dispatch(
                            .loadPokemons
                        )
                    }
                }

            } else {
                PokemonList().navigationBarTitle("Pokémon")
            }
        }
    }
}

struct PokemonRootView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.pokemonList.loadPokemonsError = AppError.emailOccupied
        return PokemonRootView().environmentObject(store)
    }
}
