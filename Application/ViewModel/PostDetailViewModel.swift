//
//  PostDetailViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/09/12.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class PostDetailViewModel: ObservableObject {
    private let postRepository: PostRepository
    
    private let replyRepository: ReplyRepository
    
    private let savedStateHandle: SavedStateHandle
    
    init(
        _ postRepository: PostRepository,
        _ replyRepository: ReplyRepository,
        _ savedStatedHandle: SavedStateHandle
    ) {
        self.postRepository = postRepository
        self.replyRepository = replyRepository
        self.savedStateHandle = savedStatedHandle
        print("PostDetailViewModel init")
        
        if let test: PostItem = savedStatedHandle.get(POST_KEY) {
            print("savedStatedHandle: \(test)")
        }
    }
}
