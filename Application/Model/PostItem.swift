//
//  PostItem.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

struct PostItem: Codable, Identifiable {
    var id: Int
    
    var userId: Int
    
    var name: String
    
    var text: String
    
    var status: Int
    
    var profileImage: String?
    
    var timeStamp: String
    
    var replyCount: Int
    
    var likeCount: Int
    
    var attachment: Attachment
    
    enum CodingKeys: String, CodingKey {
        case id, name, text, status, attachment
        case userId = "user_id"
        case profileImage = "profile_img"
        case timeStamp = "created_at"
        case replyCount = "reply_count"
        case likeCount = "like_count"
    }
    
    struct Attachment: Codable {
        var images: [ImageItem]
        
        var video: String?
    }
}
