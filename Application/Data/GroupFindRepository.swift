//
//  GroupFindRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/09/25.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class GroupFindRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getGroups(offset: Int, user: User) -> AnyPublisher<[GroupItem], Error> {
        return apiService.request(with: URL_GROUPS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, header: ["Authorization": user.apiKey], params: [:]) { data, response -> [GroupItem] in
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
