//
//  LoginViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/07.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Combine
import Alamofire

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var loginState: LoginState
    
    @Published var isShowRegister = false
    
    private let loginRepository: LoginRepository
    
    init(_ repository: LoginRepository) {
        self.loginRepository = repository
        loginState = UserDefaults.standard.value(forKey: "user") != nil ? .login : .logout
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return email.contains("@") ? NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email) : !email.isEmpty
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return !password.isEmpty
    }
    
    func login() {
        if isEmailValid(email) && isPasswordValid(password) {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.loginRepository.login(self.email, self.password) { success in
                    self.loginState = success ? .login : .logout
                }
            }
        } else {
            print("email 또는 password가 잘못되었습니다.")
        }
    }
    
    enum LoginState {
        case login
        case logout
    }
}
