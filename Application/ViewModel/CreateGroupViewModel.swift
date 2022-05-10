//
//  CreateGroupViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/10/17.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class CreateGroupViewModel: ObservableObject {
    @Published var inputGroupTitle: String = ""
    
    private let repository: GroupRepository
    
    private var apiKey: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ repository: GroupRepository, _ userDefaultManager: UserDefaultsManager) {
        self.repository = repository
        
        userDefaultManager.userPublisher
            .sink(receiveCompletion: { _ in }) { user in
                self.apiKey = user?.apiKey ?? ""
            }
            .store(in: &subscriptions)
    }
}
