//
//  WriteRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/10/20.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class WriteRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func actionSend(_ text: String, _ user: User, _ groupId: Int) -> AnyPublisher<Int, Error> {
        apiService.request(with: URL_POST, method: .post, header: ["Authorization": user.apiKey], params: ["text": text, "group_id": String(groupId)]) { data, response -> Int in
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return -1
            }
            return !(jsonObject["error"] as? Bool ?? false) ? jsonObject["post_id"] as? Int ?? 0 : 0
        }
    }
}
