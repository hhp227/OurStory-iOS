//
//  Temp1Repository.swift
//  Application
//
//  Created by 홍희표 on 2021/08/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class Temp1Repository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
        
        print("TEST: \(self)")
    }
    
    private static var instance: Temp1Repository? = nil
    
    static func getInstance(apiService: ApiService) -> Temp1Repository {
        if let instance = self.instance {
            print("getInstance")
            return instance
        } else {
            let temp1Repository = Temp1Repository(apiService)
            self.instance = temp1Repository
            print("newInstance")
            return temp1Repository
        }
    }
}
