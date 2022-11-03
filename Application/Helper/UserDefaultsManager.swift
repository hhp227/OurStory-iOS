//
//  UserDefaultsManager.swift
//  Application
//
//  Created by 홍희표 on 2021/11/21.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    class var instance: UserDefaultsManager {
        struct Static {
            static let shared = UserDefaultsManager()
        }
        return Static.shared
    }
}
