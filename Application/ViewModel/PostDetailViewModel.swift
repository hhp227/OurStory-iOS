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
    
    @Published var selectPosition = -1
    
    private static let PAGE_ITEM_COUNT = 15
    
    private var repository: PostDetailRepository
    
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
    
    init(_ postId: Int, _ repository: PostDetailRepository) {
        self.postId = postId
        self.repository = repository
    }
    
    func getPost() {
        repository.getPost(postId).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func removePost() {
        repository.removePost(postId, user).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func addReply() {
        if message.isEmpty {
            print("메시지를 입력해주세요.")
        } else {
            repository.addReply(postId, user, message).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
            message.removeAll()
        }
    }
    
    func getReplys() {
        guard state.canLoadNextPage else { return }
        repository.getReplys(postId, user).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func setReply(_ message: String) {
        if message.isEmpty {
            print("메시지를 입력하세요.")
        } else {
            let replyId = state.replys[selectPosition].id
            
            repository.setReply(replyId, user, message).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
        }
    }
    
    func removeReply(_ replyId: Int) {
        repository.removeReply(replyId, user).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
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
    
    private func onReceive(_ batch: PostItem) {
        self.state.post = batch
    }
    
    private func onReceive(_ batch: [ReplyItem]) {
        self.state.replys += batch
        self.state.canLoadNextPage = batch.count == PostDetailViewModel.PAGE_ITEM_COUNT
    }
    
    private func onReceive(_ batch: ReplyItem) {
        self.state.replys.append(batch)
    }
    
    private func onReceive(_ isRemoved: Bool) {
        if isRemoved {
            self.state.replys.remove(at: selectPosition)
            selectPosition -= 1
        }
    }
    
    private func onReceive(_ batch: String) {
        state.replys[selectPosition].reply = batch
        
        isNavigateReplyModifyView.toggle()
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    struct State {
        var post: PostItem? = nil
        var replys: [ReplyItem] = []
        var canLoadNextPage = true
    }
}
