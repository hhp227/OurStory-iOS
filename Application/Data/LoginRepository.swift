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
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
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
        apiService.request(with: URL_LOGIN, method: .post, params: ["email": email, "password": password]) { result, data in
            switch result {
            case .success:
                guard let data = data else { return }
                do {
                    let decodedResponse = try JSONDecoder().decode(User.self, from: data as! Data)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        success(true)
                        UserDefaults.standard.set(try? PropertyListEncoder().encode(decodedResponse), forKey: "user")
                    }
                } catch {
                    DispatchQueue.main.async { success(false) }
                    print("error")
                }
                break
            case .failure:
                DispatchQueue.main.async { success(false) }
                print("failure: \(String(describing: data))")
                break
            }
        }
    }
}
