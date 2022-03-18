//
//  PostRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/11.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class PostRepository {
    private let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
        
        print("Test: \(self)")
    }
    
    //TODO https://www.vadimbulavin.com/infinite-list-scroll-swiftui-combine/
    func getPosts(_ groupId: Int, _ offset: Int) -> AnyPublisher<Resource<[PostItem]>, Error> {
        return apiService.request(with: URL_POSTS.replacingOccurrences(of: "{GROUP_ID}", with: String(groupId)).replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, header: [:], params: [:]) { (data, response) -> Resource<[PostItem]> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                var postItems = [PostItem]()
                
                if let posts = jsonObject?["posts"] as? [Any] {
                    posts.forEach { object -> Void in
                        guard let post = object as? [String: Any] else { return }
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
                        
                        postItems.append(postItem)
                    }
                }
                return Resource.success(postItems)
            } else {
                return Resource.error(response.description, nil)
            }
        }
    }
    
    func getPost(_ postId: Int) -> AnyPublisher<Resource<PostItem>, Error> {
        return apiService.request(with: "\(URL_POST)/\(postId)", method: .get, header: [:], params: [:]) { (data, response) -> Resource<PostItem> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
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
                return Resource.success(postItem)
            } else {
                return Resource.error(response.description, nil)
            }
        }
    }
    
    func addPost(_ apiKey: String, _ groupId: Int, _ text: String) -> AnyPublisher<Resource<Int>, Error> {
        apiService.request(with: URL_POST, method: .post, header: ["Authorization": apiKey], params: ["text": text, "group_id": String(groupId)]) { data, response -> Resource<Int> in
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return Resource.error("JSONException Error", nil)
            }
            if !(jsonObject["error"] as? Bool ?? false) {
                let postId = jsonObject["post_id"] as? Int ?? 0
                
                return Resource.success(postId)
            } else {
                return Resource.error(jsonObject["message"] as? String ?? "An unexpected error occured", nil)
            }
        }
    }
    
    // TODO
    func removePost(_ apiKey: String, _ postId: Int) -> AnyPublisher<[String: Any], Error> {
        return apiService.request(with: "\(URL_POST)/\(postId)", method: .delete, header: ["Authorization": apiKey], params: [:]) { (data, response) -> [String: Any] in
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return jsonObject!
        }
    }
    
    // TODO
    func toggleLike<T>(_ apiKey: String, _ post: PostItem, success: @escaping (T) -> Void) {
        apiService.request(with: URL_POST_LIKE.replacingOccurrences(of: "{POST_ID}", with: String(post.id)), method: .get, header: ["Authorization": apiKey], params: [:]) { result, data  in
            switch result {
            case .success:
                if let jsonObject = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [String: Any] {
                    if let error = jsonObject["error"], error as! Int == 0 {
                        var mutablePost = post
                        let result = jsonObject["result"] as! String
                        mutablePost.likeCount = result == "insert" ? post.likeCount + 1 : post.likeCount - 1
                        
                        success(mutablePost as! T)
                    }
                }
                break
            case .failure:
                print("failure")
                break
            }
        }
    }
}
