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
    
    private let repository: GroupRepository
    
    private var apiKey: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchGroups(_ offset: Int) {
        guard state.canLoadNextPage else { return }
        repository.getMyGroups(apiKey, offset).sink(receiveCompletion: onReceive) { result in
            switch result.status {
            case .SUCCESS:
                self.state = State(
                    isLoading: false,
                    groups: self.state.groups + (result.data ?? []),
                    offset: self.state.offset + (result.data?.count ?? 0),
                    canLoadNextPage: (result.data ?? []).count == GroupListViewModel.PAGE_ITEM_COUNT,
                    error: self.state.error
                )
            case .ERROR:
                self.state = State(
                    isLoading: false,
                    groups: self.state.groups,
                    offset: self.state.offset,
                    canLoadNextPage: self.state.canLoadNextPage,
                    error: result.message ?? "An unexpected error occured")
            case .LOADING:
                self.state = State(isLoading: true)
            }
        }.store(in: &subscriptions)
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
    
    init(_ repository: GroupRepository, _ userDefaultsManager: UserDefaultsManager) {
        self.repository = repository
        
        userDefaultsManager.userPublisher
            .sink(receiveCompletion: { _ in }) { user in
                self.apiKey = user?.apiKey ?? ""
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        self.subscriptions.removeAll()
    }
    
    private static let PAGE_ITEM_COUNT = 15
    
    struct State {
        var isLoading: Bool = false
        
        var groups: [GroupItem] = Array()
        
        var offset: Int = 0
        
        var canLoadNextPage = true
        
        var error: String = ""
    }
}
