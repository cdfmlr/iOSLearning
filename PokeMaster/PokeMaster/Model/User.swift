//
//  User.swift
//  PokeMaster
//
//  Created by c on 2021/1/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct User: Codable {
    var email: String
    var favoritePokemonIDs: Set<Int>

    func isFavoritePokemon(id: Int) -> Bool {
        favoritePokemonIDs.contains(id)
    }
    
    
}
