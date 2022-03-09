//
//  CreateGroupViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/10/17.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class CreateGroupViewModel: ObservableObject {
    @Published var inputGroupTitle: String = ""
    
    private let repository: GroupRepository
    
    private let apiKey: String
    
    init(_ repository: GroupRepository, _ userDefaultManager: UserDefaultsManager) {
        self.repository = repository
        self.apiKey = userDefaultManager.user?.apiKey ?? ""
    }
}
