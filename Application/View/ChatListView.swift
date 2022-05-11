//
//  ChatListView.swift
//  Application
//
//  Created by 홍희표 on 2021/09/23.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct ChatListView: View {
    @StateObject var viewModel: ChatListViewModel = InjectorUtils.provideChatListViewModel(InjectorUtils.instance)()
    
    var body: some View {
        List {
            ForEach(0..<100) { i in
                NavigationLink(destination: ChatView()) {
                    Text("Chat Room \(i)")
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
