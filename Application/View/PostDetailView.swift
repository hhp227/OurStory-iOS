//
//  PostDetailView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/24.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    @ObservedObject var viewModel: PostDetailViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                    }.onLongPressGesture {
                        viewModel.selectPosition = i
                        
                        viewModel.isShowingActionSheet.toggle()
                    }
                }
                NavigationLink(destination: UpdateReplyView().environmentObject(viewModel), isActive: $viewModel.isNavigateReplyModifyView, label: { EmptyView() })
            }.onAppear(perform: viewModel.fetchReplys).actionSheet(isPresented: $viewModel.isShowingActionSheet) {
                var buttons = [ActionSheet.Button]()
                
                if viewModel.selectPosition > -1 {
                    let selectedReply = viewModel.state.replys[viewModel.selectPosition]
                    
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
                    if let user = UserDefaultsManager.instance.user, user.id == viewModel.state.post?.userId {
                        print("my post")
                    }
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
        }.onAppear(perform: viewModel.fetchPost).navigationBarTitleDisplayMode(.inline).navigationBarItems(trailing: Button {
            viewModel.selectPosition = -1
            
            viewModel.isShowingActionSheet.toggle()
        } label: {
            Image(systemName: "ellipsis")
        }).onReceive(viewModel.$deleteResult) {
            if $0 {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    init(args: [String: Any]) {
        self.viewModel = InjectorUtils.instance.providePostDetailViewModel(params: args)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(args: ["post": PostItem(id: 0, userId: 0, name: "", text: "", status: 0, profileImage: nil, timeStamp: Date.init(), replyCount: 0, likeCount: 0, attachment: PostItem.Attachment.init(images: [], video: ""))])
    }
}
