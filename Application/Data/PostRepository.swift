//
//  PostRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/11.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class PostRepository {
    private let postService: PostService
    
    func getPosts(groupId: Int) -> AnyPublisher<PagingData<PostItem>, Never> {
        return Pager(
            config: PagingConfig(pageSize: PostRepository.NETWORK_PAGE_SIZE, enablePlaceholders: false),
            pagingSourceFactory: { PostPagingSource(postService: self.postService, groupId: groupId) }
        ).publisher
    }
    
    init(_ postService: PostService) {
        self.postService = postService
    }
    
    private static let NETWORK_PAGE_SIZE = 10
    
    private static var instance: PostRepository? = nil
    
    static func getInstance(postService: PostService) -> PostRepository {
        if let instance = self.instance {
            return instance
        } else {
            let postRepository = PostRepository(postService)
            self.instance = postRepository
            return postRepository
        }
    }
}
