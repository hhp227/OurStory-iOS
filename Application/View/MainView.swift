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
        
        drawer.setMain(view: LoungeView())
        drawer.setDrawer(view: DrawerView(type: .left), widthType: .percent(rate: 0.8), shadowRadius: 10)
        return drawer
    }()
    
    
    var body: some View {
        ZStack {
            drawerViewModel.main
            drawerViewModel.drawerView[.left]
        }.navigationBarHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
