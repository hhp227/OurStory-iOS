//
//  UpdateReplyViewModel.swift
//  Application
//
//  Created by 홍희표 on 2022/06/04.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation
import Combine

class UpdateReplyViewModel: ObservableObject {
    @Published var state = State()
    
    @Published var message: String
    
    private let repository: ReplyRepository
    
    private var apiKey: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    let reply: ReplyItem
    
    func updateReply() {
        guard !message.isEmpty else {
            print("메시지를 입력하세요")
            return
        }
        repository.setReply(apiKey, reply.id, message)
            .sink(receiveCompletion: { _ in }) { result in
                switch result.status {
                case .SUCCESS:
                    self.state = State(
                        isLoading: false,
                        text: result.data,
                        error: self.state.error
                    )
                case .ERROR:
                    self.state = State(
                        isLoading: false,
                        error: result.message ?? "An unexpected error occured"
                    )
                case .LOADING:
                    self.state = State(isLoading: true)
                }
            }
            .store(in: &subscriptions)
    }
    
    init(_ replyRepository: ReplyRepository, _ userDefaultsManager: UserDefaultsManager, _ handle: [String: Any]) {
        self.repository = replyRepository
        self.reply = handle["reply"] as? ReplyItem ?? ReplyItem.EMPTY
        self.message = reply.reply
        
        userDefaultsManager.userPublisher
            .sink(receiveCompletion: { _ in }) { user in
                self.apiKey = user?.apiKey ?? ""
            }
            .store(in: &subscriptions)
    }
    
    struct State {
        var isLoading: Bool = false
        
        var text: String? = nil
        
        var error: String = ""
    }
}
