//
//  PostService.swift
//  Application
//
//  Created by 홍희표 on 2023/01/10.
//

import Foundation

class PostServiceImpl: PostService {
    func getPosts(_ groupId: Int, _ offset: Int) {
        
    }
}

protocol PostService {
    func getPosts(_ groupId: Int, _ offset: Int)
}
