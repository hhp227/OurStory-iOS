//
//  GroupFindView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/31.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct GroupFindView: View {
    @ObservedObject var viewModel = GroupFindViewModel(.init(ApiServiceImpl()))
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(viewModel.state.groups) { group in
                    Text("Groups \(group.description ?? "noname")")
                }
            }.onAppear(perform: viewModel.getGroups)
        }
    }
}

struct GroupFindView_Previews: PreviewProvider {
    static var previews: some View {
        GroupFindView()
    }
}
