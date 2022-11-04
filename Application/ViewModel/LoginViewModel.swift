//
//  LoginViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/07.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class LoginViewModel: ObservableObject {
    private let repository: UserRepository
    
    private let userDefaultsManager: UserDefaultsManager
    
    init(_ repository: UserRepository, _ userDefaultsManager: UserDefaultsManager) {
        self.repository = repository
        self.userDefaultsManager = userDefaultsManager
    }
}
