//
//  LoungeView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/13.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct LoungeView: View {
    @EnvironmentObject var viewModel: LoungeViewModel
    
    var body: some View {
        ZStack {
            CollapsingNavigationBar(scrollUpBehavior: .sticky, scrollDownBehavior: .offset, header: {
                Image("image3").resizable().aspectRatio(contentMode: .fill)
            }) {
                VStack(spacing: 10) {
                    ForEach(Array(viewModel.state.posts.enumerated()), id: \.offset) { i, post in
                        CardView {
                            VStack(alignment: .leading, spacing: 0) {
                                NavigationLink(destination: PostDetailView().environmentObject(PostDetailViewModel(.init(ApiServiceImpl()), .init(ApiServiceImpl()), UserDefaultsManager.instance, post.id))) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(alignment: .top) {
                                            AsyncImage(url: URL(string: URL_USER_PROFILE_IMAGE + (post.profileImage ?? ""))!).frame(width: 57, height: 57).cornerRadius(45)
                                            VStack(alignment: .leading) {
                                                Text(post.name).fontWeight(.bold)
                                                Text(DateUtil.getPeriodTimeGenerator(post.timeStamp))
                                            }.padding([.leading, .trailing], 8)
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
                                Divider()
                                HStack(alignment: .center) {
                                    HStack {
                                        if post.likeCount > 0 {
                                            Image(systemName: "heart.fill")
                                        }
                                        Button(action: { viewModel.togglePostLike(i, post) }) {
                                            Text("Like")
                                            if post.likeCount > 0 {
                                                Text(String(post.likeCount))
                                            }
                                        }
                                    }.frame(maxWidth: .infinity).padding(10)
                                    Divider()
                                    NavigationLink(destination: PostDetailView().environmentObject(PostDetailViewModel(.init(ApiServiceImpl()), .init(ApiServiceImpl()), UserDefaultsManager.instance, post.id)), label: {
                                        HStack {
                                            Text("Comment")
                                            if post.replyCount > 0 {
                                                Text(String(post.replyCount))
                                            }
                                        }.frame(maxWidth: .infinity).padding(10)
                                    })
                                }
                            }
                        }.onAppear {
                            /*if viewModel.state.posts.last == post {
                                print("getNext \(i)")
                                viewModel.fetchPosts()
                            }*/
                        }
                    }
                    if viewModel.state.canLoadNextPage {
                        // TODO loading indicator
                        Text("Loading")
                    }
                }.padding([.top, .bottom], 8).onAppear {
                    viewModel.fetchPosts(0, viewModel.state.offset)
                }
            }.ignoresSafeArea(.all, edges: .top)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: CreatePostView().environmentObject(CreatePostViewModel(.init(ApiServiceImpl()), UserDefaultsManager.instance, 0))) {
                        Text("+").font(.system(.largeTitle)).frame(width: 66, height: 60).foregroundColor(.white).padding(.bottom, 7)
                    }.background(Color.blue).cornerRadius(38.5).padding().shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3).animation(.none)
                }
            }
        }
    }
}

struct LoungeView_Previews: PreviewProvider {
    static var previews: some View {
        LoungeView()
    }
}
