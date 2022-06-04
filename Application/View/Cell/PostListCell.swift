//
//  PostListCell.swift
//  Application
//
//  Created by 홍희표 on 2022/05/11.
//  Copyright © 2022 홍희표. All rights reserved.
//

import Foundation
import SwiftUI

struct PostListCell: View {
    let post: PostItem
    
    let onLikeClick: () -> Void
    
    let onResult: () -> Void
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 0) {
                NavigationLink(destination: PostDetailView(args: ["post": post], onResult: onResult)) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top) {
                            AsyncImage(url: URL(string: URL_USER_PROFILE_IMAGE + (post.profileImage ?? ""))!).frame(width: 55, height: 55).cornerRadius(45)
                            VStack(alignment: .leading) {
                                Text(post.name).fontWeight(.bold)
                                Text(DateUtil.getPeriodTimeGenerator(post.timeStamp))
                            }.padding(.leading, 7)
                        }.padding([.horizontal], 15)
                        if !post.text.isEmpty {
                            Text(post.text).multilineTextAlignment(.leading).lineLimit(4).fixedSize(horizontal: false, vertical: true).padding(.horizontal, 15).padding(.top, 10).padding(.bottom, 5)
                        }
                        if let imageItem = post.attachment.images.first {
                            AsyncImage(url: URL(string: URL_POST_IMAGE_PATH + imageItem.image)!).padding(.top, 10)
                        }
                    }.padding(.vertical, 20)
                }
                Divider()
                HStack(alignment: .center) {
                    HStack {
                        if post.likeCount > 0 {
                            Image(systemName: "heart.fill")
                        }
                        Button(action: onLikeClick) {
                            Text("Like")
                            if post.likeCount > 0 {
                                Text(String(post.likeCount))
                            }
                        }
                    }.frame(maxWidth: .infinity).padding(10)
                    Divider()
                    NavigationLink(destination: PostDetailView(args: ["post": post], onResult: onResult), label: {
                        HStack {
                            Text("Comment")
                            if post.replyCount > 0 {
                                Text(String(post.replyCount))
                            }
                        }.frame(maxWidth: .infinity).padding(10)
                    })
                }
            }
        }
    }
}

struct PostListCell_Previews: PreviewProvider {
    static var previews: some View {
        PostListCell(post: .init(id: 0, userId: 0, name: "hhp227", text: "Priview Post", status: 0, timeStamp: .now, replyCount: 0, likeCount: 0, attachment: .init(images: [])), onLikeClick: {}, onResult: {})
    }
}
