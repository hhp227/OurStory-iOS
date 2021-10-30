//
//  ReplyModifyView.swift
//  Application
//
//  Created by 홍희표 on 2021/10/04.
//  Copyright © 2021 홍희표. All rights reserved.
//

import SwiftUI

struct ReplyModifyView: View {
    @EnvironmentObject var viewModel: PostDetailViewModel
    
    var body: some View {
        InputView(text: viewModel.selectPosition < 0 ? "" : viewModel.state.replys[viewModel.selectPosition].reply, action: viewModel.setReply).navigationBarTitleDisplayMode(.inline)
    }
}

struct InputView: View {
    @State var text: String
    
    var action: (String) -> Void
    
    var body: some View {
        List {
            ZStack {
                TextEditor(text: $text).autocapitalization(.none).keyboardType(.default).disableAutocorrection(true)
                Text(text).opacity(0).padding(.all, 8)
            }.listRowInsets(EdgeInsets()).shadow(radius: 1)
        }.navigationBarItems(trailing: Button(action: { action(text) }) { Text("Send") })
    }
}

struct ReplyModifyView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyModifyView()
    }
}
