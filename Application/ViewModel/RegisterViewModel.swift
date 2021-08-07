//
//  RegisterViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/07.
//  Copyright © 2021 홍희표. All rights reserved.
//
import Combine

class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    func register() {
        
    }
}
