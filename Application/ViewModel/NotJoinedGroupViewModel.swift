//
//  NotJoinedGroupViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/11/20.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class NotJoinedGroupViewModel: ObservableObject {
    private let repository: NotJoinedGroupRepository
    
    init(_ repository: NotJoinedGroupRepository) {
        self.repository = repository
    }
    
    func getGroups() {
        
    }
}
