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
    
    private let repository: LoungeRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ repository: LoungeRepository) {
        self.repository = repository
    }
    
    func getPosts() {
        guard state.canLoadNextPage else { return }
        repository.getPostItems(offset: state.page).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
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
    
    private func onReceive(_ batch: [PostItem]) {
        state.posts += batch
        state.page += LoungeViewModel.PAGE_ITEM_COUNT
        state.canLoadNextPage = batch.count == LoungeViewModel.PAGE_ITEM_COUNT
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    struct State {
        var posts: [PostItem] = []
        var page: Int = 0
        var canLoadNextPage = true
    }
}
