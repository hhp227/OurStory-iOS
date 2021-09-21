//
//  PostDetailViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/09/12.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class PostDetailViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    
    @Published var message = ""
    
    @Published var post: PostItem? = nil
    
    private var repository: PostDetailRepository
    
    private var postId: Int
    
    init(_ postId: Int, _ repository: PostDetailRepository) {
        self.postId = postId
        self.repository = repository
    }
    
    func actionSend() {
        if message.isEmpty {
            
        } else {
            
        }
    }
    
    func getPost() {
        repository.getPost(postId) { post in
            DispatchQueue.main.async {
                self.post = post
            }
        }
    }
    
    enum State {
        case idle
        case loading
        case success
        case error
    }
}
