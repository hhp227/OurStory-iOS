//
//  PostDetailView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: PostDetailViewModel
    
    let onResult: () -> Void
    
    @Binding var post: PostItem?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                ForEach(Array(viewModel.state.items.enumerated()), id: \.offset) { i, item in
                    switch item {
                    case let post as PostItem:
                        PostDetailCell(post: post)
                    case let reply as ReplyItem:
                        ReplyListCell(reply: reply)
                    default:
                        EmptyView()
                    }
                }
            }
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 5) {
                    TextField("Add a Comment", text: $viewModel.state.reply).padding(10)
                    Button(action: { viewModel.insertReply(message: viewModel.state.reply) }) {
                        Text("Send").padding(10).foregroundColor(viewModel.state.reply.isEmpty ? .gray : .red).overlay(RoundedRectangle(cornerRadius: 2).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1))
                    }
                }.padding(5)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func PostDetailCell(post: PostItem) -> some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: URL_USER_PROFILE_IMAGE + (post.profileImage ?? ""))) { result in
                        switch result {
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "photo")
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }.frame(width: 55, height: 55).cornerRadius(45)
                    VStack(alignment: .leading) {
                        Text(post.name).fontWeight(.bold)
                        Text(DateUtil.getPeriodTimeGenerator(post.timeStamp))
                    }.padding(.leading, 7)
                    Spacer()
                }.padding(.horizontal, 5)
                if !post.text.isEmpty {
                    Button(action: {
                        self.post?.text = "New"
                        self.post?.name = "STar"
                    }) {
                        Text(post.text).fixedSize(horizontal: false, vertical: true).padding([.bottom, .horizontal], 5).padding(.top, 10)
                    }
                }
                if !post.attachment.images.isEmpty {
                    VStack(alignment: .center, spacing: 0) {
                        ForEach(post.attachment.images) { image in
                            AsyncImage(url: URL(string: URL_POST_IMAGE_PATH + image.image)) { result in
                                switch result {
                                case .success(let image):
                                    image.resizable().aspectRatio(contentMode: .fill)
                                case .failure:
                                    Image(systemName: "photo")
                                case .empty:
                                    ProgressView()
                                @unknown default:
                                    EmptyView()
                                }
                            }.padding(.bottom, 15)
                        }
                    }.padding(.top, 10)
                }
            }.padding([.top, .horizontal], 10)
            Spacer(minLength: 10)
            /*NavigationLink(destination: CreatePostView(args: ["post": post], onResult: {}), isActive: $isNavigate, label: {  })*/
        }.actionSheet(isPresented: $viewModel.state.isShowingActionSheet, content: getActionSheet)
    }
    
    private func getActionSheet() -> ActionSheet {
        var buttons = [ActionSheet.Button]()
        
        /*if viewModel.isAuth {
            buttons.append(.default(Text("Edit Post")) {
                isNavigate.toggle()
            })
            buttons.append(.default(Text("Delete Post"), action: viewModel.deletePost))
        }*/
        buttons.append(.cancel())
        return ActionSheet(title: Text("Selection Action"), buttons: buttons)
    }
    
    /*init(post: Binding<PostItem?>, onResult: @escaping () -> Void) {
        self.viewModel = InjectorUtils.instance.providePostDetailViewModel(post.wrappedValue!)
        self.onResult = onResult
    }*/
}

/*struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: .EMPTY, onResult: {})
    }
}*/

