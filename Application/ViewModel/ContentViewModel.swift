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
    
    private var subscription = Set<AnyCancellable>()
    
    func test() {
        UserDefaultsManager.instance.test().handleEvents(receiveOutput: {
            if let data = $0 {
                self.user = try? PropertyListDecoder().decode(User.self, from: data)
                print("TEST: \(self.user)")
            }
        }).sink { _ in }.store(in: &subscription)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UserDefaultsManager.instance.storeUser(User(id: 0, name: "test", email: "test", apiKey: "", profileImage: "", createdAt: ""))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            UserDefaultsManager.instance.storeUser(User(id: 1, name: "hong227", email: "hong227@naver.com", apiKey: "", profileImage: "", createdAt: ""))
        }
    }
    
    func appear() {
        UserDefaults.standard.publisher(for: \.musicVolume).handleEvents(receiveOutput: { musicVolume in
            print("Music volume is now: \(musicVolume)")
        })
        .sink { _ in }
        .store(in: &subscription)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let randomInteger = (0...100).randomElement()!
            UserDefaults.standard.musicVolume = Float(randomInteger)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            let randomInteger = (0...100).randomElement()!
            UserDefaults.standard.musicVolume = Float(randomInteger)
        }
    }
}
