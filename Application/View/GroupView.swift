//
//  GroupView.swift
//  Application
//
//  Created by 홍희표 on 2021/07/29.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct GroupView: View {
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(systemName: "phone.fill")
                    Text("first Item")
                }
                VStack {
                    Image(systemName: "phone.fill")
                    Text("first Item")
                }
                VStack {
                    Image(systemName: "phone.fill")
                    Text("first Item")
                }
            }.frame(width: .infinity, height: 70, alignment: .center)
            Divider()
            Text("Group View")
        }.frame(width: .infinity, height: .infinity, alignment: .top)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
