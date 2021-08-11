//
//  ApiService.swift
//  Application
//
//  Created by 홍희표 on 2021/08/07.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class ApiServiceTemp {
    func request(with endpoint: String, method: String, params: [String: String], completion: @escaping (_ result: ResponseResult, _ data: Any?) -> ()) {
        let param = params.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
        var urlRequest = URLRequest(url: URL(string: endpoint)!)
        urlRequest.httpMethod = method
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
    func request(with endpoint: String, method: String, params: [String: String], completion: @escaping (_ result: ResponseResult, _ data: Any?) -> ())
}

enum ResponseResult {
    case success
    case failure
}
