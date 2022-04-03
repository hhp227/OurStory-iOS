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
        // TODO UserDefaultsManager로 이관할것
        UserDefaultsManager.instance.getUser().handleEvents(receiveOutput: {
            if let data = $0 {
                self.user = try? PropertyListDecoder().decode(User.self, from: data)
            }
        })
        .sink { _ in }
        .store(in: &subscription)
    }
    
    // 다른 preference저장을 위해 남겨놓음
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
    
    init() {
        test()
    }
}

extension UserDefaults {
    @objc var musicVolume: Float {
        get {
            return float(forKey: "music_volume")
        }
        set {
            set(newValue, forKey: "music_volume")
        }
    }
}

