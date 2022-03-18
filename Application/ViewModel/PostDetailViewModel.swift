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
    @Published var state = State()
    
    @Published var message = ""
    
    @Published var isShowingActionSheet = false
    
    @Published var isNavigateReplyModifyView = false
    
    @Published var deleteResult = false
    
    @Published var selectPosition = -1
    
    private let postRepository: PostRepository
    
    private let replyRepository: ReplyRepository
    
    private let apiKey: String
    
    private var postId: Int
    
    private var subscriptions = Set<AnyCancellable>()
    
    // TODO
    private func fetchReply(_ replyId: Int) {
        
    }
    
    func fetchPost() {
        postRepository.getPost(postId).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func fetchReplys() {
        guard state.canLoadNextPage else { return }
        replyRepository.getReplys(apiKey, postId).sink(receiveCompletion: onReceive) { result in
            switch result.status {
            case .SUCCESS:
                self.state = State(
                    isLoading: false,
                    post: self.state.post,
                    replys: self.state.replys + (result.data ?? []),
                    replyId: self.state.replyId,
                    canLoadNextPage: self.state.canLoadNextPage,
                    error: self.state.error
                )
            case .ERROR:
                self.state = State(
                    isLoading: false,
                    post: self.state.post,
                    replys: self.state.replys,
                    replyId: self.state.replyId,
                    canLoadNextPage: self.state.canLoadNextPage,
                    error: result.message ?? "An unexpected error occured"
                )
            case .LOADING:
                self.state = State(isLoading: true)
            }
        }.store(in: &subscriptions)
    }
    
    func deletePost() {
        postRepository.removePost(apiKey, postId).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func insertReply() {
        if !message.isEmpty {
            replyRepository.addReply(apiKey, postId, message).sink(receiveCompletion: { _ in }) { result in
                switch result.status {
                case .SUCCESS:
                    let replyId = result.data ?? -1
                    self.state = State(
                        isLoading: false,
                        post: self.state.post,
                        replys: self.state.replys,
                        replyId: replyId,
                        canLoadNextPage: self.state.canLoadNextPage,
                        error: self.state.error
                    )
                    
                    self.fetchReply(replyId)
                case .ERROR:
                    self.state = State(
                        isLoading: false,
                        post: self.state.post,
                        replys: self.state.replys,
                        replyId: self.state.replyId,
                        canLoadNextPage: self.state.canLoadNextPage,
                        error: result.message ?? "An unexpected error occured"
                    )
                case .LOADING:
                    self.state = State(isLoading: true)
                }
            }.store(in: &subscriptions)
            message.removeAll()
        } else {
            state = State(
                isLoading: false,
                post: self.state.post,
                replys: self.state.replys,
                replyId: self.state.replyId,
                canLoadNextPage: self.state.canLoadNextPage,
                error: "text is empty"
            )
            print("메시지를 입력해주세요.")
        }
    }
    
    func updateReply() {
        
    }
    
    // TODO 이거는 CreatePostViewModel로 빼야할것
    func setReply(_ message: String) {
        if message.isEmpty {
            print("메시지를 입력하세요.")
        } else {
            replyRepository.setReply(apiKey, state.replys[selectPosition].id, message).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
        }
    }
    
    func deleteReply(_ replyId: Int) {
        replyRepository.removeReply(apiKey, replyId).sink(receiveCompletion: { _ in }) { result in
            switch result.status {
            case .SUCCESS:
                var replys = self.state.replys
                let position = replys.firstIndex { $0.id == replyId }
                
                if result.data == true {
                    replys.remove(at: position ?? 0)
                    if position ?? 0 > 1 {
                        self.state = State(
                            isLoading: false,
                            post: self.state.post,
                            replys: replys,
                            replyId: self.state.replyId,
                            canLoadNextPage: self.state.canLoadNextPage,
                            error: self.state.error
                        )
                    }
                }
            case .ERROR:
                self.state = State(
                    isLoading: false,
                    post: self.state.post,
                    replys: self.state.replys,
                    replyId: self.state.replyId,
                    canLoadNextPage: self.state.canLoadNextPage,
                    error: result.message ?? "An unexpected error occured"
                )
            case .LOADING:
                self.state = State(isLoading: true)
            }
        }.store(in: &subscriptions)
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("success")
            break
        case .failure:
            self.state.canLoadNextPage = false
            break
        }
    }
    
    private func onReceive<T>(_ batch: Resource<T>) {
        if let postItem = batch.data as? PostItem {
            self.state.post = postItem
        } else if let replyItems = batch.data as? [ReplyItem] {
            self.state.replys += replyItems
            self.state.canLoadNextPage = replyItems.count == PostDetailViewModel.PAGE_ITEM_COUNT
        } else if let replyItem = batch.data as? ReplyItem {
            self.state.replys.append(replyItem)
        }
    }
    
    private func onReceive(_ isRemoved: Bool) {
        if isRemoved {
            self.state.replys.remove(at: selectPosition)
            selectPosition -= 1
        }
    }
    
    private func onReceive(_ batch: Resource<String>) {
        switch batch.status {
        case .SUCCESS:
            state.replys[selectPosition].reply = batch.data ?? ""
        case .ERROR:
            state = State(error: batch.message ?? "An unexpected error occured")
        case .LOADING:
            print("loading")
        }
        isNavigateReplyModifyView.toggle()
    }
    
    private func onReceive(_ batch: [String: Any]) {
        print("Test \(batch)")
        // "message": Post Deleted Succesfully, "error": 0
        deleteResult.toggle() // 현재는 버그발생
    }
    
    init(_ postRepository: PostRepository, _ replyRepository: ReplyRepository, _ userDefaultsManager: UserDefaultsManager, _ postId: Int) {
        self.postRepository = postRepository
        self.replyRepository = replyRepository
        self.apiKey = userDefaultsManager.user?.apiKey ?? ""
        self.postId = postId
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    private static let PAGE_ITEM_COUNT = 15
    
    struct State {
        var isLoading: Bool = false
        
        var post: PostItem? = nil
        
        var replys: [ReplyItem] = []
        
        var replyId: Int = -1
        
        var canLoadNextPage = true
        
        var error: String = ""
    }
}
