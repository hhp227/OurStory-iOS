//
//  InjectorUtils.swift
//  Application
//
//  Created by 홍희표 on 2022/03/18.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation

public final class InjectorUtils {
    func getApiService() -> ApiService {
        return ApiServiceImpl.init()
    }
    
    func getGroupRepository() -> GroupRepository {
        return GroupRepository.getInstance(apiService: getApiService())
    }
    
    func getPostRepository() -> PostRepository {
        return PostRepository.getInstance(apiService: getApiService())
    }
    
    func getReplyRepository() -> ReplyRepository {
        return ReplyRepository.getInstance(apiService: getApiService())
    }
    
    func getUserRepository() -> UserRepository {
        return UserRepository.getInstance(apiService: getApiService())
    }
    
    func getUserDefaultsManager() -> UserDefaultsManager {
        return UserDefaultsManager.instance
    }
    
    func provideGroupListViewModel() -> GroupListViewModel {
        return GroupListViewModel(getGroupRepository(), getUserDefaultsManager())
    }
    
    func provideCreateGroupViewModel() -> CreateGroupViewModel {
        return CreateGroupViewModel(getGroupRepository(), getUserDefaultsManager())
    }
    
    func provideFindGroupViewModel() -> FindGroupViewModel {
        return FindGroupViewModel(getGroupRepository(), getUserDefaultsManager())
    }
    
    func provideJoinRequestGroupViewModel() -> JoinRequestGroupViewModel {
        return JoinRequestGroupViewModel(getGroupRepository())
    }
    
    func provideCreatePostViewModel(params: [String: Any]) -> CreatePostViewModel {
        return CreatePostViewModel(InjectorUtils.instance.getPostRepository(), InjectorUtils.instance.getUserDefaultsManager(), params)
    }
    
    func providePostDetailViewModel() -> PostDetailViewModel {
        return PostDetailViewModel(getPostRepository(), getReplyRepository(), getUserDefaultsManager(), 0)
    }
    
    func provideLoungeViewModel() -> LoungeViewModel {
        return LoungeViewModel(getPostRepository(), getUserDefaultsManager())
    }
    
    static var instance = InjectorUtils.init()
}
