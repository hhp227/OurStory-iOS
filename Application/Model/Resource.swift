//
//  Resource.swift
//  Application
//
//  Created by 홍희표 on 2021/11/08.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

struct Resource<T> {
    let status: Status
    
    let data: T?
    
    let message: String?
}
