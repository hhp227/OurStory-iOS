//
//  PostDetailRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/09/15.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine
import Alamofire

class PostDetailRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getPost(_ postId: Int) -> AnyPublisher<PostItem, Error> {
        return apiService.request(with: "\(URL_POST)/\(postId)", method: .get, header: [:], params: [:]) { (data, response) -> PostItem in
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let attach = jsonObject?["attachment"] as! [String: Any]
            let images = attach["images"] as! [Any]
            let postItem = PostItem(
                id: jsonObject?["id"] as! Int,
                userId: jsonObject?["user_id"] as! Int,
                name: jsonObject?["name"] as! String,
                text: jsonObject?["text"] as! String,
                status: jsonObject?["status"] as! Int,
                profileImage: jsonObject?["profile_img"] as? String,
                timeStamp: DateUtil.parseDate(jsonObject?["created_at"] as! String),
                replyCount: jsonObject?["reply_count"] as! Int,
                likeCount: jsonObject?["like_count"] as! Int,
                attachment: PostItem.Attachment(
                    images: images.map { jsonObj -> ImageItem in
                        if let image = jsonObj as? [String: Any] {
                            return ImageItem(id: image["id"] as! Int, image: image["image"] as! String, tag: image["tag"] as! String)
                        } else {
                            return ImageItem(id: 0, image: "", tag: "")
                        }
                    },
                    video: String(describing: attach["video"] as Any))
            )
            return postItem
        }
    }
    
    func getReplys(_ postId: Int, _ user: User) -> AnyPublisher<[ReplyItem], Error> {
        return apiService.request(with: URL_REPLYS.replacingOccurrences(of: "{POST_ID}", with: String(postId)), method: .get, header: ["Authorization": user.apiKey], params: [:]) { data, response -> [ReplyItem] in try JSONDecoder().decode([ReplyItem].self, from: data) }
    }
    
    func addReply(_ postId: Int, _ user: User, _ message: String) -> AnyPublisher<ReplyItem, Error> {
        return apiService.request(with: URL_REPLYS.replacingOccurrences(of: "{POST_ID}", with: String(postId)), method: .post, header: ["Authorization": user.apiKey], params: ["reply": message]) { data, response -> ReplyItem in
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return ReplyItem(id: jsonObject?["reply_id"] as! Int, userId: user.id, name: user.name, reply: jsonObject?["reply"] as! String, status: 0, profileImage: user.profileImage, timeStamp: "")
        }
    }
    
    func setReply(_ replyId: Int, _ user: User, _ message: String) -> AnyPublisher<(Int, String), Error> {
        //print("message: \(message), user: \(user), replyId: \(replyId)")
        return apiService.request(with: URL_REPLY.replacingOccurrences(of: "{REPLY_ID}", with: String(replyId)), method: .put, header: ["Authorization": user.apiKey], params: ["reply": message, "status": "0"]) { data, response -> (Int, String) in
            let jsonObject = try? JSONSerialization.jsonObject(with: data , options: [])
             print("message: \(message)")
            print(jsonObject)
            /*
             Optional({
                 error = 0;
                 message = "Reply updated successfully";
             })
             let jsonObject = try? JSONSerialization.jsonObject(with: data as! Data, options: [])
             
             */
            return (replyId, message)
        }
    }
    
    func setReplyAF(_ replyId: Int, _ user: User, _ message: String) {
        AF.request(URL_REPLY.replacingOccurrences(of: "{REPLY_ID}", with: String(replyId)), method: .put, parameters: ["reply": message, "status": "0"], headers: ["Authorization": user.apiKey]).responseJSON { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    break
                case .failure(_):
                    print("fail")
                    break
                }
        }
    }
    
    func removeReply(_ replyId: Int, _ user: User) -> AnyPublisher<Bool, Error> {
        return apiService.request(with: URL_REPLY.replacingOccurrences(of: "{REPLY_ID}", with: String(replyId)), method: .delete, header: ["Authorization": user.apiKey], params: [:]) { data, response -> Bool in
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return !(jsonObject["error"] as? Bool ?? false)
            } else {
                return false
            }
        }
    }
}
