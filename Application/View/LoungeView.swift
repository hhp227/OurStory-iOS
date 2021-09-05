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
                    ForEach(viewModel.posts) { post in
                        CardView {
                            VStack(alignment: .leading, spacing: 0) {
                                NavigationLink(destination: PostDetailView()) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(alignment: .top) {
                                            AsyncImage(url: URL(string: URL_USER_PROFILE_IMAGE + (post.profileImage ?? ""))!).frame(width: 60, height: 60).cornerRadius(45)
                                            VStack(alignment: .leading) {
                                                Text(post.name).fontWeight(.bold)
                                                Text(post.timeStamp)
                                            }.padding([.leading, .trailing], 8)
                                        }.padding([.top, .leading, .trailing])
                                        if !post.text.isEmpty {
                                            Text(post.text).padding()
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
                                        Button(action: viewModel.actionLike) {
                                            Text("hello")
                                        }
                                    }.frame(maxWidth: .infinity).padding()
                                    Divider()
                                    NavigationLink(destination: PostDetailView(), label: {
                                        HStack {
                                            Text("Comment")
                                            if post.replyCount > 0 {
                                                Text(String(post.replyCount))
                                            }
                                        }.frame(maxWidth: .infinity).padding()
                                    })
                                }
                            }
                        }
                    }
                }.padding([.top, .bottom], 8).onAppear {
                    viewModel.getPosts()
                }
            }.ignoresSafeArea(.all, edges: .top)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: WriteView().environmentObject(WriteViewModel())) {
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
