//
//  PostPagingSource.swift
//  Application
//
//  Created by 홍희표 on 2023/01/10.
//

import Foundation

class PostPagingSource: PagingSource<Int, PostItem> {
    private let postService: PostService
    
    private let groupId: Int
    
    override func load(params: LoadParams<Int>) async -> LoadResult<Int, PostItem> {
        let offset: Int = params.getKey() ?? 0
        let range = offset..<offset + params.loadSize // TODO
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return LoadResult<Int, PostItem>.Page(
                data: range.map { number in
                    PostItem(
                        id: number,
                        userId: 0,
                        name: "Test \(number)",
                        text: "Test Description",
                        status: 0,
                        timeStamp: .now,
                        replyCount: 0,
                        likeCount: 0,
                        attachment: .init(images: [])
                    )
                },
                prevKey: offset == 0 ? nil : offset - 1,
                nextKey: (range.last ?? 0) + 1
            )
        } catch {
            return LoadResult<Int, PostItem>.Error(error: error)
        }
    }
    
    override func getRefreshKey(state: PagingState<Int, PostItem>) -> Int? {
        return state.anchorPosition
    }
    
    init(postService: PostService, groupId: Int) {
        self.postService = postService
        self.groupId = groupId
    }
}
