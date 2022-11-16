//
//  GroupListViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/09/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class GroupListViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    func fetchGroups(_ offset: Int) {
    }
    
    struct State {
        var isLoading: Bool = false
        
        var groups: [GroupItem] = Array()
        
        var offset: Int = 0
        
        var canLoadNextPage = true
        
        var error: String = ""
    }
}
