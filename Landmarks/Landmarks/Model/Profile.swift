//
//  Profile.swift
//  Landmarks
//
//  Created by c on 2021/1/7.
//  Copyright © 2021 CDFMLR. All rights reserved.
//

import Foundation

struct Profile {
    var username: String
    var prefersNotifications = true
    var seasonalPhoto = Season.winter
    var goalDate = Date()
    
    static let `default` = Profile(username: "foo_bar")
    
    enum Season: String, CaseIterable, Identifiable {
        case spring = "春"
        case summer = "夏"
        case autumn = "秋"
        case winter = "冬"
        
        var id: String { self.rawValue }
    }
}
