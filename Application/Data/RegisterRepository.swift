//
//  RegisterRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/11.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class RegisterRepository {
    /*private let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }*/
    
    func register(_ name: String, _ email: String, _ password: String) {
        ApiServiceImpl().request(with: URL_REGISTER, method: .post, params: ["name": name, "email": email, "password": password]) { result, data in
            if result == .success {
                guard let data = data else { return }
                do {
                    //let decodedResponse = try JSONDecoder().decode(User.self, from: data as! Data)
                    
                    print("success: \(data)")
                } catch {
                    print("error")
                }
            } else if result == .failure {
                print("failure: \(String(describing: data))")
            }
        }
    }
}
