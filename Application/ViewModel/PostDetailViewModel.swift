//
//  PostDetailViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/09/12.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class PostDetailViewModel: ObservableObject {
    private let postRepository: PostRepository
    
    private let replyRepository: ReplyRepository
    
    private let savedStateHandle: SavedStateHandle
    
    @Binding var post: PostItem
    
    @Published var state = State()
    
    private func fetchPost(_ postId: Int) {
        postRepository.getPost(postId: postId)
            .receive(on: RunLoop.main)
            .sink { result in
                switch result.status {
                case .SUCCESS:
                    if let post = result.data {
                        self.savedStateHandle.set(POST_KEY, post)
                        self.state = State(
                            reply: self.state.reply,
                            isLoading: false,
                            items: self.state.items + [post],
                            replyId: self.state.replyId,
                            isSetResultOK: self.state.isSetResultOK,
                            error: self.state.error
                        )
                        
                        self.updatePost(post)
                    }
                    self.fetchReplys(postId)
                case .ERROR:
                    self.state = State(
                        reply: self.state.reply,
                        isLoading: false,
                        items: self.state.items,
                        replyId: self.state.replyId,
                        isSetResultOK: self.state.isSetResultOK,
                        error: result.message ?? "An unexpected error occured",
                        isShowingActionSheet: self.state.isShowingActionSheet,
                        subscriptions: self.state.subscriptions
                    )
                case .LOADING:
                    self.state = State(
                        reply: self.state.reply,
                        isLoading: true,
                        items: self.state.items,
                        replyId: self.state.replyId,
                        isSetResultOK: self.state.isSetResultOK,
                        error: self.state.error,
                        isShowingActionSheet: self.state.isShowingActionSheet,
                        subscriptions: self.state.subscriptions
                    )
                }
            }
            .store(in: &state.subscriptions)
    }
    
    private func updatePost(_ newPost: PostItem) {
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
    
    private func fetchReplys(_ postId: Int) {
        
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
        
        if let post: Binding<PostItem> = savedStatedHandle.get(POST_KEY) {
            self._post = post
            self.state.items = [self.post]
        } else {
            self._post = Binding(get: { PostItem.EMPTY }, set: { _ in })
        }
    }
    
    deinit {
        self.state.subscriptions.removeAll()
    }
    
    struct State {
        var reply: String = ""
        
        var isLoading: Bool = false
        
        var items: [ListItem] = []
        
        var replyId: Int = -1
        
        var isSetResultOK: Bool = false
        
        var error: String = ""
        
        var isShowingActionSheet: Bool = false
        
        var subscriptions: Set<AnyCancellable> = []
    }
}
