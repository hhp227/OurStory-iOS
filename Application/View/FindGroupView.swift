//
//  GroupFindView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/31.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct FindGroupView: View {
    @ObservedObject var viewModel = InjectorUtils.provideFindGroupViewModel(InjectorUtils.instance)()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                List {
                    ForEach(viewModel.state.groups) { group in
                        Text("Groups \(group.description ?? "noname")")
                    }
                }.onAppear(perform: viewModel.fetchGroups)
            }
            if viewModel.state.isLoading {
                Spinner(style: .medium)
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
