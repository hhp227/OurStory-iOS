//
//  PostListCell.swift
//  Application
//
//  Created by 홍희표 on 2022/05/11.
//  Copyright © 2022 홍희표. All rights reserved.
//

import SwiftUI

struct PostListCell: View {
    let post: PostItem
    
    let onLikeClick: () -> Void
    
    let onResult: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, PostListCell!")
        }
        .padding()
    }
}

struct PostListCell_Previews: PreviewProvider {
    static var previews: some View {
        PostListCell(post: PostItem.EMPTY, onLikeClick: {}, onResult: {})
    }
}
