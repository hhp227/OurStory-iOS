//
//  ContentView.swift
//  application
//
//  Created by 홍희표 on 2020/05/17.
//  Copyright © 2020 홍희표. All rights reserved.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var user: User? = nil
    
    private var subscription = Set<AnyCancellable>()
    
    init(_ userDefaultManager: UserDefaultsManager) {
        userDefaultManager.userPublisher
            .replaceError(with: user)
            .assign(to: \.user, on: self)
            .store(in: &subscription)
    }
    
    deinit {
        subscription.removeAll()
    }
}
