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
    
    private let apiKey: String
    
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchPosts(_ groupId: Int = 0, offset: Int) {
        //guard state.canLoadNextPage else { return }
        repository.getPosts(groupId, offset).sink(receiveCompletion: onReceive) { result in
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
        }.store(in: &subscriptions)
    }
    
    // TODO
    func togglePostLike(_ position: Int, _ postItem: PostItem) {
        repository.toggleLike(apiKey, postItem) { p in
            DispatchQueue.main.async {
                self.state.posts[position] = p
            }
        }
    }
    
    // TODO
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }
    
    // TODO
    private func onReceive<T>(_ batch: Resource<T>) {
        if let postItem = batch.data as? [PostItem], batch.status == Status.SUCCESS {
            state.posts += postItem
            state.offset += LoungeViewModel.PAGE_ITEM_COUNT
            state.canLoadNextPage = postItem.count == LoungeViewModel.PAGE_ITEM_COUNT
        }
    }
    
    init(_ repository: PostRepository, _ userDefaultsManager: UserDefaultsManager) {
        self.repository = repository
        self.apiKey = userDefaultsManager.user?.apiKey ?? ""
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
