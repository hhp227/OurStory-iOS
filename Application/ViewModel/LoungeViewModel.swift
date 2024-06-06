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
    
    private var apiKey: String = ""
    
    @Published
    var state = State()
    
    private func setPagingData(pagingData: PagingData<PostItem>) {
        self.state.pagingData = pagingData
    }
    
    func togglePostLike(_ post: PostItem) {
    }
    
    init(_ repository: PostRepository, _ userDefaultsManager: UserDefaultsManager) {
        self.repository = repository
        
        userDefaultsManager.userPublisher
            .catch { error in Just(nil) }
            .sink { user in
                self.apiKey = user?.apiKey ?? ""
                self.state.user = user
            }
            .store(in: &state.subscriptions)
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
        
        var user: User? = nil
        
        var message: String = ""
        
        var subscriptions: Set<AnyCancellable> = []
    }
}
