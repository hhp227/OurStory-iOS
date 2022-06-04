//
//  ListItem.swift
//  Application
//
//  Created by 홍희표 on 2022/06/04.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation

protocol ListItem {}

struct Empty: Codable, Identifiable, ListItem {
    var id: Int
    
    var text: String
}

struct Post: Codable, Identifiable, Equatable, ListItem {
    var id: Int
    
    var userId: Int
    
    var name: String
    
    var text: String
    
    var status: Int
    
    var profileImage: String?
    
    var timeStamp: Date
    
    var replyCount: Int
    
    var likeCount: Int
    
    var attachment: Attachment
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
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

struct Reply: Codable, Identifiable, ListItem {
    var id: Int
    
    var userId: Int
    
    var name: String
    
    var reply: String
    
    var status: Int
    
    var profileImage: String?
    
    var timeStamp: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, reply, status
        case userId = "user_id"
        case profileImage = "profile_img"
        case timeStamp = "created_at"
    }
}

struct ImageTemp: Codable, ListItem {
    var id: Int
    
    var image: String
    
    var tag: String
}

