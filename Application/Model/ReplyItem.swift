//
//  ReplyItem.swift
//  Application
//
//  Created by 홍희표 on 2021/09/23.
//  Copyright © 2021 홍희표. All rights reserved.
//

struct ReplyItem: Codable, Identifiable {
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
