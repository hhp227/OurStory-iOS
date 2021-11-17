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
    
    func getGroups(_ user: User) -> AnyPublisher<Resource<[GroupItem]>, Error> {
        return apiService.request(with: URL_USER_GROUP, method: .get, header: ["Authorization": user.apiKey], params: [:]) { data, response -> Resource<[GroupItem]> in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    return Resource.error(response.description, nil)
                }
                guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject["groups"] as! [[String: Any]]) else {
                    return Resource.error(response.description, nil)
                }
                return Resource.success(try JSONDecoder().decode([GroupItem].self, from: jsonData))
            } else {
                return Resource.error(response.description, nil)
            }
        }
    }
}
