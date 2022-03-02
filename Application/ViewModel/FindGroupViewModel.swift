//
//  GroupFindViewModel.swift
//  Application
//
//  Created by 홍희표 on 2021/09/25.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation
import Combine

class FindGroupViewModel: ObservableObject {
    @Published private(set) var state = State()
    
    private static let PAGE_ITEM_COUNT = 15
    
    private let repository: GroupRepository
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ repository: GroupRepository) {
        self.repository = repository
    }
    
    private func onReceive<T>(_ batch: Resource<T>) {
        switch batch.status {
        case .SUCCESS:
            if let groupItems = batch.data as? [GroupItem] {
                state = State(
                    isLoading: false,
                    offset: state.offset + groupItems.count,
                    groups: state.groups + groupItems,
                    canLoadNextPage: groupItems.count == FindGroupViewModel.PAGE_ITEM_COUNT
                )
            }
        case .ERROR:
            state = State(
                isLoading: false,
                error: batch.message ?? "An unexpected error occured"
            )
        case .LOADING:
            state = State(
                isLoading: true
            )
        }
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            self.state.canLoadNextPage = false
            break
        }
    }
    
    func fetchGroups() {
        guard state.canLoadNextPage else { return }
        guard let user = try? PropertyListDecoder().decode(User.self, from: UserDefaults.standard.data(forKey: "user")!) else {
            return
        }
        repository.getNotJoinedGroups(user.apiKey, 0).sink(receiveCompletion: onReceive, receiveValue: onReceive).store(in: &subscriptions)
    }
    
    deinit {
        self.subscriptions.removeAll()
    }
    
    struct State {
        var isLoading: Bool = false
        
        var offset: Int = 0
        
        var groups: [GroupItem] = Array()
        
        var canLoadNextPage = true
        
        var error: String = ""
    }
}