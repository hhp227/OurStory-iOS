//
//  PostDetailRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/09/15.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class PostDetailRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    /*func getPost<T>(_ postId: Int, success: @escaping (T) -> Void) {
        apiService.request(with: "\(URL_POST)/\(postId)", method: .get, header: [:], params: [:]) { result, data in
            switch result {
            case .success:
                if let post = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [String: Any] {
                    let attach = post["attachment"] as! [String: Any]
                    let images = attach["images"] as! [Any]
                    let postItem = PostItem(
                        id: post["id"] as! Int,
                        userId: post["user_id"] as! Int,
                        name: post["name"] as! String,
                        text: post["text"] as! String,
                        status: post["status"] as! Int,
                        profileImage: post["profile_img"] as? String,
                        timeStamp: DateUtil.parseDate(post["created_at"] as! String),
                        replyCount: post["reply_count"] as! Int,
                        likeCount: post["like_count"] as! Int,
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
                    
                    success(postItem as! T)
                }
                break
            case .failure:
                print("failure: \(data)")
                break
            }
        }
    }*/
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
    
    func addReply(_ postId: Int, _ user: User, _ message: String) {
        apiService.request(with: URL_REPLYS.replacingOccurrences(of: "{POST_ID}", with: String(postId)), method: .post, header: ["Authorization": user.apiKey], params: ["reply": message]) { result, data in
            switch result {
            case .success:
                guard let data = data else { return }
                do {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [String: Any]
                    
                    print(jsonObject)
                    // Optional(["reply": Hi, "message": Reply created successfully, "post_id": 944, "reply_id": 807, "error": 0])
                } catch {
                    print("error")
                }
                break
            case .failure:
                break
            }
        }
    }
    
    func addReply(_ postId: Int, _ user: User, _ message: String) -> AnyPublisher<ReplyItem, Error> {
        return apiService.request(with: URL_REPLYS.replacingOccurrences(of: "{POST_ID}", with: String(postId)), method: .post, header: ["Authorization": user.apiKey], params: ["reply": message]) { data, response -> ReplyItem in
            return ReplyItem(id: 0, userId: 0, name: "", reply: "", status: 0, profileImage: user.profileImage, timeStamp: "")
        }
    }
}
