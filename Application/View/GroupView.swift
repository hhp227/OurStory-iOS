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
        VStack {
            HStack {
                NavigationLink(destination: GroupFindView()) {
                    VStack {
                        Image(systemName: "phone.fill")
                        Text("first Item")
                    }
                }
                NavigationLink(destination: NotJoinedGroupView()) {
                    VStack {
                        Image(systemName: "phone.fill")
                        Text("first Item")
                    }
                }
                NavigationLink(destination: CreateGroupView()) {
                    VStack {
                        Image(systemName: "phone.fill")
                        Text("first Item")
                    }
                }
            }.frame(height: 70, alignment: .center)
            Divider()
            Text("Group View")
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
