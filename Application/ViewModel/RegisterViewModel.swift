//
//  RegisterViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/07.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var state = State()
    
    private let repository: UserRepository
    
    func register() {
        
    }
    
    init(_ repository: UserRepository) {
        self.repository = repository
    }
    
    struct State {
        var email: String = ""
        
        var password: String = ""
        
        var confirmPassword: String = ""
    }
}
