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
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Image("profile_img_circle").resizable().aspectRatio(contentMode: .fit).frame(width: 90, height: 90, alignment: .center)
                Text("Hello, World!").padding(.top, 8)
                Text("E-mail").font(.system(size: 12))
            }.frame(maxWidth: .infinity, alignment: .topLeading).padding(16)
            Divider()
            DrawerButton(icon: "text.bubble", label: "Lounge", isSelected: drawerViewModel.route == "Lounge") {
                drawerViewModel.route = "Lounge"
                
                drawerViewModel.hideAll()
            }
            DrawerButton(icon: "person.2", label: "Group", isSelected: drawerViewModel.route == "Group") {
                drawerViewModel.route = "Group"
                
                drawerViewModel.hideAll()
            }
            DrawerButton(icon: "message", label: "Chat List", isSelected: drawerViewModel.route == "Chat") {
                drawerViewModel.route = "Chat"
                
                drawerViewModel.hideAll()
            }
            DrawerButton(icon: "rectangle.righthalf.inset.fill.arrow.right", label: "Logout", isSelected: false) {
                drawerViewModel.route = "Logout"
                
                drawerViewModel.hideAll()
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    init(type: DrawerType) {
        self.type = type
    }
}

struct DrawerButton: View {
    var icon: String
    
    var label: String
    
    var isSelected: Bool
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                    Text(label)
                }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(isSelected ? .purple : .gray)
            }
        }.padding(8).background(isSelected ? Color("DrawerButtonColor") : Color.clear).cornerRadius(4).padding(8)
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(type: .left)
    }
}
