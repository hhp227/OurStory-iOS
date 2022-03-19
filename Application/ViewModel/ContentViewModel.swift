//
//  ContentViewModel.swift
//  Application
//
//  Created by 홍희표 on 2022/03/19.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var user: User? = nil
    
    private var sub = Set<AnyCancellable>()
    
    func test() {
        UserDefaultsManager.instance.test().sink {
            if let data = $0 {
                self.user = try? PropertyListDecoder().decode(User.self, from: data)
                print("TEST: \(self.user)")
            }
        }.store(in: &sub)
    }
    
    func temp() {
        UserDefaultsManager.instance.storeUser(User(id: 0, name: "test", email: "test", apiKey: "", profileImage: "", createdAt: ""))
    }
}
