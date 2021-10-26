//
//  WriteViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/08/28.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class WriteViewModel: ObservableObject {
    @Published var text: String = ""
    
    @Published var sendResult = false
    
    private let groupId: Int
    
    private let repository: WriteRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ repository: WriteRepository, _ groupId: Int) {
        self.repository = repository
        self.groupId = groupId
    }
    
    func actionSend() {
        if !text.isEmpty {
            guard let user = try? PropertyListDecoder().decode(User.self, from: UserDefaults.standard.data(forKey: "user")!) else {
                return
            }
            repository.actionSend(text, user, groupId).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
        } else {
            print("text is empty")
        }
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("success")
            break
        case .failure:
            break
        }
    }
    
    private func onReceive(_ batch: Int) {
        print("Test: \(batch)")
        
        sendResult.toggle()
    }
}
