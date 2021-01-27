//
//  EmailCheckingRequest.swift
//  PokeMaster
//
//  Created by c on 2021/1/26.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine
import Foundation

struct EmailCheckingRequest {
    let email: String

    var publisher: AnyPublisher<Bool, Never> {
        Future<Bool, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                #if DEBUG
                print("[EmailCheckingRequest] email: \(self.email.lowercased())")
                #endif
                
                if self.email.lowercased() == "foo@bar.com" {
                    promise(.success(false))
                } else {
                    promise(.success(true))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
