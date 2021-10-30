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
                    }.onLongPressGesture {
                        viewModel.selectPostion = i
                        
                        viewModel.isShowingActionSheet.toggle()
                    }
                }
                NavigationLink(destination: ReplyModifyView().environmentObject(viewModel), isActive: $viewModel.isNavigateReplyModifyView, label: { EmptyView() })
            }.onAppear(perform: viewModel.getReplys).actionSheet(isPresented: $viewModel.isShowingActionSheet) {
                let selectedReply = viewModel.state.replys[viewModel.selectPostion]
                var buttons = [ActionSheet.Button]()
                
                buttons.append(.default(Text("Copy Content")) {
                    UIPasteboard.general.string = selectedReply.reply
                })
                if viewModel.user.id == selectedReply.userId {
                    buttons.append(.default(Text("Edit Comment")) { viewModel.isNavigateReplyModifyView.toggle() })
                    buttons.append(.destructive(Text("Delete Comment")) { viewModel.removeReply(selectedReply.id) })
                }
                buttons.append(.cancel())
                return ActionSheet(title: Text("Selection Action"), buttons: buttons)
            }
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 5) {
                    TextField("Add a Comment", text: $viewModel.message).padding(10)
                    Button(action: viewModel.addReply) {
                        Text("Send").padding(10).foregroundColor(viewModel.message.isEmpty ? .gray : .red).overlay(RoundedRectangle(cornerRadius: 2).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1))
                    }
                }.padding(5)
            }
        }.onAppear(perform: viewModel.getPost).navigationBarTitleDisplayMode(.inline).navigationBarItems(trailing: Button("Test") {}.actionSheet(isPresented: $viewModel.isShowingActionSheet) {
            var buttons = [ActionSheet.Button]()
            
            buttons.append(.default(Text("Copy Content")) {
            })
            buttons.append(.cancel())
            return ActionSheet(title: Text("Selection Action"), buttons: buttons)
        })
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView()
    }
}
