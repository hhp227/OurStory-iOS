//
//  LoungeViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class LoungeViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private let repository: PostRepository
    
    private var apiKey: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchPosts(_ groupId: Int = 0, offset: Int) {
        //guard state.canLoadNextPage else { return }
        repository.getPosts(groupId, offset)
            .sink(receiveCompletion: onReceive) { result in
                switch (result.status) {
                case .SUCCESS:
                    self.state = State(
                        isLoading: false,
                        posts: self.state.posts + (result.data ?? []),
                        offset: self.state.offset + (result.data?.count ?? 0),
                        canLoadNextPage: false
                    )
                case .ERROR:
                    self.state = State(
                        isLoading: false,
                        canLoadNextPage: false,
                        error: result.message ?? "An unexpected error occured"
                    )
                case .LOADING:
                    self.state = State(isLoading: true)
                }
            }
            .store(in: &subscriptions)
    }
    
    func updatePost(_ post: PostItem) {
        var posts = state.posts
        let position = posts.firstIndex { $0.id == post.id } ?? 0
        
        if position > -1 {
            posts[position] = post
            state = State(
                isLoading: false,
                posts: posts
            )
        }
    }
    
    func fetchNextPage() {
        // TODO
    }
    
    func refreshPosts() {
        state = State()
        
        fetchPosts(offset: state.offset)
    }
    
    func togglePostLike(_ post: PostItem) {
        repository.toggleLike(apiKey, post.id)
            .sink(receiveCompletion: onReceive) { result in
                switch (result.status) {
                case .SUCCESS:
                    self.updatePost(
                        PostItem(
                            id: post.id,
                            userId: post.userId,
                            name: post.name,
                            text: post.text,
                            status: post.status,
                            profileImage: post.profileImage,
                            timeStamp: post.timeStamp,
                            replyCount: post.replyCount,
                            likeCount: result.data == "insert" ? post.likeCount + 1 : post.likeCount - 1,
                            attachment: post.attachment
                        )
                    )
                case .ERROR:
                    self.state = State(
                        isLoading: false,
                        error: result.message ?? "An unexpected error occured"
                    )
                case .LOADING:
                    self.state = State(isLoading: true)
                }
            }
            .store(in: &subscriptions)
    }
    
    // TODO
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            do {
                self.state.canLoadNextPage = false
                self.state.error = error.localizedDescription
            }
        }
    }
    
    init(_ repository: PostRepository, _ userDefaultsManager: UserDefaultsManager) {
        self.repository = repository
        
        fetchPosts(offset: state.offset)
        userDefaultsManager.userPublisher
            .sink(receiveCompletion: { _ in }) { user in
                self.apiKey = user?.apiKey ?? ""
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    private static let PAGE_ITEM_COUNT = 15
    
    struct State {
        var isLoading: Bool = false
        
        var posts: [PostItem] = []
        
        var offset: Int = 0
        
        var canLoadNextPage = true
        
        var error: String = ""
    }
}
