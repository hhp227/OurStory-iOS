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
    
    func getGroups(offset: Int, user: User) -> AnyPublisher<Resource<[GroupItem]>, Error> {
        return apiService.request(with: URL_GROUPS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, header: ["Authorization": user.apiKey], params: [:]) { data, response -> Resource<[GroupItem]> in
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
