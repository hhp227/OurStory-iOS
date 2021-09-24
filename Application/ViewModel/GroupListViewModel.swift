//
//  GroupListViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/09/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Combine
import Foundation

class GroupListViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private static let PAGE_ITEM_COUNT = 15
    
    private let repository: GroupListRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ repository: GroupListRepository) {
        self.repository = repository
    }
    
    func getGroups() {
        guard state.canLoadNextPage else { return }
        guard let user = try? PropertyListDecoder().decode(User.self, from: UserDefaults.standard.data(forKey: "user")!) else {
            return
        }
        repository.getGroups(user).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("success")
            break
        case .failure:
            state.canLoadNextPage = false
            break
        }
    }
    
    private func onReceive(_ batch: [GroupItem]) {
        self.state.groups += batch
        self.state.canLoadNextPage = batch.count == GroupListViewModel.PAGE_ITEM_COUNT
    }
    
    deinit {
        self.subscriptions.removeAll()
    }
    
    struct State {
        var groups: [GroupItem] = Array()
        
        var canLoadNextPage = true
    }
}
