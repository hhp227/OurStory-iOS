//
//  InjectorUtils.swift
//  Application
//
//  Created by 홍희표 on 2022/03/18.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation

class InjectorUtils {
    private func getApiService() -> ApiService {
        return ApiServiceImpl.init()
    }
    
    func getUserDefaultsManager() -> UserDefaultsManager {
        return UserDefaultsManager.instance
    }
    
    private func getUserRepository() -> UserRepository {
        return UserRepository.getInstance(apiService: getApiService())
    }
    
    func provideLoginViewModel() -> LoginViewModel {
        return LoginViewModel(getUserRepository(), getUserDefaultsManager())
    }
    
    func provideRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(getUserRepository())
    }
    
    func provideContentViewModel() -> ContentViewModel {
        return ContentViewModel(getUserDefaultsManager())
    }
    
    func provideDrawerViewModel() -> DrawerViewModel {
        return DrawerViewModel(getUserDefaultsManager())
    }
    
    func provideLoungeViewModel() -> LoungeViewModel {
        return LoungeViewModel()
    }
    
    func provideGroupListViewModel() -> GroupListViewModel {
        return GroupListViewModel()
    }
    
    func provideFindGroupViewModel() -> FindGroupViewModel {
        return FindGroupViewModel()
    }
    
    func provideJoinRequestGroupViewModel() -> JoinRequestGroupViewModel {
        return JoinRequestGroupViewModel()
    }
    
    func provideCreateGroupViewModel() -> CreateGroupViewModel {
        return CreateGroupViewModel()
    }
    
    func provideFriendViewModel() -> FriendViewModel {
        return FriendViewModel()
    }
    
    func provideChatListViewModel() -> ChatListViewModel {
        return ChatListViewModel()
    }
    
    static var instance = InjectorUtils.init()
}
