//
//  ApiService.swift
//  Application
//
//  Created by 홍희표 on 2021/08/07.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class ApiServiceTemp {
    func login(email: String, password: String, completion: @escaping (_ result: ResponseResult, _ data: Any?) -> ()) {
        let param = "email=\(email)&password=\(password)".data(using: .utf8)
        var urlRequest = URLRequest(url: URL(string: URL_LOGIN)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = param
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, failure in
            guard let data = data else { return }
            
            if failure != nil {
                completion(.failure, data)
            } else {
                completion(.success, data)
            }
        }.resume()
    }
    
    /*enum ResponseResult {
        case success
        case failure
    }*/
}

protocol ApiService {
    @discardableResult
    func request(with endpoint: String, completion: @escaping (_ result: ResponseResult, _ data: Any?) -> ())
}

enum ResponseResult {
    case success
    case failure
}
