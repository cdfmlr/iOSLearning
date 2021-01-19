//
//  PokemonList.swift
//  PokeMaster
//
//  Created by c on 2021/1/18.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    @State var expandingIndex: Int?
    @State var searching: String = ""

    var body: some View {
//        List(PokemonViewModel.all) { pokemon in
//            PokemonInfoRow(model: pokemon)
//        }
        ScrollView {
            SearchView()

            ForEach(PokemonViewModel.all) { pokemon in
                PokemonInfoRow(
                    model: pokemon,
                    expanded: self.expandingIndex == pokemon.id
                )
                .onTapGesture {
                    if self.expandingIndex == pokemon.id {
                        self.expandingIndex = nil
                    } else {
                        self.expandingIndex = pokemon.id
                    }
                }
            }
            .padding(.horizontal)
        }.overlay(VStack {
            Spacer()
            PokemonInfoPanel(model: .sample(id: 1))
        }).edgesIgnoringSafeArea(.bottom)
            .resignKeyboardOnDragGesture()
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}
