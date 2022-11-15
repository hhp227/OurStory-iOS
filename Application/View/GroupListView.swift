//
//  GroupListView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct GroupListView: View {
    @StateObject var viewModel: GroupListViewModel = InjectorUtils.provideGroupListViewModel(InjectorUtils.instance)()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, GroupListView!")
        }
        .padding()
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}
