//
//  RemoteMediatorAccessor.swift
//  Application
//
//  Created by hhp227 on 2023/01/26.
//

import Combine

internal protocol RemoteMediatorConnection {
    associatedtype Key = Any
    associatedtype Value = Any
    
    func requestLoad(_ loadType: LoadType, _ pagingState: PagingState<Key, Value>)
    
    func retryFailed(_ pagingState: PagingState<Key, Value>)
}

internal protocol RemoteMediatorAccessor: RemoteMediatorConnection {
    var passthroughSubject: PassthroughSubject<LoadStates, Never> { get }
    
    func initialize() -> RemoteMediator<Key, Value>.InitializeAction
}
