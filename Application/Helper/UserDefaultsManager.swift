//
//  UserDefaultsManager.swift
//  Application
//
//  Created by 홍희표 on 2021/11/21.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class UserDefaultsManager {
    private let userDefaults: UserDefaults = .standard
    
    var userPublisher: AnyPublisher<User?, Error> {
        get {
            return userDefaults.publisher(for: \.user)
                .tryMap {
                    if let data = $0 {
                        return try? PropertyListDecoder().decode(User.self, from: data)
                    } else {
                        return nil
                    }
                }
                .eraseToAnyPublisher()
        }
    }
    
    func storeUser(_ user: User) {
        userDefaults.user = try? PropertyListEncoder().encode(user)
    }
    
    func removeUser() {
        userDefaults.removeObject(forKey: UserDefaultsManager.USER_KEY)
    }
    
    func clear() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
    
    static let USER_KEY = "user"
    
    class var instance: UserDefaultsManager {
        struct Static {
            static let shared = UserDefaultsManager()
        }
        return Static.shared
    }
}

extension UserDefaults {
    // ??? 이상함
    @objc dynamic var key: Data? {
        return self.data(forKey: UserDefaultsManager.USER_KEY)
    }
    // 일단 이것으로 해결
    @objc var user: Data? {
        get {
            return data(forKey: UserDefaultsManager.USER_KEY)
        }
        set {
            set(newValue, forKey: UserDefaultsManager.USER_KEY)
        }
    }
}
