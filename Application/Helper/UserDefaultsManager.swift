//
//  UserDefaultsManager.swift
//  Application
//
//  Created by 홍희표 on 2021/11/21.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    private static let USER_KEY = "user"
    
    class var instance: UserDefaultsManager {
        struct Static {
            static let shared = UserDefaultsManager()
        }
        return Static.shared
    }
    
    let userDefaults: UserDefaults = .standard
    
    var user: User? {
        get {
            guard let user = userDefaults.data(forKey: UserDefaultsManager.USER_KEY) else {
                return nil
            }
            return try? PropertyListDecoder().decode(User.self, from: user)
        }
    }
    
    func storeUser(_ user: User) {
        userDefaults.set(try? PropertyListEncoder().encode(user), forKey: UserDefaultsManager.USER_KEY)
    }
    
    func removeUser() {
        userDefaults.removeObject(forKey: UserDefaultsManager.USER_KEY)
    }
    
    func clear() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}
