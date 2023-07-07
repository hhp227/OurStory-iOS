//
//  LoungeView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/13.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct LoungeView: View {
    @StateObject
    var viewModel: LoungeViewModel = InjectorUtils.instance.provideLoungeViewModel()
    
    private var fab: some View {
        NavigationLink(destination: CreatePostView(onResult: {})) {
            Text("+").font(.system(.largeTitle)).frame(width: 66, height: 60).foregroundColor(.white).padding(.bottom, 7)
        }.background(Color.blue).cornerRadius(38.5).padding().shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
    }
    
    var body: some View {
        ZStack {
            PostList(lazyPagingItems: viewModel.posts.collectAsLazyPagingItems())
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    fab
                }
            }
        }
    }
}

struct PostList: View {
    @State
    private var headerVisibleRatio: CGFloat = 1

    @State
    private var scrollOffset: CGPoint = .zero
    
    @ObservedObject
    var lazyPagingItems: LazyPagingItems<PostItem>
    
    var body: some View {
        CollapsingNavigationBarView(
            headerHeight: 250,
            onScroll: handleScrollOffset,
            header: header
        ) {
            LazyVStack(spacing: 10) {
                ForEach(lazyPagingItems) { $post in
                    PostListCell(post: $post, onLikeClick: { /*viewModel.togglePostLike(post)*/ }, onResult: /*viewModel.refreshPosts*/{})
                }
                HStack {
                    if lazyPagingItems.loadState.refresh is LoadState.Loading {
                        ProgressView()
                    } else if lazyPagingItems.loadState.append is LoadState.Loading {
                        ProgressView()
                    } else if lazyPagingItems.loadState.refresh is LoadState.Error {
                        
                    } else if lazyPagingItems.loadState.append is LoadState.Error {
                        
                    }
                }
            }
        }
    }
    
    func header() -> some View {
        ZStack(alignment: .bottomLeading) {
            // headerView
            ZStack {
                Color.red
                //ScrollViewHeaderImage(image: Image("header"))
                //ScrollViewHeaderGradient(.black.opacity(0.2), .black.opacity(0.5))
            }
            //ScrollViewHeaderGradient()
            //headerTitle.previewHeaderContent()
        }
    }
    
    func handleScrollOffset(_ offset: CGPoint, headerVisibleRatio: CGFloat) {
        self.scrollOffset = offset
        self.headerVisibleRatio = headerVisibleRatio
    }
}

struct LoungeView_Previews: PreviewProvider {
    static var previews: some View {
        LoungeView()
    }
}
