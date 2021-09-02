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
                VStack(spacing: 0) {
                    ForEach(viewModel.posts) { post in
                        Text("Mock Data \(post.id)").onTapGesture {
                            viewModel.getPosts()
                        }
                    }
                }.onAppear {
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
