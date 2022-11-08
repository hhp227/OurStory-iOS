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
            .sink(receiveCompletion: { _ in }) { user in self.user = user }
            .store(in: &subscription)
    }
}
