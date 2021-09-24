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
    
    private var repository: PostDetailRepository
    
    private var postId: Int
    
    private var subscriptions = Set<AnyCancellable>()
    
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
        repository.getPost(postId).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func getReplys() {
        guard let user = try? PropertyListDecoder().decode(User.self, from: UserDefaults.standard.data(forKey: "user")!) else {
            return
        }
        repository.getReplys(postId, user).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("success")
            break
        case .failure:
            print("failure")
            break
        }
    }
    
    private func onReceive(_ batch: PostItem) {
        self.state.post = batch
    }
    
    private func onReceive(_ batch: [ReplyItem]) {
        self.state.replys += batch
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    struct State {
        var post: PostItem? = nil
        var replys: [ReplyItem] = []
    }
}
