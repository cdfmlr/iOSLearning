//
//  AbilityRequest.swift
//  PokeMaster
//
//  Created by c on 2021/1/28.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine
import Foundation

struct AbilityRequest {
    let ability: Pokemon.AbilityEntry

    func abilityPublisher(for ability: Pokemon.AbilityEntry) -> AnyPublisher<AbilityViewModel, AppError> {
        URLSession.shared.dataTaskPublisher(
            for: ability.ability.url
        )
        .map { $0.data }
        .decode(type: Ability.self, decoder: appDecoder)
        .map { AbilityViewModel(ability: $0) }
        .mapError { AppError.networkingFailed($0) }
        .eraseToAnyPublisher()
    }

    var publisher: AnyPublisher<AbilityViewModel, AppError> {
        abilityPublisher(for: self.ability)
    }
}
