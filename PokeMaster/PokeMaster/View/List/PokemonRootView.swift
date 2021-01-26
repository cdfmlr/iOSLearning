//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by c on 2021/1/19.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    var body: some View {
        NavigationView {
            PokemonList().navigationBarTitle("Pokémon")
        }
    }
}

struct PokemonRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
    }
}
