//
//  PostDetailView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var viewModel: PostDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                if let post = viewModel.state.post {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top) {
                            AsyncImage(url: URL(string: URL_USER_PROFILE_IMAGE + (post.profileImage ?? ""))!).frame(width: 57, height: 57).cornerRadius(45)
                            VStack(alignment: .leading) {
                                Text(post.name).fontWeight(.bold)
                                Text(DateUtil.getPeriodTimeGenerator(post.timeStamp))
                            }.padding([.leading, .trailing], 8)
                            Spacer()
                        }.padding([.top, .leading, .trailing])
                        if !post.text.isEmpty {
                            Text(post.text).lineLimit(4).fixedSize(horizontal: false, vertical: true).padding([.top, .leading, .trailing]).padding(.bottom, 5)
                        }
                        if let imageItem = post.attachment.images.first {
                            AsyncImage(url: URL(string: URL_POST_IMAGE_PATH + imageItem.image)!).padding(.top, 10)
                        }
                        Spacer(minLength: 10)
                    }.padding([.top, .bottom], 8)
                }
                ForEach(Array(viewModel.state.replys.enumerated()), id: \.offset) { i, reply in
                    VStack(alignment: .trailing) {
                        HStack {
                            AsyncImage(url: URL(string: URL_POST_IMAGE_PATH + (reply.profileImage ?? ""))!).frame(width: 57, height: 57).cornerRadius(45)
                            VStack(alignment: .leading) {
                                Text(reply.name).fontWeight(.bold)
                                Text(reply.reply)
                            }
                            Spacer()
                        }.padding(.horizontal, 5)
                        Text(DateUtil.getPeriodTimeGenerator(DateUtil.parseDate(reply.timeStamp))).font(.system(size: 14))
                    }
                }
            }.onAppear(perform: viewModel.getReplys)
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 5) {
                    TextField("Add a Comment", text: $viewModel.message).padding(10)
                    Button(action: viewModel.actionSend) {
                        Text("Send").foregroundColor(.gray).padding(10).overlay(RoundedRectangle(cornerRadius: 2).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1))
                    }
                }.padding(5)
            }
        }.onAppear(perform: viewModel.getPost).navigationBarTitleDisplayMode(.inline)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView()
    }
}
