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
            print("Test: \(result), \(data)")
            print("data: \(String(describing: data))")
            let jsonObject = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [String: Any]
            
            if let posts = jsonObject?["posts"] {
                
                print("Test: \(posts)")
            }
            
            //print("TEST: \(array)")
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
