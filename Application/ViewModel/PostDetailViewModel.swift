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
    
    @Published var post: PostItem
    
    @Published var state = State()
    
    func fetchPost(_ postId: Int) {
        let post = PostItem(id: 0, userId: 0, name: "newPost", text: "newPostText", status: 0, timeStamp: .now, replyCount: 0, likeCount: 0, attachment: .init(images: []))
        savedStateHandle.set("post", post)
        state = State(
            reply: self.state.reply,
            isLoading: false,
            items: self.state.items + [post],
            replyId: self.state.replyId,
            isSetResultOK: self.state.isSetResultOK,
            error: self.state.error
        )
        
        updatePost(post)
    }
    
    func updatePost(_ newPost: PostItem) {
        post.id = newPost.id
        post.userId = newPost.userId
        post.name = newPost.name
        post.text = newPost.text
        post.status = newPost.status
        post.profileImage = newPost.profileImage
        post.timeStamp = newPost.timeStamp
        post.replyCount = newPost.replyCount
        post.likeCount = newPost.likeCount
        post.attachment = newPost.attachment
    }
    
    func insertReply(message reply: String) {
        print("insertReply: \(reply)")
    }
    
    func deletePost() {
        
    }
    
    func refreshPosts() {
        state = State()
        
        fetchPost(post.id)
    }
    
    init(
        _ postRepository: PostRepository,
        _ replyRepository: ReplyRepository,
        _ savedStatedHandle: SavedStateHandle,
        _ userDefaultsManager: UserDefaultsManager
    ) {
        self.postRepository = postRepository
        self.replyRepository = replyRepository
        self.savedStateHandle = savedStatedHandle
        print("PostDetailViewModel init")
        
        if let post: PostItem = savedStatedHandle.get(POST_KEY) {
            self.post = post
            self.state.items = [post]
        } else {
            self.post = .EMPTY
        }
    }
    
    struct State {
        var reply: String = ""
        
        var isLoading: Bool = false
        
        var items: [ListItem] = []
        
        var replyId: Int = -1
        
        var isSetResultOK: Bool = false
        
        var error: String = ""
        
        var isShowingActionSheet: Bool = false
    }
}
