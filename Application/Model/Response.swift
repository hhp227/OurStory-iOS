//
//  Response.swift
//  Application
//
//  Created by 홍희표 on 2023/03/04.
//

import Foundation

struct BasicApiResponse: Codable {
    var error: Bool
    
    var message: String? = nil
}
