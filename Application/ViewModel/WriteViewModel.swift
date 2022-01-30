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

class WriteViewModel: ObservableObject {
    @Published var text: String = ""
    
    @Published var sendResult = false
    
    @Published var isShowingActionSheet = false
    
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    private let groupId: Int
    
    private let repository: PostRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ repository: PostRepository, _ groupId: Int) {
        self.repository = repository
        self.groupId = groupId
    }
    
    func actionSend() {
        if !text.isEmpty {
            guard let user = try? PropertyListDecoder().decode(User.self, from: UserDefaults.standard.data(forKey: "user")!) else {
                return
            }
            repository.addPost(text, user, groupId).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
        } else {
            print("text is empty")
        }
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("success")
            break
        case .failure:
            break
        }
    }
    
    private func onReceive(_ batch: Int) {
        print("Test: \(batch)")
        
        sendResult.toggle()
    }
}
