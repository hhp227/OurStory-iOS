//
//  LoungeViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class LoungeViewModel: ObservableObject {
    //@Published var posts: [PostItem] = []
    
    private let repository: LoungeRepository
    
    let temp = (1..<50)
    
    @Published var posts: Any? = nil
    
    init(_ repository: LoungeRepository) {
        self.repository = repository
    }
    
    func getPosts() {
        repository.getPosts(offset: 0) { data in
            self.posts = data
        }
    }
}
