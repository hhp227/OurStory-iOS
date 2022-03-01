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
    
    private static let PAGE_ITEM_COUNT = 15
    
    private let repository: PostRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ repository: PostRepository) {
        self.repository = repository
    }
    
    func fetchPosts(_ groupId: Int, _ offset: Int) {
        guard state.canLoadNextPage else { return }
        repository.getPosts(groupId, offset).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func actionLike(_ position: Int, _ postItem: PostItem) {
        guard let user = try? PropertyListDecoder().decode(User.self, from: UserDefaults.standard.data(forKey: "user")!) else {
            return
        }
        repository.actionLike(post: postItem, user: user) { p in
            DispatchQueue.main.async {
                self.state.posts[position] = p
            }
        }
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }
    
    private func onReceive<T>(_ batch: Resource<T>) {
        if let postItem = batch.data as? [PostItem], batch.status == Status.SUCCESS {
            state.posts += postItem
            state.offset += LoungeViewModel.PAGE_ITEM_COUNT
            state.canLoadNextPage = postItem.count == LoungeViewModel.PAGE_ITEM_COUNT
        }
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    struct State {
        var isLoading: Bool = false
        
        var posts: [PostItem] = []
        
        var offset: Int = 0
        
        var canLoadNextPage = true
        
        var error: String = ""
    }
}
