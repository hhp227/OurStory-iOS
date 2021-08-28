//
//  MainView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var drawerViewModel: DrawerViewModel = {
        let drawer = DrawerViewModel()
        
        drawer.setDrawer(view: DrawerView(type: .left), widthType: .percent(rate: 0.8), shadowRadius: 10)
        return drawer
    }()
    
    @State var main: AnyView
    
    @EnvironmentObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                main.onReceive(drawerViewModel.$route) { route in
                    switch route {
                    case "Lounge":
                        main = AnyView(MainContainer(content: LoungeView(), drawerViewModel: drawerViewModel))
                        break
                    case "Group":
                        main = AnyView(MainContainer(content: GroupView(), drawerViewModel: drawerViewModel))
                        break
                    case "Chat": 
                        main = AnyView(MainContainer(content: ChatView(), drawerViewModel: drawerViewModel))
                        break
                    case "Logout":
                        viewModel.loginState = .logout
                        
                        UserDefaults.standard.removeObject(forKey: "user")
                        break
                    default:
                        break
                    }
                }.navigationBarTitle(Text(drawerViewModel.route), displayMode: .inline).navigationBarItems(leading: Text("left").onTapGesture {
                    self.drawerViewModel.show(type: .left, isShow: true)
                })
            }
            drawerViewModel.drawerView[.left]
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(main: AnyView(EmptyView()))
    }
}
