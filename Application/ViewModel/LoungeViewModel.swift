//
//  LoungeViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Combine
import Foundation

class LoungeViewModel: ObservableObject {
    private let repository: PostRepository
    
    @Published
    var state = State()
    
    private func setPagingData(pagingData: PagingData<PostItem>) {
        self.state.pagingData = pagingData
    }
    
    func refreshPosts() {
    }
    
    func togglePostLike(_ post: PostItem) {
    }
    
    init(_ repository: PostRepository, _ userDefaultsManager: UserDefaultsManager) {
        self.repository = repository
        
        repository.getPosts(groupId: 0)
            .receive(on: RunLoop.main)
            .sink(receiveValue: setPagingData)
            .store(in: &state.subscriptions)
    }
    
    deinit {
        self.state.subscriptions.removeAll()
    }
    
    struct State {
        var isLoading: Bool = false
        
        var pagingData: PagingData<PostItem> = PagingData<PostItem>.empty()
        
        var error: String = ""
        
        var subscriptions: Set<AnyCancellable> = []
    }
}
