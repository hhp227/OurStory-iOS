//
//  UpdateReplyViewModel.swift
//  Application
//
//  Created by 홍희표 on 2022/06/04.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation

class UpdateReplyViewModel: ObservableObject {
    @Published var state = State()
    
    func updateReply() {
        
    }
    
    struct State {
        var text: String = ""
    }
}
