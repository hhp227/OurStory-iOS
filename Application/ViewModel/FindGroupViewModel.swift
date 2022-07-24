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
    
    private let repository: GroupRepository
    
    private var apiKey: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchGroups(_ offset: Int) {
        guard state.canLoadNextPage else { return }
        repository.getNotJoinedGroups(apiKey, offset)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    do {
                        self.state.canLoadNextPage = false
                        self.state.error = error.localizedDescription
                    }
                case .finished:
                    break
                }
            }) { result in
                switch result.status {
                case .SUCCESS:
                    self.state = State(
                        isLoading: false,
                        groups: self.state.groups + (result.data ?? []),
                        offset: self.state.offset + (result.data ?? []).count,
                        canLoadNextPage: (result.data ?? []).count == FindGroupViewModel.PAGE_ITEM_COUNT
                    )
                case .ERROR:
                    self.state = State(
                        isLoading: false,
                        canLoadNextPage: false,
                        error: result.message ?? "An unexpected error occured"
                    )
                case .LOADING:
                    self.state = State(
                        isLoading: true,
                        canLoadNextPage: false
                    )
                }
            }
            .store(in: &subscriptions)
    }
    
    func refreshGroups() {
        
    }
    
    func fetchNextPage() {
        if state.error.isEmpty {
            state = State(canLoadNextPage: true)
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
