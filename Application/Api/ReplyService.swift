//
//  ReplyService.swift
//  Application
//
//  Created by 홍희표 on 2023/01/23.
//

import Foundation

class ReplyServiceImpl: ReplyService {
    func getReplys(_ postId: Int) {
        
    }
    
    func setReply(_ apiKey: String, _ replyId: Int, _ reply: String, _ status: String = "0") async throws -> String? {
        let params = ["reply": reply, "status": status].map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
        let header = ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8", "Authorization": apiKey]
        var urlRequest = URLRequest(url: URL(string: URL_REPLY.replacingOccurrences(of: "{REPLY_ID}", with: String(replyId)))!)
        urlRequest.httpMethod = HttpMethod.put.method
        urlRequest.httpBody = params
        urlRequest.timeoutInterval = 10
        
        header.forEach { (k, v) in urlRequest.setValue(v, forHTTPHeaderField: k) }
        let (data, response) = try! await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
            fatalError(response.description)
        }
        guard let basicResponse = try? JSONDecoder().decode(BasicApiResponse.self, from: data) else {
            throw OurStoryError.jsonDecodeError(message: "json decode error occur")
        }
        return reply
    }
    
    /*func login(_ email: String, _ password: String) async throws -> User {
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
    }*/
    
    
}

protocol ReplyService {
    func getReplys(_ postId: Int)
    
    func setReply(_ apiKey: String, _ replyId: Int, _ reply: String, _ status: String) async throws -> String?
}
