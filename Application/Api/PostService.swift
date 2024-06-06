//
//  PostService.swift
//  Application
//
//  Created by 홍희표 on 2023/01/10.
//

import Foundation

class PostServiceImpl: PostService {
    func getPosts(_ groupId: Int, _ offset: Int, _ loadSize: Int) async throws -> BasicApiResponse<[PostItem]> {
        var urlRequest = URLRequest(url: URL(string: URL_POSTS.replacingOccurrences(of: "{GROUP_ID}", with: String(groupId)).replacingOccurrences(of: "{OFFSET}", with: String(offset)).replacingOccurrences(of: "{LOAD_SIZE}", with: String(loadSize)))!)
        urlRequest.httpMethod = HttpMethod.get.method
        urlRequest.timeoutInterval = 10
        let (data, response) = try! await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
            fatalError(response.description)
        }
        guard let basicResponse = try? JSONDecoder().decode(BasicApiResponse<[PostItem]>.self, from: data) else {
            throw OurStoryError.jsonDecodeError(message: "json decode error occur")
        }
        return basicResponse
    }
}

protocol PostService {
    func getPosts(_ groupId: Int, _ offset: Int, _ loadSize: Int) async throws -> BasicApiResponse<[PostItem]>
}
