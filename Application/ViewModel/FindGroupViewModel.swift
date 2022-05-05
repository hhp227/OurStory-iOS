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
    
    // TODO
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            self.state.canLoadNextPage = false
            break
        }
    }
    
    func fetchGroups(_ offset: Int) {
        guard state.canLoadNextPage else { return }
        repository.getNotJoinedGroups(apiKey, offset).sink(receiveCompletion: onReceive) { result in
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
        }.store(in: &subscriptions)
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
