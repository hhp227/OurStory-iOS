//
//  WriteViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/28.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class CreatePostViewModel: ObservableObject {
    @Published var text: String = ""
    
    @Published var state = State()
    
    @Published var isShowingActionSheet = false
    
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    private static let IMAGE_ITEM_START_POSITION = 1
    
    private let repository: PostRepository
    
    private let apiKey: String
    
    private let groupId: Int
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ repository: PostRepository, _ userDefaultsManager: UserDefaultsManager, _ groupId: Int) {
        self.repository = repository
        self.apiKey = userDefaultsManager.user?.apiKey ?? ""
        self.groupId = groupId
    }
    
    private func insertPost(_ text: String) {
        repository.addPost(apiKey, groupId, text).sink(receiveCompletion: { _ in }) { result in
            switch result.status {
            case .SUCCESS:
                if self.state.items.count > CreatePostViewModel.IMAGE_ITEM_START_POSITION {
                    self.uploadImage(CreatePostViewModel.IMAGE_ITEM_START_POSITION, result.data ?? -1)
                } else {
                    self.state = State(
                        isLoading: false,
                        items: self.state.items,
                        postId: result.data ?? -1,
                        error: self.state.error
                    )
                }
            case .ERROR:
                self.state = State(
                    isLoading: false,
                    items: self.state.items,
                    postId: self.state.postId,
                    error: result.message ?? "An unexpected error occured"
                )
            case .LOADING:
                self.state = State(
                    isLoading: true
                )
            }
        }.store(in: &subscriptions)
    }
    
    private func updatePost(_ text: String) {
        
    }
    
    private func uploadImage(_ position: Int, _ postId: Int) {
        
    }
    
    private func imageUploadProcess(_ position: Int, _ postId: Int) {
        
    }
    
    private func deleteImages(_ postId: Int) {
        
    }
    
    func addItem() {
        <#function body#>
    }
    
    func removeItem() {
        <#function body#>
    }
    
    func actionSend() {
        if !text.isEmpty {
            insertPost(text)
        } else {
            print("text is empty")
        }
    }
    
    struct State {
        var isLoading: Bool = false
        
        var items: [Any] = []
        
        var postId: Int = -1
        
        var error: String = ""
    }
}
