//
//  CreateGroupView.swift
//  Application
//
//  Created by 홍희표 on 2021/08/31.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct CreateGroupView: View {
    @StateObject var viewModel = InjectorUtils.instance.provideCreateGroupViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter Group Title", text: $viewModel.state.title)
            Image("add_photo").resizable().aspectRatio(contentMode: .fit)
            TextEditor(text: $viewModel.state.description)
            Spacer()
        }
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
    }
}
