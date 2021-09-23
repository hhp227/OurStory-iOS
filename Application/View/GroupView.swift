//
//  GroupView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct GroupView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                NavigationLink(destination: GroupFindView()) {
                    VStack {
                        Image(systemName: "phone.fill")
                        Text("first Item")
                    }
                }.frame(maxWidth: .infinity)
                NavigationLink(destination: NotJoinedGroupView()) {
                    VStack {
                        Image(systemName: "phone.fill")
                        Text("first Item")
                    }
                }.frame(maxWidth: .infinity)
                NavigationLink(destination: CreateGroupView()) {
                    VStack {
                        Image(systemName: "phone.fill")
                        Text("first Item")
                    }
                }.frame(maxWidth: .infinity)
            }.frame(height: 70, alignment: .center)
            Divider()
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 2), spacing: 2) {
                    ForEach(1...20, id: \.self) { index in
                        CardView {
                            Text("Group \(index)")
                        }.frame(height: 120)
                    }
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
