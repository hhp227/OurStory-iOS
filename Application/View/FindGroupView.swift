//
//  GroupFindView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/31.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct FindGroupView: View {
    @StateObject var viewModel = InjectorUtils.provideFindGroupViewModel(InjectorUtils.instance)()
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.state.groups) { group in
                        GroupListCell(group: group)
                    }
                }.refreshable {
                    print("refresh")
                }.onAppear {
                    viewModel.fetchGroups(viewModel.state.offset)
                }
            }
            if viewModel.state.isLoading {
                Spinner(isAnimating: true, style: .medium)
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct GroupFindView_Previews: PreviewProvider {
    static var previews: some View {
        FindGroupView()
    }
}
