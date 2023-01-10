//
//  AuthService.swift
//  Application
//
//  Created by 홍희표 on 2022/12/13.
//

import Foundation

class AuthServiceImpl: AuthService {
    // 임시 표본
    /*func request(
        with endpoint: String,
        method: HttpMethod,
        header: [String: String],
        params: [String: String]
    ) async -> (Data, URLResponse) {
        let param = params.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
        var urlRequest = URLRequest(url: URL(string: endpoint)!)
        urlRequest.httpMethod = method.method
        urlRequest.httpBody = param
        urlRequest.timeoutInterval = 10
        
        header.forEach { (k, v) in urlRequest.setValue(v, forHTTPHeaderField: k) }
        return try! await URLSession.shared.data(for: urlRequest)
    }*/
    
    func login(_ email: String, _ password: String) async throws -> User {
        let params = ["email": email, "password": password].map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
        var urlRequest = URLRequest(url: URL(string: URL_LOGIN)!)
        urlRequest.httpMethod = HttpMethod.post.method
        urlRequest.httpBody = params
        urlRequest.timeoutInterval = 10
        let (data, response) = try! await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
            fatalError(response.description)
        }
        guard let user = try? JSONDecoder().decode(User.self, from: data) else {
            throw OurStoryError.jsonDecodeError(message: "json decode error occur")
        }
        return user
    }
}

protocol AuthService {
    func login(_ email: String, _ password: String) async throws -> User
}
