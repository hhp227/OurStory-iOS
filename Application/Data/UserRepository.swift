//
//  UserRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/08.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class UserRepository {
    private let apiService: ApiService
    
    private let authService: AuthService
    
    func login(_ email: String, _ password: String) -> AnyPublisher<Resource<User>, Error> {
        return apiService.request(with: URL_LOGIN, method: .post, header: [:], params: ["email": email, "password": password], prepend: Resource<User>.loading(nil)) { data, response in
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                return Resource.error(response.description, nil)
            }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return Resource.error(response.debugDescription, nil)
            }
            if !(jsonObject["error"] as? Bool ?? false) {
                return Resource.success(try JSONDecoder().decode(User.self, from: data))
            } else {
                return Resource.error(jsonObject["message"] as! String, nil)
            }
        }
    }
    /*func login(_ email: String, _ password: String) -> AnyPublisher<Resource<User>, Error> {
        return Future { _ in
            
        }.eraseToAnyPublisher()
    }*/
    
    init(_ apiService: ApiService, _ authService: AuthService) {
        self.apiService = apiService
        self.authService = authService
    }
    
    private static var instance: UserRepository? = nil
    
    static func getInstance(apiService: ApiService, authService: AuthService) -> UserRepository {
        if let instance = self.instance {
            return instance
        } else {
            let userRepository = UserRepository(apiService, authService)
            self.instance = userRepository
            return userRepository
        }
    }
}
