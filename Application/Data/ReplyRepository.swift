//
//  ReplyRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/09/15.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class ReplyRepository {
    private let replyService: ReplyService
    
    init(_ replyService: ReplyService) {
        self.replyService = replyService
    }
    
    private static var instance: ReplyRepository? = nil
    
    static func getInstance(replyService: ReplyService) -> ReplyRepository {
        if let instance = self.instance {
            return instance
        } else {
            let replyRepository = ReplyRepository(replyService)
            self.instance = replyRepository
            return replyRepository
        }
    }
}
