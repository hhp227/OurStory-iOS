//
//  CreatePostViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/28.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class CreatePostViewModel: ObservableObject {
    private let repository: PostRepository
    
    @Published var state = State()
    
    private func insertPost(_ text: String) {
        
    }
    
    private func updatePost(_ text: String) {
        
    }
    
    private func uploadImage(_ position: Int, _ postId: Int) {
        
    }
    
    private func imageUploadProcess(_ position: Int, _ postId: Int) {
        
    }
    
    private func deleteImages(_ postId: Int) {
        
    }
    
    func addItem(_ item: ImageItem) {
        print("addItem: \(item)")
    }
    
    func removeItem() {
        
    }
    
    func actionSend(_ text: String, items: [ListItem]) {
        print("text: \(text), items: \(items)")
    }
    
    init(
        _ repository: PostRepository,
        _ userDefaultsManager: UserDefaultsManager,
        _ savedStateHandle: SavedStateHandle
    ) {
        self.repository = repository
    }
    
    struct State {
        var text: String = ""
        
        var isLoading: Bool = false
        
        var items: [ListItem] = []
        
        var postId: Int = -1
        
        var error: String = ""
    }
}
