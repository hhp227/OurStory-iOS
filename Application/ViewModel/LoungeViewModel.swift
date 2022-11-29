//
//  LoungeViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class LoungeViewModel: ObservableObject {
    var posts: [ListItem] = (0..<20).map { PostItem(id: $0, userId: 0, name: "Test", text: "Test\($0 + 1)", status: 0, timeStamp: .now, replyCount: 0, likeCount: 0, attachment: .init(images: [])) }
    
    func refreshPosts() {
    }
    
    func togglePostLike(_ post: PostItem) {
    }
}
