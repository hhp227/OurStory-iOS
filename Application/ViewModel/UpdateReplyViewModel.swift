//
//  UpdateReplyViewModel.swift
//  Application
//
//  Created by 홍희표 on 2022/06/04.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Combine
import Foundation

class UpdateReplyViewModel: ObservableObject {
    private let replyRepository: ReplyRepository
    
    private var apiKey: String = ""
    
    private var reply: ReplyItem
    
    @Published var state = State()
    
    func updateReply(_ text: String) {
        if !text.isEmpty {
            replyRepository.setReply(apiKey, reply.id, text) 
                .receive(on: RunLoop.main)
                .sink { result in
                    switch result.status {
                    case .SUCCESS: // Success 로 값이 넘어오지 않는다
                        self.reply.reply = result.data ?? ""
                        self.state = self.state.copy(
                            isLoading: false,
                            isSuccess: text == result.data
                        )
                    case .ERROR:
                        self.state = self.state.copy(
                            isLoading: false,
                            isSuccess: false,
                            error: result.message ?? "An unexpected error occured"
                        )
                    case .LOADING:
                        self.state = self.state.copy(
                            isLoading: true
                        )
                    }
                }
                .store(in: &state.subscriptions)
        } else {
            print("text is empty")
        }
    }
    
    init(
        _ replyRepository: ReplyRepository,
        _ userDefaultsManager: UserDefaultsManager,
        _ savedStateHandle: SavedStateHandle
    ) {
        self.replyRepository = replyRepository
        self.reply = savedStateHandle.get(REPLY_KEY) ?? .EMPTY
        self.state.text = reply.reply
        
        userDefaultsManager.userPublisher
            .catch { _ in
                Just(nil)
            }
            .sink {
                self.apiKey = $0?.apiKey ?? ""
            }
            .store(in: &state.subscriptions)
    }
    
    struct State {
        var text: String = ""
        
        var isLoading: Bool = false
        
        var isSuccess: Bool = false
        
        var error: String = ""
        
        var subscriptions: Set<AnyCancellable> = []
    }
}

extension UpdateReplyViewModel.State {
    func copy(
        text: String? = nil,
        isLoading: Bool? = nil,
        isSuccess: Bool? = nil,
        error: String? = nil
    ) -> UpdateReplyViewModel.State {
        return UpdateReplyViewModel.State(
            text: text ?? self.text,
            isLoading: isLoading ?? self.isLoading,
            isSuccess: isSuccess ?? self.isSuccess,
            error: error ?? self.error
        )
    }
}
