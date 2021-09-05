//
//  RegisterRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/11.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class RegisterRepository {
    private let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func register(_ name: String, _ email: String, _ password: String, success: @escaping (Bool) -> Void) {
        apiService.request(with: URL_REGISTER, method: .post, header: [:], params: ["name": name, "email": email, "password": password]) { result, data in
            switch result {
            case .success:
                guard let data = data else { return }
                do {
                    success(true)
                } catch {
                    success(false)
                }
                break
            case .failure:
                success(false)
                break
            }
        }
    }
}
