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
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return email.contains("@") ? NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email) : !email.isEmpty
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return !password.isEmpty
    }
    
    func login() {
        if isEmailValid(email) && isPasswordValid(password) {
            AF.request(URL_LOGIN, method: .post, parameters: ["email": email, "password": password]).responseJSON { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    break
                case .failure(_):
                    print("fail")
                    break
                }
            }
        } else {
            print("email 또는 password가 잘못되었습니다.")
        }
    }
}
