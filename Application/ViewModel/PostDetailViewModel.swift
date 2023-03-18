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
    
    private lazy var apiKey: String = user?.apiKey ?? ""
    
    @Binding var post: PostItem
    
    @Published var user: User?
    
    @Published var state = State()
    
    private func fetchPost(_ postId: Int) {
        postRepository.getPost(postId: postId)
            .receive(on: RunLoop.main)
            .sink { result in
                switch result.status {
                case .SUCCESS:
                    if let post = result.data {
                        self.savedStateHandle.set(POST_KEY, post)
                        self.state = self.state.copy(
                            isLoading: false,
                            items: self.state.items + [post]
                        )
                        
                        self.updatePost(post)
                    }
                    self.fetchReplys(postId)
                case .ERROR:
                    self.state = self.state.copy(
                        isLoading: false,
                        error: result.message ?? "An unexpected error occured"
                    )
                case .LOADING:
                    self.state = self.state.copy(
                        isLoading: true
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
        // 데이터 추가가 되지 않음 고민해볼것
        print("fetchReplys before \(state.items.count)")
        self.state = self.state.copy(
            items: self.state.items + (1..<10).map { _ in ReplyItem(id: 1232, userId: 1, name: "Name", reply: "Reply", status: 0, timeStamp: "") }
        )
        print("fetchReplys after \(state.items.count)")
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
        userDefaultsManager.userPublisher
            .catch { error in
                Just(nil)
            }
            .assign(to: &$user)
        fetchReplys(post.id)
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
        
        var subscriptions: Set<AnyCancellable> = []
    }
}

extension PostDetailViewModel.State {
    func copy(
        reply: String? = nil,
        isLoading: Bool? = nil,
        items: [ListItem]? = nil,
        replyId: Int? = nil,
        isSetResultOK: Bool? = nil,
        error: String? = nil,
        subscriptions: Set<AnyCancellable>? = nil
    ) -> PostDetailViewModel.State {
        .init(
            reply: reply ?? self.reply,
            isLoading: isLoading ?? self.isLoading,
            items: items ?? self.items,
            replyId: replyId ?? self.replyId,
            isSetResultOK: isSetResultOK ?? self.isSetResultOK,
            error: error ?? self.error,
            subscriptions: subscriptions ?? self.subscriptions
        )
    }
}
