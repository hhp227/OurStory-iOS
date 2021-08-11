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
    private let registerRepository: RegisterRepository
    
    @Published var name: String = ""
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    init(_ repository: RegisterRepository) {
        self.registerRepository = repository
    }
    
    func register() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.registerRepository.register(self.name, self.email, self.password)
        }
    }
}
