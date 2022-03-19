//
//  GroupRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/09/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Combine
import Foundation

class GroupRepository {
    let apiService: ApiService
    
    func getMyGroups(_ apiKey: String, _ offset: Int) -> AnyPublisher<Resource<[GroupItem]>, Error> {
        return apiService.request(with: URL_USER_GROUP.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, header: ["Authorization": apiKey], params: [:]) { data, response -> Resource<[GroupItem]> in
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
    
    func getNotJoinedGroups(_ apiKey: String, _ offset: Int) -> AnyPublisher<Resource<[GroupItem]>, Error> {
        return apiService.request(with: URL_GROUPS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, header: ["Authorization": apiKey], params: [:]) { data, response -> Resource<[GroupItem]> in
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
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    private static var instance: GroupRepository? = nil
    
    static func getInstance(apiService: ApiService) -> GroupRepository {
        if let instance = self.instance {
            return instance
        } else {
            let groupRepository = GroupRepository(apiService)
            self.instance = groupRepository
            return groupRepository
        }
    }
}
