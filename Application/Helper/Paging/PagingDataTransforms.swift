//
//  PagingDataTransforms.swift
//  Application
//
//  Created by 홍희표 on 2024/06/09.
//

import Foundation
import Combine

extension PagingData {
    func transform<R: Any>(_ transform: @escaping (PageEvent<T>) -> PageEvent<R>) -> PagingData<R> {
        return PagingData<R>(publisher.map { transform($0) }.eraseToAnyPublisher(), receiver)
    }
    
    func filter(_ predicate: @escaping (T) -> Bool) -> PagingData<T> {
        return transform { $0.filter(predicate) }
    }
}
