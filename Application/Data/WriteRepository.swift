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
}
