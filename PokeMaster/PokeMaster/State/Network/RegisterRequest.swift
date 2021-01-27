//
//  RegisterRequest.swift
//  PokeMaster
//
//  Created by c on 2021/1/27.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct RegisterRequest {
    let email: String
    let password: String

    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            // 延时 1.5 秒执行，模拟网络请求的延时状况。
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                #if DEBUG
                print("[RegisterRequest] email=\(self.email), password=\(self.password)")
                #endif
                
                if self.email.lowercased() != "foo@bar.com" {
                    let user = User(
                        email: self.email,
                        favoritePokemonIDs: []
                    )
                    promise(.success(user))
                } else {
                    promise(.failure(.emailOccupied))
                }
            }
        }
        .receive(on: DispatchQueue.main)  // 要更新 UI
        .eraseToAnyPublisher()
    }
}
