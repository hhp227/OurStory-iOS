//
//  GroupFindViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/09/25.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class GroupFindViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private static let PAGE_ITEM_COUNT = 15
    
    private let repository: GroupFindRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ repository: GroupFindRepository) {
        self.repository = repository
    }
    
    private func onReceive<T>(_ batch: Resource<T>) {
        if let groupItems = batch.data as? [GroupItem] {
            self.state.groups += groupItems
            self.state.canLoadNextPage = groupItems.count == GroupFindViewModel.PAGE_ITEM_COUNT
        }
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("success")
            break
        case .failure:
            self.state.canLoadNextPage = false
            break
        }
    }
    
    func getGroups() {
        guard state.canLoadNextPage else { return }
        guard let user = try? PropertyListDecoder().decode(User.self, from: UserDefaults.standard.data(forKey: "user")!) else {
            return
        }
        repository.getGroups(offset: 0, user: user).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    deinit {
        self.subscriptions.removeAll()
    }
    
    struct State {
        var groups: [GroupItem] = Array()
        
        var canLoadNextPage = true
    }
}
