//
//  LoungeRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Alamofire
import Combine

class LoungeRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getPosts<T>(offset: Int, success: @escaping (T) -> Void) {
        apiService.request(with: URL_POSTS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, header: [:], params: [:]) { result, data in
            switch result {
            case .success:
                let jsonObject = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [String: Any]
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
                    success(postItems as! T)
                }
                break
            case .failure:
                break
            }
        }
    }
    
    // TODO 아래 getPosts메소드 이걸로 고치기
    func getPosts(_ offset: Int) -> AnyPublisher<Resource<[PostItem]>, Error> {
        return apiService.request(with: URL_POSTS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, header: [:], params: [:]) { (data, response) -> Resource<[PostItem]> in
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
        }
    }
    
    //TODO https://www.vadimbulavin.com/infinite-list-scroll-swiftui-combine/
    func getPostItems(offset: Int) -> AnyPublisher<[PostItem], Error> {
        return apiService.request(with: URL_POSTS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, header: [:], params: [:]) { (data, response) -> [PostItem] in
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
            return postItems
        }
    }
    
    func actionLike<T>(post: PostItem, user: User, success: @escaping (T) -> Void) {
        apiService.request(with: URL_POST_LIKE.replacingOccurrences(of: "{POST_ID}", with: String(post.id)), method: .get, header: ["Authorization": user.apiKey], params: [:]) { result, data  in
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
