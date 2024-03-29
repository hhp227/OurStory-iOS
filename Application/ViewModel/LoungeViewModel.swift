//
//  LoungeViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Combine

class LoungeViewModel: ObservableObject {
    private let repository: PostRepository
    
    lazy var posts: AnyPublisher<PagingData<PostItem>, Never> = repository.getPosts(groupId: 0)
    
    func refreshPosts() {
    }
    
    func togglePostLike(_ post: PostItem) {
    }
    
    init(_ repository: PostRepository, _ userDefaultsManager: UserDefaultsManager) {
        self.repository = repository
    }
}
