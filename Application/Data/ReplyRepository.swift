//
//  ReplyRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/09/15.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class ReplyRepository {
    let apiService: ApiService
    
    func getReplys(_ apiKey: String, _ postId: Int) -> AnyPublisher<Resource<[ReplyItem]>, Error> {
        return apiService.request(with: URL_REPLYS.replacingOccurrences(of: "{POST_ID}", with: String(postId)), method: .get, header: ["Authorization": apiKey], params: [:]) { data, response -> Resource<[ReplyItem]> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                return Resource.success(try JSONDecoder().decode([ReplyItem].self, from: data))
            } else {
                return Resource.error(response.description, nil)
            }
        }
    }
    
    func addReply(_ apiKey: String, _ postId: Int, _ text: String) -> AnyPublisher<Resource<Int>, Error> {
        return apiService.request(with: URL_REPLYS.replacingOccurrences(of: "{POST_ID}", with: String(postId)), method: .post, header: ["Authorization": apiKey], params: ["reply": text]) { data, response -> Resource<Int> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return Resource.error("JSONException Error", nil)
                }
                if !(jsonObject["error"] as? Bool ?? false) {
                    return Resource.success(jsonObject["reply_id"] as? Int ?? -1)
                } else {
                    return Resource.error(jsonObject["message"] as? String ?? "An unexpected error occured", nil)
                }
            } else {
                return Resource.error(response.description, nil)
            }
        }
    }
    
    func setReply(_ apiKey: String, _ replyId: Int, _ text: String) -> AnyPublisher<Resource<String>, Error> {
        return apiService.request(with: URL_REPLY.replacingOccurrences(of: "{REPLY_ID}", with: String(replyId)), method: .put, header: ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8", "Authorization": apiKey], params: ["reply": text, "status": "0"]) { data, response -> Resource<String> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return Resource.error("JSONException Error", nil)
                }
                if !(jsonObject["error"] as? Bool ?? false) {
                    return Resource.success(text)
                } else {
                    return Resource.error(jsonObject["message"] as? String ?? "An unexpected error occured", nil)
                }
            } else {
                return Resource.error(response.description, nil)
            }
        }
    }
    
    func removeReply(_ apiKey: String, _ replyId: Int) -> AnyPublisher<Resource<Bool>, Error> {
        return apiService.request(with: URL_REPLY.replacingOccurrences(of: "{REPLY_ID}", with: String(replyId)), method: .delete, header: ["Authorization": apiKey], params: [:]) { data, response -> Resource<Bool> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return Resource.error("JSONException Error", nil)
                }
                return Resource.success(!(jsonObject["error"] as? Bool ?? false))
            } else {
                return Resource.error(response.debugDescription, nil)
            }
        }
    }
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    private static var instance: ReplyRepository? = nil
    
    static func getInstance(apiService: ApiService) -> ReplyRepository {
        if let instance = self.instance {
            return instance
        } else {
            let replyRepository = ReplyRepository(apiService)
            self.instance = replyRepository
            return replyRepository
        }
    }
}
