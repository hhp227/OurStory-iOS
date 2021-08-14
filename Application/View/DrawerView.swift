//
//  DrawerView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/13.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct DrawerView: View, DrawerProtocol {
    @EnvironmentObject var drawerViewModel: DrawerViewModel
    
    var type: DrawerType
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    init(type: DrawerType) {
        self.type = type
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(type: .left)
    }
}
