//
//  MainView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @StateObject private var drawerViewModel: DrawerViewModel = {
        let drawer = DrawerViewModel()
        
        drawer.setDrawer(view: DrawerView(type: .left), widthType: .percent(rate: 0.8), shadowRadius: 10)
        return drawer
    }()
    
    private static let MAX_MASK_ALPHA: CGFloat = 0.25
    
    var body: some View {
        ZStack {
            NavigationView {
                switch drawerViewModel.route {
                case "Lounge":
                    LoungeView().navigationBarItems(leading: Button(action: { drawerViewModel.show(type: .left, isShow: true) }) {
                        Image("hamburger-menu-icon").colorMultiply(.accentColor)
                    })
                case "GroupList":
                    GroupListView().navigationBarItems(leading: Button(action: { drawerViewModel.show(type: .left, isShow: true) }) {
                        Image("hamburger-menu-icon").colorMultiply(.accentColor)
                    })
                case "FriendList":
                    FriendView().navigationBarItems(leading: Button(action: { drawerViewModel.show(type: .left, isShow: true) }) {
                        Image("hamburger-menu-icon").colorMultiply(.accentColor)
                    })
                case "ChatList":
                    ChatListView().navigationBarItems(leading: Button(action: { drawerViewModel.show(type: .left, isShow: true) }) {
                        Image("hamburger-menu-icon").colorMultiply(.accentColor)
                    })
                case "Logout":
                    Text("Logout").onAppear {
                        UserDefaultsManager.instance.clear()
                    }
                default:
                    EmptyView()
                }
            }
            Color.black.opacity(Double(drawerViewModel.maxShowRate * MainView.MAX_MASK_ALPHA)).onTapGesture(perform: drawerViewModel.hideAll).ignoresSafeArea()
            drawerViewModel.drawerView[.left]
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
