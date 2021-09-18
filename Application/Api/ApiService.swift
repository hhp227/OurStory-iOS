//
//  ApiService.swift
//  Application
//
//  Created by 홍희표 on 2021/08/07.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class ApiServiceImpl: ApiService {
    
    func request(with endpoint: String, method: HttpMethod, header: [String: String], params: [String: String], completion: @escaping (_ result: ResponseResult, _ data: Any?) -> ()) {
        let param = params.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
        var urlRequest = URLRequest(url: URL(string: endpoint)!)
        urlRequest.httpMethod = method.method
        urlRequest.httpBody = param
        
        header.forEach { (k, v) in urlRequest.setValue(v, forHTTPHeaderField: k) }
        URLSession.shared.dataTask(with: urlRequest) { data, response, failure in
            guard let data = data else { return }
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                completion(.success, data)
            } else if let error = failure {
                completion(.failure, nil)
            } else {
                completion(.failure, data)
            }
        }.resume()
    }
    
    func test(with endpoint: String, method: HttpMethod, header: [String: String], params: [String: String]) -> AnyPublisher<PostItem, Error> {
        let param = params.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
        var urlRequest = URLRequest(url: URL(string: endpoint)!)
        urlRequest.httpMethod = method.method
        urlRequest.httpBody = param
        
        header.forEach { (k, v) in urlRequest.setValue(v, forHTTPHeaderField: k) }
        return URLSession.shared.dataTaskPublisher(for: urlRequest).tryMap { try JSONDecoder().decode(PostItem.self, from: $0.data) }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
        
    }
}

protocol ApiService {
    @discardableResult
    func request(with endpoint: String, method: HttpMethod, header: [String: String], params: [String: String], completion: @escaping (_ result: ResponseResult, _ data: Any?) -> ())
    
    @discardableResult
    func test(with endpoint: String, method: HttpMethod, header: [String: String], params: [String: String]) -> AnyPublisher<PostItem, Error>
}

enum ResponseResult {
    case success
    case failure
}

enum HttpMethod {
    case get
    case post
    case put
    case delete
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
