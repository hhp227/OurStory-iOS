//
//  ProfileView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/12.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State var currentSelection: Int = 0
    
    var body: some View {
        NavigationView {
            PagerTabView(tint: .black, selection: $currentSelection, labels: {
                Image(systemName: "house.fill")
                    .pageLabel()
                Image(systemName: "person.fill")
                    .pageLabel()
            }, content: {
                MyInfoView()
                    .pageView(ignoresSafeArea: true, edges: .bottom)
                MyPostView()
                    .pageView(ignoresSafeArea: true, edges: .bottom)
            })
            .padding(.top)
            .navigationTitle("Profile")
            .navigationBarItems(leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "xmark")
            })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
