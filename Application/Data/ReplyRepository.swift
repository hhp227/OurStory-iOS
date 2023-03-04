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
    
    func setReply(_ apiKey: String, _ replyId: Int, _ text: String) -> Publishers.Catch<AnyPublisher<Resource<String>, Error>, Just<Resource<String>>> {
        return Future { promise in
            Task {
                do {
                    let response = try await self.replyService.setReply(apiKey, 1232, text, "0") // replyId 1232를 변경해야한다
                    
                    promise(.success(Resource.success(response)))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .prepend(Resource.loading(nil))
        .eraseToAnyPublisher()
        .catch { error in
            Just(Resource.error(error.localizedDescription, nil))
        }
    }
    
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
