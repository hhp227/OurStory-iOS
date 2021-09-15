//
//  PostDetailRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/09/15.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class PostDetailRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getPost<T>(_ postId: Int, success: @escaping (T) -> Void) {
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
    }
}
