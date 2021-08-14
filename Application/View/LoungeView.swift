//
//  LoungeView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/13.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct LoungeView: View {
    @EnvironmentObject var drawerViewModel: DrawerViewModel
    
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).navigationBarTitle(Text("Home"), displayMode: .inline)
                .navigationBarItems(leading: Text("left").onTapGesture {
                    self.drawerViewModel.show(type: .left, isShow: true)
                })
        }
    }
}

struct LoungeView_Previews: PreviewProvider {
    static var previews: some View {
        LoungeView()
    }
}
