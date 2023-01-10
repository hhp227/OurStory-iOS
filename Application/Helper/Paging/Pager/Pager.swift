//
//  Pager.swift
//  Application
//
//  Created by 홍희표 on 2022/06/19.
//

import Combine

class Pager<Key: Equatable, Value: Any> {
    let publisher: AnyPublisher<PagingData<Value>, Never>
    
    init(config: PagingConfig, initialKey: Key? = nil, pagingSourceFactory: @escaping () -> PagingSource<Key, Value>) {
        self.publisher = PageFetcher(pagingSourceFactory, initialKey, config).publisher
    }
}
