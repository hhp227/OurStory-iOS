//
//  PostDetailViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/09/12.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

// TODO
class PostDetailViewModel: ObservableObject {
    @Published var state = State()
    
    @Published var message = ""
    
    private let postRepository: PostRepository
    
    private let replyRepository: ReplyRepository
    
    private var apiKey: String = ""
    
    private var post: PostItem
    
    private var subscriptions = Set<AnyCancellable>()
    
    var isAuth = false
    
    private func fetchPost(_ postId: Int) {
        postRepository.getPost(postId)
            .sink(receiveCompletion: onReceive) { result in
                switch result.status {
                case .SUCCESS:
                    self.post = result.data ?? PostItem.EMPTY
                    self.state = State(
                        isLoading: false,
                        items: self.state.items + [self.post],
                        replyId: self.state.replyId,
                        isSetResultOK: self.state.isSetResultOK,
                        error: self.state.error
                    )
                    
                    self.fetchReplys(postId)
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
    
    func fetchReplys(_ postId: Int) {
        replyRepository.getReplys(apiKey, postId)
            .sink(receiveCompletion: onReceive) { result in
                switch result.status {
                case .SUCCESS:
                    self.state = State(
                        isLoading: false,
                        items: self.state.items + (result.data ?? []),
                        replyId: self.state.replyId,
                        isSetResultOK: self.state.isSetResultOK,
                        error: self.state.error
                    )
                case .ERROR:
                    self.state = State(
                        isLoading: false,
                        items: self.state.items,
                        replyId: self.state.replyId,
                        isSetResultOK: self.state.isSetResultOK,
                        error: result.message ?? "An unexpected error occured"
                    )
                case .LOADING:
                    self.state = State(isLoading: true)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func fetchReply(_ replyId: Int) {
        if replyId >= 0 {
            replyRepository.getReply(apiKey, replyId)
                .sink(receiveCompletion: onReceive) { result in
                    switch result.status {
                    case .SUCCESS:
                        self.state = State(
                            isLoading: false,
                            items: self.state.items + [(result.data ?? ReplyItem.EMPTY)],
                            replyId: -1,
                            isSetResultOK: self.state.isSetResultOK,
                            error: self.state.error
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
    }
    
    func deletePost() {
        postRepository.removePost(apiKey, post.id)
            .sink(receiveCompletion: onReceive) { result in
                switch result.status {
                case .SUCCESS:
                    self.state = State(
                        isLoading: false,
                        items: self.state.items,
                        replyId: self.state.replyId,
                        isSetResultOK: result.data ?? false,
                        error: self.state.error
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
    
    func insertReply() {
        if !message.isEmpty {
            replyRepository.addReply(apiKey, post.id, message)
                .sink(receiveCompletion: onReceive) { result in
                    switch result.status {
                    case .SUCCESS:
                        let replyId = result.data ?? -1
                        self.state = State(
                            isLoading: false,
                            items: self.state.items,
                            replyId: replyId,
                            isSetResultOK: self.state.isSetResultOK,
                            error: self.state.error
                        )
                        
                        self.fetchReply(replyId)
                    case .ERROR:
                        self.state = State(
                            isLoading: false,
                            items: self.state.items,
                            replyId: self.state.replyId,
                            isSetResultOK: self.state.isSetResultOK,
                            error: result.message ?? "An unexpected error occured"
                        )
                    case .LOADING:
                        self.state = State(isLoading: true)
                    }
                }
                .store(in: &subscriptions)
            message.removeAll()
        } else {
            state = State(
                isLoading: false,
                items: self.state.items,
                replyId: self.state.replyId,
                isSetResultOK: self.state.isSetResultOK,
                error: "text is empty"
            )
            print("메시지를 입력해주세요.")
        }
    }
    
    func updateReply(_ reply: ReplyItem) {
        var replys = state.items
        let position = replys.firstIndex { ($0 as? ReplyItem)?.id == reply.id } ?? 0

        if position > -1 {
            replys[position] = reply
            state = State(
                isLoading: false,
                items: replys
            )
        }
    }
    
    func deleteReply(_ replyId: Int) {
        replyRepository.removeReply(apiKey, replyId).sink(receiveCompletion: onReceive) { result in
            switch result.status {
            case .SUCCESS:
                var replys = self.state.items
                let position = replys.firstIndex { ($0 as? ReplyItem)?.id == replyId }
                
                if result.data == true {
                    replys.remove(at: position ?? 0)
                    if position ?? 0 > 1 {
                        self.state = State(
                            isLoading: false,
                            items: replys,
                            replyId: self.state.replyId,
                            isSetResultOK: self.state.isSetResultOK,
                            error: self.state.error
                        )
                    }
                }
            case .ERROR:
                self.state = State(
                    isLoading: false,
                    items: self.state.items,
                    replyId: self.state.replyId,
                    isSetResultOK: self.state.isSetResultOK,
                    error: result.message ?? "An unexpected error occured"
                )
            case .LOADING:
                self.state = State(isLoading: true)
            }
        }.store(in: &subscriptions)
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            self.state.error = error.localizedDescription
        case .finished:
            print("success")
            break
        }
    }
    
    init(_ postRepository: PostRepository, _ replyRepository: ReplyRepository, _ userDefaultsManager: UserDefaultsManager, _ handle: [String: Any]) {
        self.postRepository = postRepository
        self.replyRepository = replyRepository
        guard let post = handle["post"] as? PostItem else {
            self.post = PostItem.EMPTY
            return
        }
        self.post = post
        
        fetchPost(post.id)
        userDefaultsManager.userPublisher
            .sink(receiveCompletion: { _ in }) { user in
                self.apiKey = user?.apiKey ?? ""
                self.isAuth = user?.id == post.userId
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    private static let PAGE_ITEM_COUNT = 15
    
    struct State {
        var isLoading: Bool = false
        
        var items: [ListItem] = []
        
        var replyId: Int = -1
        
        var isSetResultOK = false
        
        var error: String = ""
    }
}
