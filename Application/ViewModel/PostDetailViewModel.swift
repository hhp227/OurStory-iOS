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
    
    private static let PAGE_ITEM_COUNT = 15
    
    private let postRepository: PostRepository
    
    private let replyRepository: ReplyRepository
    
    private var postId: Int
    
    private var subscriptions = Set<AnyCancellable>()
    
    var user: User {
        get {
            guard let user = try? PropertyListDecoder().decode(User.self, from: UserDefaults.standard.data(forKey: "user")!) else {
                fatalError()
            }
            return user
        }
    }
    
    init(_ postId: Int, _ postRepository: PostRepository, _ replyRepository: ReplyRepository) {
        self.postId = postId
        self.postRepository = postRepository
        self.replyRepository = replyRepository
    }
    
    func getPost() {
        postRepository.getPost(postId).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func removePost() {
        postRepository.removePost(postId, user).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func addReply() {
        if message.isEmpty {
            print("메시지를 입력해주세요.")
        } else {
            replyRepository.addReply(postId, user, message).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
            message.removeAll()
        }
    }
    
    func getReplys() {
        guard state.canLoadNextPage else { return }
        replyRepository.getReplys(postId, user).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func setReply(_ message: String) {
        if message.isEmpty {
            print("메시지를 입력하세요.")
        } else {
            replyRepository.setReply(user.apiKey, state.replys[selectPosition].id, message).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
        }
    }
    
    func removeReply(_ replyId: Int) {
        replyRepository.removeReply(replyId, user).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
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
    
    deinit {
        subscriptions.removeAll()
    }
    
    struct State {
        var post: PostItem? = nil
        var replys: [ReplyItem] = []
        var canLoadNextPage = true
        var error: String = ""
    }
}
