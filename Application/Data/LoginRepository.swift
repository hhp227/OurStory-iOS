//
//  LoginRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/08.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Alamofire

class LoginRepository {
    //TODO Alamofire를 사용할지
    func loginAlamofire(_ email: String, _ password: String, success: @escaping (Bool) -> Void) {
        AF.request(URL_LOGIN, method: .post, parameters: ["email": email, "password": password]).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
                success(true)
                break
            case .failure(_):
                print("fail")
                success(false)
                break
            }
        }
    }
    
    //TODO 이것을 해야할지
    func login(_ email: String, _ password: String, success: @escaping (Bool) -> Void) {
        ApiServiceTemp().request(with: URL_LOGIN, method: "POST", params: ["email": email, "password": password]) { result, data in
            if result == .success {
                guard let data = data else { return }
                do {
                    let decodedResponse = try JSONDecoder().decode(User.self, from: data as! Data)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { success(true) }
                    print("success: \(decodedResponse)")
                } catch {
                    DispatchQueue.main.async { success(false) }
                    print("error")
                }
            } else if result == .failure {
                DispatchQueue.main.async { success(false) }
                print("failure: \(String(describing: data))")
            }
        }
    }
}
