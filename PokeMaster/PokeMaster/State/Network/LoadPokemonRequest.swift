//
//  LoadPokemonRequest.swift
//  PokeMaster
//
//  Created by c on 2021/1/27.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine
import Foundation

struct LoadPokemonRequest {
    let id: Int

    func pokemonPublisher(id: Int) -> AnyPublisher<Pokemon, Error> {
        URLSession.shared.dataTaskPublisher(
            for: URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        )
        .map { $0.data }
        .decode(type: Pokemon.self, decoder: appDecoder)
        .eraseToAnyPublisher()
    }

    func speciesPublisher(pokemon: Pokemon) -> AnyPublisher<(Pokemon, PokemonSpecies), Error> {
        URLSession.shared.dataTaskPublisher(
            for: pokemon.species.url
        )
        .map { $0.data }
        .decode(type: PokemonSpecies.self, decoder: appDecoder)
        .map { (pokemon, $0) }
        .eraseToAnyPublisher()
    }

    var publisher: AnyPublisher<PokemonViewModel, AppError> {
        pokemonPublisher(id: id)
            .flatMap { pokemon in self.speciesPublisher(pokemon: pokemon) }
            .map { PokemonViewModel(pokemon: $0, species: $1) }
            .mapError { AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    static var all: AnyPublisher<[PokemonViewModel], AppError> {
        (1 ... 50).map {
            LoadPokemonRequest(id: $0).publisher
        }.zipAll
    }
}

extension Array where Element: Publisher {
    var zipAll: AnyPublisher<[Element.Output], Element.Failure> {
        let initial = Just([Element.Output]())
            .setFailureType(to: Element.Failure.self)
            .eraseToAnyPublisher()
        return reduce(initial) { result, publisher in
            result.zip(publisher) { $0 + [$1] }
                .eraseToAnyPublisher()
        }
    }
}
