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
            List {
                Text("Hello World nice to meet you")
                ForEach(viewModel.state.replys) { reply in
                    Text("reply \(reply.id)")
                }.onReceive(viewModel.$state) { state in
                    print(state.replys.count)
                }
                
            }.onAppear {
                viewModel.getPost()
                viewModel.getReplys()
            }
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 5) {
                    TextField("Add a Comment", text: $viewModel.message).padding(10)
                    Button(action: viewModel.actionSend) {
                        Text("Send").foregroundColor(.gray).padding(10).overlay(RoundedRectangle(cornerRadius: 2).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1))
                    }
                }.padding(5)
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct PostHeaderView: View {
    @Binding var post: PostItem?
    
    var body: some View {
        Text("Test \(post?.id ?? 5)")
    }
    
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView()
    }
}
