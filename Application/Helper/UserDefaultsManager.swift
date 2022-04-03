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
        userDefaults.user = try? PropertyListEncoder().encode(user)
        //userDefaults.set(try? PropertyListEncoder().encode(user), forKey: UserDefaultsManager.USER_KEY)
    }
    
    func removeUser() {
        userDefaults.removeObject(forKey: UserDefaultsManager.USER_KEY)
    }
    
    func clear() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
    
    // 제거하거나 수정할것
    func test() -> NSObject.KeyValueObservingPublisher<UserDefaults, Data?> {
        return userDefaults.publisher(for: \.key)
    }
    
    func getUser() -> NSObject.KeyValueObservingPublisher<UserDefaults, Data?> {
        return userDefaults.publisher(for: \.user)
    }
    
    func temp() -> AnyPublisher<Data, Never> {
        return userDefaults.data(forKey: UserDefaultsManager.USER_KEY).publisher.eraseToAnyPublisher()
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
