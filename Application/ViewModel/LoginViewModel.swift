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
    private let loginRepository: LoginRepository
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var loginResult: Bool = false
    
    init(_ loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return email.contains("@") ? NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email) : !email.isEmpty
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return !password.isEmpty
    }
    
    //TODO Alamofire를 사용할지
    func login() {
        if isEmailValid(email) && isPasswordValid(password) {
            AF.request(URL_LOGIN, method: .post, parameters: ["email": email, "password": password]).responseJSON { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    self.loginResult = true
                    break
                case .failure(_):
                    print("fail")
                    self.loginResult = false
                    break
                }
            }
        } else {
            print("email 또는 password가 잘못되었습니다.")
        }
    }
    
    //TODO 이것을 해야할지
    func loginTest() {
        ApiService().login(email: email, password: password) { result, data in
            if result == .success {
                guard let data = data else { return }
                do {
                    let decodedResponse = try JSONDecoder().decode(User.self, from: data as! Data)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.loginResult = true
                    }
                    print("success: \(decodedResponse)")
                } catch {
                    DispatchQueue.main.async {
                        self.loginResult = false
                    }
                    print("error")
                }
            } else if result == .failure {
                DispatchQueue.main.async {
                    self.loginResult = false
                }
                print("failure: \(String(describing: data))")
            }
        }
    }
}
