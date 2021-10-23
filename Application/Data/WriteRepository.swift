//
//  WriteRepository.swift
//  Application
//
//  Created by 홍희표 on 2021/10/20.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class WriteRepository {
    let apiService: ApiService
    
    init(_ apiService: ApiService) {
        self.apiService = apiService
    }
    
    func actionSend(_ text: String, _ user: User) {
        apiService.request(with: URL_POST, method: .post, header: ["Authorization": user.apiKey], params: ["text": text]) { result, data in
            switch result {
            case .success:
                guard let data = data else { return }
                break
            case .failure:
                break
            }
        }
    }
}
