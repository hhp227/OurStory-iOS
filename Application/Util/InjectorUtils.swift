//
//  InjectorUtils.swift
//  Application
//
//  Created by 홍희표 on 2022/03/18.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation

class InjectorUtils {
    private func getAuthService() -> AuthService {
        return AuthServiceImpl()
    }
    
    private func getpostService() -> PostService {
        return PostServiceImpl.init()
    }
    
    private func getApiService() -> ApiService {
        return ApiServiceImpl.init()
    }
    
    func getUserDefaultsManager() -> UserDefaultsManager {
        return UserDefaultsManager.instance
    }
    
    private func getPostRepository() -> PostRepository {
        return PostRepository.getInstance(postService: getpostService())
    }
    
    private func getUserRepository() -> UserRepository {
        return UserRepository.getInstance(authService: getAuthService())
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
        return LoungeViewModel(getPostRepository(), getUserDefaultsManager())
    }
    
    func provideCreatePostViewModel() -> CreatePostViewModel {
        return CreatePostViewModel()
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
    
    func providePostDetailViewModel() -> PostDetailViewModel {
        return PostDetailViewModel()
    }
    
    static var instance = InjectorUtils.init()
}
