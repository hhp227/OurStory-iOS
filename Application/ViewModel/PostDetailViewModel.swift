//
//  PostDetailViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/09/12.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class PostDetailViewModel: ObservableObject {
    @Published var message = ""
    
    func actionSend() {
        if message.isEmpty {
            print("action send")
        } else {
            
        }
    }
}
