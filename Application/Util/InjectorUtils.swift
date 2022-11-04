//
//  InjectorUtils.swift
//  Application
//
//  Created by 홍희표 on 2022/03/18.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation

class InjectorUtils {
    static var instance = InjectorUtils.init()
    
    func getUserDefaultsManager() -> UserDefaultsManager {
        return UserDefaultsManager.instance
    }
    
    private func getUserRepository() -> UserRepository {
        return UserRepository()
    }
    
    func provideLoginViewModel() -> LoginViewModel {
        return LoginViewModel(getUserRepository(), getUserDefaultsManager())
    }
    
    func provideContentViewModel() -> ContentViewModel {
        return ContentViewModel(getUserDefaultsManager())
    }
}
