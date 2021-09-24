//
//  RegisterViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/07.
//  Copyright © 2021 홍희표. All rights reserved.
//
import Combine
import Foundation

class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var registerResult = false
    
    private let repository: RegisterRepository
    
    init(_ repository: RegisterRepository) {
        self.repository = repository
    }
    
    func register() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.repository.register(self.name, self.email, self.password) { isRegister in
                DispatchQueue.main.async {
                    self.registerResult = isRegister
                }
            }
        }
    }
}
