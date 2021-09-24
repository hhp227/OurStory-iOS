//
//  GroupListRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/09/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Combine
import Foundation

class GroupListRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getGroups(_ user: User) -> AnyPublisher<[GroupItem], Error> {
        return apiService.request(with: URL_USER_GROUP, method: .get, header: ["Authorization": user.apiKey], params: [:]) { data, response -> [GroupItem] in
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return []
            }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject["groups"] as! [[String: Any]]) else {
                return []
            }
            return try JSONDecoder().decode([GroupItem].self, from: jsonData)
        }
    }
}
