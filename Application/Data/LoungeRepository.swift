//
//  LoungeRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Alamofire

class LoungeRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getPosts(offset: Int, success: @escaping (Any) -> Void) {
        apiService.request(with: URL_POSTS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, params: [:]) { result, data in
            switch result {
            case .success:
                print("Test: \(result), \(data)")
                print("data: \(String(describing: data))")
                let jsonObject = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [String: Any]
                
                if let posts = jsonObject?["posts"] as? [Any] {
                    posts.forEach { object -> Void in
                        guard let post = object as? [String: Any] else { return }
                        let id = post["id"] as! Int
                        print(id)
                    }
                }
                break
            case .failure:
                break
            }
        }
        /*AF.request(URL_POSTS.replacingOccurrences(of: "{OFFSET}", with: String(offset)), method: .get, parameters: [:]).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("data: \(String(describing: data))")
                
                success(data)
                break
            case .failure(_):
                print("fail")
                break
            }
        }*/
    }
}
