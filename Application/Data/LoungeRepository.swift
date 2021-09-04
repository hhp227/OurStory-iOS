//
//  LoungeRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Alamofire

class LoungeRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getPosts<T>(offset: Int, success: @escaping (T) -> Void) {
        apiService.request(with: URL_POSTS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, params: [:]) { result, data in
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
                            timeStamp: post["created_at"] as! String,
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
        /*AF.request(URL_POSTS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, parameters: [:]).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("data: \(String(describing: data))")
                
                success(data)
                break
            case .failure(_):
                print("fail")
                break
            }
        }*/
    }
}
