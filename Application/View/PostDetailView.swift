//
//  PostDetailView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    // TODO @StateObject로 교체
    @ObservedObject var viewModel: PostDetailViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let onResult: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                ForEach(Array(viewModel.state.items.enumerated()), id: \.offset) { i, item in
                    switch item {
                    case let post as PostItem:
                        postDetailView(post: post)
                    case let reply as ReplyItem:
                        ReplyListCell(reply: reply).onLongPressGesture {
                            viewModel.selectPosition = i
                        }
                        NavigationLink(destination: UpdateReplyView(args: ["reply": reply]), isActive: $viewModel.isNavigateReplyModifyView, label: { EmptyView() })
                    default:
                        EmptyView()
                    }
                }.onReceive(viewModel.$selectPosition) { position in
                    if position >= 0 {
                        print("position: \(position)")
                        viewModel.isShowingActionSheet.toggle()
                    }
                }
            }.actionSheet(isPresented: $viewModel.isShowingActionSheet) {
                var buttons = [ActionSheet.Button]()
                
                if viewModel.selectPosition > -1 {
                    guard let selectedReply = viewModel.state.items[viewModel.selectPosition] as? ReplyItem else {
                        return ActionSheet(title: Text("Selection Action"), buttons: buttons)
                    }
                    
                    buttons.append(.default(Text("Copy Content")) {
                        UIPasteboard.general.string = selectedReply.reply
                    })
                    if let user = UserDefaultsManager.instance.user, user.id == selectedReply.userId {
                        buttons.append(.default(Text("Edit Comment")) { viewModel.isNavigateReplyModifyView.toggle() })
                        buttons.append(.destructive(Text("Delete Comment")) { viewModel.deleteReply(selectedReply.id) })
                    }
                } else {
                    // TODO
                    // PostDetail에 관한 내용을 써야됨 예를들어 글수정, 글삭제
                    /*if let user = UserDefaultsManager.instance.user, user.id == viewModel.state.post?.userId {
                        print("my post")
                    }*/
                    buttons.append(.default(Text("Edit Post")))
                    buttons.append(.default(Text("Delete Post"), action: viewModel.deletePost))
                }
                buttons.append(.cancel())
                return ActionSheet(title: Text("Selection Action"), buttons: buttons)
            }
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 5) {
                    TextField("Add a Comment", text: $viewModel.message).padding(10)
                    Button(action: viewModel.insertReply) {
                        Text("Send").padding(10).foregroundColor(viewModel.message.isEmpty ? .gray : .red).overlay(RoundedRectangle(cornerRadius: 2).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1))
                    }
                }.padding(5)
            }
        }.navigationBarTitleDisplayMode(.inline).navigationBarItems(trailing: Button {
            viewModel.selectPosition = -1
            
            viewModel.isShowingActionSheet.toggle()
        } label: {
            Image(systemName: "ellipsis")
        }).onReceive(viewModel.$state) { state in
            if state.isSetResultOK {
                onResult()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func postDetailView(post: PostItem) -> some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: URL_USER_PROFILE_IMAGE + (post.profileImage ?? ""))).frame(width: 55, height: 55).cornerRadius(45)
                    VStack(alignment: .leading) {
                        Text(post.name).fontWeight(.bold)
                        Text(DateUtil.getPeriodTimeGenerator(post.timeStamp))
                    }.padding(.leading, 7)
                    Spacer()
                }.padding(.horizontal, 5)
                if !post.text.isEmpty {
                    Text(post.text).fixedSize(horizontal: false, vertical: true).padding([.bottom, .horizontal], 5).padding(.top, 10)
                }
                if !post.attachment.images.isEmpty {
                    VStack(alignment: .center, spacing: 0) {
                        ForEach(post.attachment.images) { image in
                            AsyncImage(url: URL(string: URL_POST_IMAGE_PATH + image.image)).padding(.bottom, 15)
                        }
                    }.padding(.top, 10)
                }
            }.padding([.top, .horizontal], 10)
            Spacer(minLength: 10)
        }
    }
    
    init(args: [String: Any], onResult: @escaping () -> Void) {
        self.viewModel = InjectorUtils.instance.providePostDetailViewModel(params: args)
        self.onResult = onResult
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(args: ["post": PostItem(id: 0, userId: 0, name: "", text: "", status: 0, profileImage: nil, timeStamp: Date.init(), replyCount: 0, likeCount: 0, attachment: PostItem.Attachment.init(images: [], video: ""))], onResult: {})
    }
}
