//
//  UserRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/08.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Alamofire
import Combine

class UserRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    private func parseUser(_ jsonObject: [String: Any]) -> User {
        return User(
            id: jsonObject["id"] as! Int,
            name: jsonObject["name"] as! String,
            email: jsonObject["email"] as! String,
            apiKey: jsonObject["api_key"] as! String,
            profileImage: jsonObject["profile_img"] as! String,
            createdAt: jsonObject["created_at"] as! String
        )
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
    /*func login(_ email: String, _ password: String, success: @escaping (Bool) -> Void) {
        apiService.request(with: URL_LOGIN, method: .post, header: [:], params: ["email": email, "password": password]) { result, data in
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
    }*/
    
    func login(_ email: String, _ password: String) -> AnyPublisher<Resource<User>, Error> {
        return apiService.request(with: URL_LOGIN, method: .post, header: [:], params: ["email": email, "password": password]) { data, response in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if !(jsonObject["error"] as? Bool ?? false) {
                        return Resource.success(try JSONDecoder().decode(User.self, from: data))
                        //return Resource.success(self.parseUser(jsonObject))
                    } else {
                        return Resource.error(jsonObject["message"] as! String, nil)
                    }
                } else {
                    return Resource.error(response.debugDescription, nil)
                }
            } else {
                return Resource.error(response.description, nil)
            }
        }
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
