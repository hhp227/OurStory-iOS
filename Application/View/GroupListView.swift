//
//  GroupListView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct GroupListView: View {
    @EnvironmentObject var viewModel: GroupListViewModel
    
    private var topNavigationLinks: some View {
        HStack(alignment: .bottom) {
            NavigationLink(destination: GroupFindView()) {
                VStack(spacing: 5) {
                    Image(systemName: "magnifyingglass").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25)
                    Text("Find a Groups").font(.system(size: 14)).fixedSize()
                }
            }.frame(maxWidth: .infinity)
            NavigationLink(destination: NotJoinedGroupView()) {
                VStack(spacing: 0) {
                    Image(systemName: "person.2.fill").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).frame(width: 33, height: 33)
                    Text("Join Request Groups").font(.system(size: 14)).fixedSize()
                }
            }.frame(maxWidth: .infinity)
            NavigationLink(destination: CreateGroupView(viewModel: .init())) {
                VStack(spacing: 5) {
                    Image(systemName: "plus").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25)
                    Text("Create Group").font(.system(size: 14)).fixedSize()
                }
            }.frame(maxWidth: .infinity)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            topNavigationLinks.frame(height: 70, alignment: .center).padding(.horizontal)
            Divider()
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 2), spacing: 2) {
                    ForEach(Array(viewModel.state.groups.enumerated()), id: \.offset) { index, group in
                        NavigationLink(destination: GroupView()) {
                            CardView {
                                Text("Group \(index)")
                            }.frame(height: 120)
                        }
                    }
                }.onAppear(perform: viewModel.getGroups)
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
