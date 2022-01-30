//
//  ReplyRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/09/15.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine
import Alamofire

class ReplyRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getReplys(_ postId: Int, _ user: User) -> AnyPublisher<Resource<[ReplyItem]>, Error> {
        return apiService.request(with: URL_REPLYS.replacingOccurrences(of: "{POST_ID}", with: String(postId)), method: .get, header: ["Authorization": user.apiKey], params: [:]) { data, response -> Resource<[ReplyItem]> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                return Resource.success(try JSONDecoder().decode([ReplyItem].self, from: data))
            } else {
                return Resource.error(response.description, nil)
            }
        }
    }
    
    func addReply(_ postId: Int, _ user: User, _ message: String) -> AnyPublisher<Resource<ReplyItem>, Error> {
        return apiService.request(with: URL_REPLYS.replacingOccurrences(of: "{POST_ID}", with: String(postId)), method: .post, header: ["Authorization": user.apiKey], params: ["reply": message]) { data, response -> Resource<ReplyItem> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let replyItem = ReplyItem(id: jsonObject?["reply_id"] as! Int, userId: user.id, name: user.name, reply: jsonObject?["reply"] as! String, status: 0, profileImage: user.profileImage, timeStamp: "")
                return Resource.success(replyItem)
            } else {
                return Resource.error(response.description, nil)
            }
        }
    }
    
    func setReply(_ apiKey: String, _ replyId: Int, _ text: String) -> AnyPublisher<Resource<String>, Error> {
        return apiService.request(with: URL_REPLY.replacingOccurrences(of: "{REPLY_ID}", with: String(replyId)), method: .put, header: ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8", "Authorization": apiKey], params: ["reply": text, "status": "0"]) { data, response -> Resource<String> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                return Resource.success(text)
            } else {
                return Resource.error(response.description, nil)
            }
        }
    }
    
    func removeReply(_ replyId: Int, _ user: User) -> AnyPublisher<Bool, Error> {
        return apiService.request(with: URL_REPLY.replacingOccurrences(of: "{REPLY_ID}", with: String(replyId)), method: .delete, header: ["Authorization": user.apiKey], params: [:]) { data, response -> Bool in
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(jsonObject)
                return !(jsonObject["error"] as? Bool ?? false)
            } else {
                return false
            }
        }
    }
}
