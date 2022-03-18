//
//  NotJoinedGroupView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/31.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct NotJoinedGroupView: View {
    @ObservedObject var viewModel = NotJoinedGroupViewModel(InjectorUtils.instance.getGroupRepository())
    
    var body: some View {
        Text("Hello, NotJoinedGroupView")
    }
}

struct NotJoinedGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NotJoinedGroupView()
    }
}
