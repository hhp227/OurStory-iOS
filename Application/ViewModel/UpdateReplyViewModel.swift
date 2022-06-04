//
//  UpdateReplyViewModel.swift
//  Application
//
//  Created by 홍희표 on 2022/06/04.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation

class UpdateReplyViewModel: ObservableObject {
    @Published var message: String
    
    let reply: ReplyItem
    
    func updateReply() {
        guard !message.isEmpty else {
            print("메시지를 입력하세요")
            return
        }
        print("전송")
        /*replyRepository.setReply(apiKey, state.replys[selectPosition].id, message).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)*/
    }
    
    init(_ replyRepository: ReplyRepository, _ userDefaultsManager: UserDefaultsManager, _ handle: [String: Any]) {
        self.reply = handle["reply"] as? ReplyItem ?? ReplyItem.EMPTY
        self.message = reply.reply
        
        print("updateReplyViewModel init: \(handle)")
    }
}
